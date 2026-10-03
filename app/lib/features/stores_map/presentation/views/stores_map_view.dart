// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/location_service.dart';
import 'package:stylebox/features/stores_map/data/route_service.dart';
import 'package:stylebox/features/stores_map/data/store_location.dart';
import 'package:stylebox/features/stores_map/data/stores_location_source.dart';
import 'package:stylebox/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/store_map_card.dart';
import 'widgets/store_map_pin.dart';

/// All stores on a map, with the route from the customer to the chosen one.
class StoresMapView extends StatefulWidget {
  static const String routeName = '/storesMap';

  const StoresMapView({super.key, this.focusStoreId, this.showRoute = false});

  /// Store to select when the map opens (e.g. from a box's Location row).
  final String? focusStoreId;

  /// Draw the route to [focusStoreId] right away.
  final bool showRoute;

  @override
  State<StoresMapView> createState() => _StoresMapViewState();
}

class _StoresMapViewState extends State<StoresMapView>
    with TickerProviderStateMixin {
  static const _cairo = LatLng(30.0444, 31.2357);

  /// Keeps fitted pins clear of the floating top bar and the card strip.
  /// Pins stand ~70px above their point, hence the large top value.
  EdgeInsets get _fitPadding => EdgeInsets.fromLTRB(
    70,
    170 + (_isDemo ? 60 : 0) + (_route != null || _routing ? 54 : 0),
    70,
    290,
  );

  final _mapController = MapController();
  final _pageController = PageController(viewportFraction: 0.9);
  StreamSubscription<List<StoreLocation>>? _storesSub;
  AnimationController? _cameraAnimation;

  List<StoreLocation> _stores = [];
  bool _loading = true;
  bool _mapReady = false;
  bool _didInitialCamera = false;
  String? _selectedId;

  StoreRoute? _route;
  String? _routeStoreId;
  bool _routing = false;

  LatLng? get _me => LocationService.position.value;

  bool get _isDemo => _stores.isNotEmpty && _stores.first.isDemo;

  int get _selectedIndex => _stores.indexWhere((s) => s.id == _selectedId);

  @override
  void initState() {
    super.initState();
    _selectedId = widget.focusStoreId;
    LocationService.position.addListener(_onPositionChanged);
    _storesSub = watchStoreLocations().listen(
      _onStores,
      onError: (_) => _onStores(const []),
    );
    // Finding the nearest store is the point of this screen, so ask now
    // (the route button asks again if this is refused).
    if (!widget.showRoute) _locate(moveCamera: false, silent: true);
  }

  @override
  void dispose() {
    LocationService.position.removeListener(_onPositionChanged);
    _storesSub?.cancel();
    _cameraAnimation?.dispose();
    _pageController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ── Data ──────────────────────────────────────────────────────────────────

  void _onStores(List<StoreLocation> stores) {
    if (!mounted) return;
    setState(() {
      _stores = _sortedByDistance(stores);
      _loading = false;
      if (_selectedIndex == -1) {
        _selectedId = _stores.isEmpty ? null : _stores.first.id;
      }
    });
    _syncPage();
    _applyInitialCamera();
  }

  void _onPositionChanged() {
    if (!mounted) return;
    setState(() => _stores = _sortedByDistance(_stores));
    _syncPage();
  }

  List<StoreLocation> _sortedByDistance(List<StoreLocation> stores) {
    final me = _me;
    if (me == null) return stores;
    return [...stores]..sort(
      (a, b) => LocationService.distanceKm(
        me,
        a.point,
      ).compareTo(LocationService.distanceKm(me, b.point)),
    );
  }

  double? _distanceTo(StoreLocation store) {
    if (_route != null && _routeStoreId == store.id) return _route!.distanceKm;
    final me = _me;
    return me == null ? null : LocationService.distanceKm(me, store.point);
  }

  // ── Camera ────────────────────────────────────────────────────────────────

  void _applyInitialCamera() {
    if (!_mapReady || _didInitialCamera || _stores.isEmpty) return;
    _didInitialCamera = true;

    final focus = _stores.where((s) => s.id == widget.focusStoreId);
    if (focus.isNotEmpty) {
      _mapController.move(focus.first.point, 15);
      if (widget.showRoute) _showRoute(focus.first);
    } else {
      _fitPoints(_overviewPoints(), animate: false);
      // Opened for a store that has no pin yet: still show the customer.
      if (widget.showRoute) _locate(moveCamera: false, silent: true);
    }
  }

  /// All stores, plus the customer when they're in the same city.
  List<LatLng> _overviewPoints() {
    final points = _stores.map((s) => s.point).toList();
    final me = _me;
    if (me != null &&
        points.any((p) => LocationService.distanceKm(me, p) < 80)) {
      points.add(me);
    }
    return points;
  }

  void _fitPoints(List<LatLng> points, {bool animate = true}) {
    if (!_mapReady || points.isEmpty) return;
    if (points.length == 1) {
      _moveCamera(points.first, 15, animate: animate);
      return;
    }
    final target = CameraFit.coordinates(
      coordinates: points,
      padding: _fitPadding,
      maxZoom: 16,
    ).fit(_mapController.camera);
    _moveCamera(target.center, target.zoom, animate: animate);
  }

  void _moveCamera(LatLng center, double zoom, {bool animate = true}) {
    _cameraAnimation?.dispose();
    _cameraAnimation = null;
    if (!animate) {
      _mapController.move(center, zoom);
      return;
    }

    final from = _mapController.camera;
    final lat = Tween(begin: from.center.latitude, end: center.latitude);
    final lng = Tween(begin: from.center.longitude, end: center.longitude);
    final z = Tween(begin: from.zoom, end: zoom);
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    final curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );
    controller.addListener(() {
      _mapController.move(
        LatLng(lat.evaluate(curve), lng.evaluate(curve)),
        z.evaluate(curve),
      );
    });
    _cameraAnimation = controller;
    controller.forward();
  }

  // ── Selection ─────────────────────────────────────────────────────────────

  void _select(StoreLocation store, {bool scrollCards = false}) {
    setState(() => _selectedId = store.id);
    if (scrollCards) {
      final index = _selectedIndex;
      if (index != -1 && _pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
    if (_route != null && _routeStoreId == store.id) {
      _fitPoints(_route!.points);
    } else {
      final zoom = _mapController.camera.zoom;
      _moveCamera(store.point, zoom < 14 ? 14 : zoom);
    }
  }

  void _onPageChanged(int index) {
    if (index < 0 || index >= _stores.length) return;
    final store = _stores[index];
    // Ignore jumps made by _syncPage after re-sorting.
    if (store.id == _selectedId) return;
    _select(store);
  }

  /// Keeps the card strip on the selected store after the list re-sorts.
  void _syncPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = _selectedIndex;
      if (!mounted || index == -1 || !_pageController.hasClients) return;
      if (_pageController.page?.round() != index) {
        _pageController.jumpToPage(index);
      }
    });
  }

  // ── Location & route ──────────────────────────────────────────────────────

  Future<void> _locate({bool moveCamera = true, bool silent = false}) async {
    final result = await LocationService.request();
    if (!mounted) return;
    if (result.point != null && moveCamera) {
      _moveCamera(result.point!, 15);
    }
    if (result.issue != null && !silent) _showLocationIssue(result.issue!);
  }

  Future<void> _showRoute(StoreLocation store) async {
    setState(() {
      _selectedId = store.id;
      _routing = true;
      _routeStoreId = store.id;
      _route = null;
    });

    final location = await LocationService.request();
    if (!mounted) return;
    final me = location.point;
    if (me == null) {
      setState(() => _routing = false);
      _showLocationIssue(location.issue ?? LocationIssue.unavailable);
      return;
    }

    final route = await RouteService.drivingRoute(me, store.point);
    if (!mounted || _routeStoreId != store.id) return;
    setState(() {
      _route = route;
      _routing = false;
    });
    _fitPoints(route.points);
  }

  void _clearRoute() {
    setState(() {
      _route = null;
      _routeStoreId = null;
      _routing = false;
    });
  }

  Future<void> _openGoogleMaps(StoreLocation store) async {
    final opened = await RouteService.openInGoogleMaps(
      store.point,
    ).catchError((_) => false);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.mapGoogleMapsFailed)),
      );
    }
  }

  void _showLocationIssue(LocationIssue issue) {
    final locale = S.of(context)!;
    final message = switch (issue) {
      LocationIssue.serviceDisabled => locale.mapLocationServiceOff,
      LocationIssue.denied ||
      LocationIssue.deniedForever => locale.mapLocationDenied,
      LocationIssue.unavailable => locale.mapLocationUnavailable,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: issue == LocationIssue.unavailable
              ? null
              : SnackBarAction(
                  label: locale.mapOpenSettings,
                  onPressed: () => LocationService.openSettings(issue),
                ),
        ),
      );
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(context),
          _buildTopBar(context),
          _buildBottom(context),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (!_loading && _stores.isEmpty) _buildEmptyState(context),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    final selected = _stores.where((s) => s.id == _selectedId);
    // Selected pin last so it's drawn on top of the others.
    final ordered = [
      ..._stores.where((s) => s.id != _selectedId),
      ...selected,
    ];
    final route = _route;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _cairo,
        initialZoom: 11,
        minZoom: 4,
        maxZoom: 18,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onMapReady: () {
          _mapReady = true;
          _applyInitialCamera();
        },
      ),
      children: [
        storesTileLayer(context),
        if (route != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route.points,
                strokeWidth: 6,
                color: KprimaryColor,
                borderStrokeWidth: 2.5,
                borderColor: Colors.white,
                pattern: route.isStraightLine
                    ? StrokePattern.dashed(segments: const [14, 10])
                    : const StrokePattern.solid(),
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (_me != null)
              Marker(
                point: _me!,
                width: 34,
                height: 34,
                child: const UserLocationDot(),
              ),
            for (final store in ordered)
              Marker(
                key: ValueKey(store.id),
                point: store.point,
                width: StoreMapPin.markerWidth,
                height: StoreMapPin.markerHeight,
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => _select(store, scrollCards: true),
                  child: StoreMapPin(
                    store: store,
                    selected: store.id == _selectedId,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final locale = S.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? KdarkModeCardColor : KlightModeCardColor;
    final textColor = isDark ? KdarkModeTextColor : KlightModeTextColor;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _roundButton(
                  surface: surface,
                  onTap: () => Navigator.of(context).pop(),
                  child: IconTheme(
                    data: IconThemeData(color: textColor, size: 20),
                    child: const BackButtonIcon(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: _floating(surface),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.storefront_rounded,
                          color: KprimaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            locale.mapTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (_stores.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: KprimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_stores.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Tooltip(
                  message: locale.mapShowAll,
                  child: _roundButton(
                    surface: surface,
                    onTap: () => _fitPoints(_overviewPoints()),
                    child: const Icon(
                      Icons.zoom_out_map_rounded,
                      color: KprimaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            if (_isDemo) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: _floating(KaccentColor),
                child: Text(
                  locale.mapDemoBanner,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (_routing) ...[
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: _floating(surface),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        locale.mapRouteLoading,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_route != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(14, 4, 4, 4),
                  decoration: _floating(KprimaryColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _route!.isStraightLine
                            ? Icons.straighten_rounded
                            : Icons.directions_car_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _routeLabel(locale, _route!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: _clearRoute,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _routeLabel(S locale, StoreRoute route) {
    final km = locale.mapDistanceKm(formatKm(route.distanceKm));
    final time = route.isStraightLine
        ? locale.mapRouteStraightLine
        : locale.mapRouteMinutes('${route.minutes}');
    return '$km · $time';
  }

  Widget _buildBottom(BuildContext context) {
    final locale = S.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? KdarkModeCardColor : KlightModeCardColor;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // OpenStreetMap requires visible attribution.
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse('https://www.openstreetmap.org/copyright'),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: surface.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '© OpenStreetMap',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? KdarkModeTextSecondary
                              : KlightModeTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Tooltip(
                    message: locale.mapMyLocation,
                    child: _roundButton(
                      surface: surface,
                      size: 50,
                      onTap: () => _locate(),
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: Color(0xFF1A73E8),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_stores.isNotEmpty)
              SizedBox(
                height: 172,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _stores.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final store = _stores[index];
                    final isRouted = _routeStoreId == store.id;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: StoreMapCard(
                        store: store,
                        selected: store.id == _selectedId,
                        distanceKm: _distanceTo(store),
                        route: isRouted ? _route : null,
                        routing: isRouted && _routing,
                        onTap: () => _select(store),
                        onDirections: () => _showRoute(store),
                        onGoogleMaps: () => _openGoogleMaps(store),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final locale = S.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: _floating(
          isDark ? KdarkModeCardColor : KlightModeCardColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wrong_location_outlined,
              size: 48,
              color: KprimaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              locale.mapNoStoresTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              locale.mapNoStoresSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? KdarkModeTextSecondary
                    : KlightModeTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _floating(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _roundButton({
    required Color surface,
    required VoidCallback onTap,
    required Widget child,
    double size = 44,
  }) {
    return Material(
      color: surface,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black38,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: size, height: size, child: Center(child: child)),
      ),
    );
  }
}

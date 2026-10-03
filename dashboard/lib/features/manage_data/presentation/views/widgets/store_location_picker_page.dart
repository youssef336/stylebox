import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:stylebox_dashboard/features/manage_data/domain/entities/restaurant_entity.dart';

/// Full-screen map where the owner drags the map under a fixed pin to mark
/// the store entrance. Pops with the chosen [StorePin].
class StoreLocationPickerPage extends StatefulWidget {
  const StoreLocationPickerPage({super.key, this.initial, this.title});

  final StorePin? initial;
  final String? title;

  static Future<StorePin?> open(
    BuildContext context, {
    StorePin? initial,
    String? title,
  }) {
    return Navigator.of(context).push<StorePin>(
      MaterialPageRoute(
        builder: (_) => StoreLocationPickerPage(initial: initial, title: title),
      ),
    );
  }

  @override
  State<StoreLocationPickerPage> createState() =>
      _StoreLocationPickerPageState();
}

class _StoreLocationPickerPageState extends State<StoreLocationPickerPage> {
  static const _cairo = LatLng(30.0444, 31.2357);

  final _mapController = MapController();
  late LatLng _center = widget.initial == null
      ? _cairo
      : LatLng(widget.initial!.latitude, widget.initial!.longitude);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          widget.title ?? 'Pin store location',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: widget.initial == null ? 11 : 17,
              minZoom: 4,
              maxZoom: 19,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onPositionChanged: (camera, _) =>
                  setState(() => _center = camera.center),
              onTap: (_, point) =>
                  _mapController.move(point, _mapController.camera.zoom),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.stylebox.dashboard',
              ),
              const SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
                alignment: Alignment.topRight,
              ),
            ],
          ),
          // Fixed pin; its tip marks the map center.
          IgnorePointer(
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 52,
                  color: AppColors.primaryColor,
                  shadows: [Shadow(color: Colors.black38, blurRadius: 8)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Move the map until the pin sits on the store entrance. '
                      'Customers get directions to this exact spot.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6E6A80)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_center.latitude.toStringAsFixed(5)}, '
                      '${_center.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14121F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop((
                        latitude: _center.latitude,
                        longitude: _center.longitude,
                      )),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text(
                        'Use this location',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

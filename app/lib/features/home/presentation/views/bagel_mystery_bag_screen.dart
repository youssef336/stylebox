// ignore_for_file: unused_element, use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/entities/review_analytics_entity.dart';
import 'package:stylebox/core/entities/review_entity.dart';
import 'package:stylebox/core/services/favorites_store.dart';
import 'package:stylebox/core/widgets/box_artwork.dart';
import 'package:stylebox/core/entities/demo_products.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:stylebox/core/services/get_it_service.dart';
import 'package:stylebox/core/services/location_service.dart';
import 'package:stylebox/features/stores_map/presentation/views/stores_map_view.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/products/products_cubit.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/products/products_state.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart/cart_cubit.dart';
import 'package:stylebox/features/home/domains/repos/product_reviews_repo.dart';
import 'package:stylebox/features/home/presentation/views/widgets/bagel_customer_reviews_section.dart';
import 'package:stylebox/features/home/presentation/views/widgets/review_composer_bottom_sheet.dart';
import 'package:stylebox/generated/l10n.dart';

class BagelMysteryBagScreen extends StatefulWidget {
  static const String routeName = '/bagelMysteryBag';

  const BagelMysteryBagScreen({
    super.key,
    required this.product,
    this.restaurant,
  });

  final ProductEntity product;
  final RestaurantEntity? restaurant;

  @override
  State<BagelMysteryBagScreen> createState() => _BagelMysteryBagScreenState();
}

class _BagelMysteryBagScreenState extends State<BagelMysteryBagScreen> {
  bool _reserved = false;
  bool _isReserving = false;
  late final ProductReviewsRepo _reviewsRepo;
  String? _fetchedBranchLocation;
  bool _locationFetched = false;
  late int _currentBagsLeft;
  LatLng? _storePoint;

  @override
  void initState() {
    super.initState();
    _reviewsRepo = getIt<ProductReviewsRepo>();
    _currentBagsLeft = widget.product.bagsLeft;
    final lat = widget.product.restaurantLatitude;
    final lng = widget.product.restaurantLongitude;
    if (lat != null && lng != null) _storePoint = LatLng(lat, lng);
    LocationService.position.addListener(_onPositionChanged);
    LocationService.currentIfPermitted();
    _fetchRestaurantLocation();
  }

  @override
  void dispose() {
    LocationService.position.removeListener(_onPositionChanged);
    super.dispose();
  }

  void _onPositionChanged() {
    if (mounted) setState(() {});
  }

  /// Real distance to the store, or null when either location is unknown.
  String? _distanceLabel(S locale) {
    final me = LocationService.position.value;
    final store = _storePoint;
    if (me == null || store == null) return null;
    return locale.mapDistanceKm(
      formatKm(LocationService.distanceKm(me, store)),
    );
  }

  void _openStoreOnMap() {
    Navigator.of(context).pushNamed(
      StoresMapView.routeName,
      arguments: {'storeId': widget.product.restaurantId, 'showRoute': true},
    );
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool _matchesEmbeddedProduct(Map<String, dynamic> productData) {
    final currentDocumentId = widget.product.documentId.trim();
    final candidateIds = <String>{
      productData['docId']?.toString().trim() ?? '',
      productData['productId']?.toString().trim() ?? '',
      productData['documentId']?.toString().trim() ?? '',
      productData['id']?.toString().trim() ?? '',
    }..removeWhere((value) => value.isEmpty);

    // Debug: print candidate ids and current doc id
    try {
      print(
        '🔍 _matchesEmbeddedProduct: currentDocumentId="$currentDocumentId" candidateIds=$candidateIds title=${productData['title'] ?? productData['nameEn']}',
      );
    } catch (_) {}

    if (currentDocumentId.isNotEmpty &&
        candidateIds.contains(currentDocumentId)) {
      return true;
    }

    return false;
  }

  bool _matchesLiveProduct(ProductEntity product) {
    final currentDocumentId = widget.product.documentId.trim();
    final candidateDocumentIds = <String>{
      product.documentId.trim(),
      product.restaurantId?.trim() ?? '',
    }..removeWhere((value) => value.isEmpty);

    if (currentDocumentId.isNotEmpty &&
        candidateDocumentIds.contains(currentDocumentId)) {
      return true;
    }

    return false;
  }

  ProductEntity? _liveProductFromState(ProductsState state) {
    if (state is! ProductsSuccess) {
      return null;
    }

    for (final product in state.products) {
      if (_matchesLiveProduct(product)) {
        return product;
      }
    }

    return null;
  }

  int _bagsLeftFromState(ProductsState state) {
    return _liveProductFromState(state)?.bagsLeft ?? _currentBagsLeft;
  }

  Future<void> _fetchRestaurantLocation() async {
    if (_locationFetched) return;

    final restaurantId = widget.product.restaurantId;
    print('📍 DEBUG: restaurantId = $restaurantId');
    if (restaurantId == null || restaurantId.isEmpty) {
      print('📍 DEBUG: restaurantId is null or empty');
      _locationFetched = true;
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final doc = await firestore
          .collection('resturants')
          .doc(restaurantId)
          .get();

      print('📍 DEBUG: doc.exists = ${doc.exists}');
      print('📍 DEBUG: doc.data() = ${doc.data()}');

      if (doc.exists) {
        final branchLocation = doc.data()?['branchLocation'] as String?;
        print('📍 DEBUG: branchLocation = "$branchLocation"');
        final lat = doc.data()?['latitude'];
        final lng = doc.data()?['longitude'];
        if (lat is num && lng is num) {
          _storePoint = LatLng(lat.toDouble(), lng.toDouble());
        }

        final products = List<dynamic>.from(
          doc.data()?['products'] as List? ?? [],
        );
        for (final productData in products) {
          if (productData is Map<String, dynamic> &&
              _matchesEmbeddedProduct(productData)) {
            _currentBagsLeft = _asInt(productData['bagsLeft']);
            print('📍 DEBUG: updated bagsLeft = $_currentBagsLeft');
            break;
          }
        }

        if (branchLocation != null && branchLocation.isNotEmpty) {
          setState(() {
            _fetchedBranchLocation = branchLocation;
            _locationFetched = true;
          });
          print('📍 DEBUG: Successfully set location');
          return;
        } else {
          print('📍 DEBUG: branchLocation is null or empty');
        }
      } else {
        print('📍 DEBUG: Restaurant document does not exist');
      }
    } catch (e, st) {
      print('📍 DEBUG: Error: $e\n$st');
    }

    setState(() {
      _locationFetched = true;
    });
  }

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color _backgroundColor(BuildContext context) {
    return _isDark(context) ? KdarkModeBgColor : KlightModeBgColor;
  }

  Color _cardColor(BuildContext context) {
    return _isDark(context) ? KdarkModeCardColor : KlightModeCardColor;
  }

  Color _primaryTextColor(BuildContext context) {
    return _isDark(context) ? KdarkModeTextColor : KlightModeTextColor;
  }

  Color _secondaryTextColor(BuildContext context) {
    return _isDark(context) ? KdarkModeTextSecondary : KlightModeTextSecondary;
  }

  String _productTitle(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl
        ? widget.product.nameAr
        : widget.product.nameEn;
  }

  String _restaurantName(BuildContext context) {
    final restaurantName = widget.product.restaurantName?.trim();
    if (restaurantName != null && restaurantName.isNotEmpty) {
      return restaurantName;
    }

    return S.of(context)!.bagelMysteryBagStoreName;
  }

  String _pickupTime(BuildContext context) {
    final pickupTime = widget.product.pickupTime?.trim();
    if (pickupTime != null && pickupTime.isNotEmpty) {
      return pickupTime;
    }

    return S.of(context)!.bagelMysteryBagPickupTimeValue;
  }

  String _ingredients(BuildContext context) {
    if (widget.product.detectedItems.isNotEmpty) {
      return widget.product.detectedItems.join(', ');
    }

    final description = widget.product.description.trim();
    if (description.isNotEmpty) {
      return description;
    }

    return S.of(context)!.bagelMysteryBagDescription;
  }

  String _locationValue(BuildContext context) {
    // Prefer the live branchLocation fetched from Firestore.
    print(
      '📍 _locationValue: _fetchedBranchLocation = "$_fetchedBranchLocation"',
    );
    if (_fetchedBranchLocation != null && _fetchedBranchLocation!.isNotEmpty) {
      print('📍 _locationValue: returning _fetchedBranchLocation');
      return _fetchedBranchLocation!;
    }

    // Fall back to the restaurant object only if the fetch did not populate.
    final restaurantLocation = widget.restaurant?.location?.trim();
    print('📍 _locationValue: restaurantLocation = "$restaurantLocation"');
    if (restaurantLocation != null && restaurantLocation.isNotEmpty) {
      print('📍 _locationValue: returning restaurantLocation');
      return restaurantLocation;
    }

    print('📍 _locationValue: returning fallback');
    return S.of(context)!.bagelMysteryBagLocationValue;
  }

  String _contactValue() {
    return '+20 100 000 0000';
  }

  double _currentPrice() {
    return widget.product.price.toDouble();
  }

  double _oldPrice() {
    return widget.product.oldPrice > 0
        ? widget.product.oldPrice.toDouble()
        : widget.product.price.toDouble();
  }

  Future<void> _reserveProduct(int bagsLeft) async {
    if (_isReserving || _reserved || bagsLeft <= 0) {
      return;
    }

    if (isDemoProduct(widget.product)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.demoBoxNotice)));
      return;
    }

    final restaurantId = widget.product.restaurantId;
    if (restaurantId == null || restaurantId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Store data is missing.')));
      return;
    }

    setState(() {
      _isReserving = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final restaurantDoc = firestore
          .collection('resturants')
          .doc(restaurantId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(restaurantDoc);
        if (!snapshot.exists) {
          throw StateError('Store not found');
        }

        final data = snapshot.data();
        final products = List<dynamic>.from(data?['products'] as List? ?? []);

        // First try exact id match against docId/productId/documentId
        final currentId = widget.product.documentId.trim();
        int productIndex = -1;
        if (currentId.isNotEmpty) {
          productIndex = products.indexWhere((productData) {
            if (productData is! Map) return false;
            final pd = Map<String, dynamic>.from(productData);
            final candidateIds = <String>{
              pd['docId']?.toString().trim() ?? '',
              pd['productId']?.toString().trim() ?? '',
              pd['documentId']?.toString().trim() ?? '',
              pd['id']?.toString().trim() ?? '',
            }..removeWhere((v) => v.isEmpty);
            final match = candidateIds.contains(currentId);
            if (match) {
              try {
                print(
                  '✅ reserve exact-id matched product: docId=$currentId title=${pd['title'] ?? pd['nameEn']} bagsLeft=${pd['bagsLeft']}',
                );
              } catch (_) {}
            }
            return match;
          });
        }

        if (productIndex == -1) {
          throw StateError('Style Box not found in this store');
        }

        final productMap = Map<String, dynamic>.from(
          products[productIndex] as Map,
        );
        final currentBagsLeft = _asInt(productMap['bagsLeft']);
        if (currentBagsLeft <= 0) {
          throw StateError('Sold out');
        }

        productMap['bagsLeft'] = currentBagsLeft - 1;
        products[productIndex] = productMap;

        transaction.update(restaurantDoc, {'products': products});
      });

      if (!mounted) {
        return;
      }

      context.read<CartCubit>().addProductToCart(widget.product);
      setState(() {
        _currentBagsLeft = bagsLeft > 0 ? bagsLeft - 1 : 0;
        _reserved = true;
      });

      await context.read<ProductsCubit>().loadProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.bagelMysteryBagReservedState)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isReserving = false;
        });
      }
    }
  }

  /// Firebase may be unavailable (previews, tests); never crash the screen.
  String _currentUid() {
    try {
      return FirebaseAuth.instance.currentUser?.uid ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final bagsLeft = _bagsLeftFromState(state);

        return Scaffold(
          backgroundColor: _backgroundColor(context),
          bottomNavigationBar: _buildBottomBar(bagsLeft),
          body: CustomScrollView(
            slivers: [
              _buildSliverHeader(context, bagsLeft),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleBlock(),
                      const SizedBox(height: 22),
                      _buildQuickFacts(bagsLeft),
                      const SizedBox(height: 30),
                      _buildWhatsInBox(),
                      const SizedBox(height: 30),
                      _buildSizes(),
                      const SizedBox(height: 30),
                      _buildStoreCard(),
                      const SizedBox(height: 30),
                      BagelCustomerReviewsSection(
                        productId: widget.product.documentId,
                        reviewsRepo: _reviewsRepo,
                        onWriteReviewPressed: _showReviewComposer,
                        currentUserId: _currentUid(),
                        onEditReview: _editReview,
                        onDeleteReview: _deleteReview,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Collapsing image header ───────────────────────────────────────────────
  Widget _buildSliverHeader(BuildContext context, int bagsLeft) {
    final locale = S.of(context)!;
    final discount = _discountPercent();

    Widget circleButton({required Widget child, VoidCallback? onTap}) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: Colors.white.withOpacity(0.92),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 42,
              height: 42,
              child: IconTheme(
                data: const IconThemeData(size: 20, color: KlightModeTextColor),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      );
    }

    return SliverAppBar(
      expandedHeight: 420,
      pinned: true,
      stretch: true,
      backgroundColor: KprimaryColorDark,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 10),
        child: circleButton(
          onTap: () => Navigator.of(context).maybePop(),
          child: const BackButtonIcon(),
        ),
      ),
      actions: [
        ValueListenableBuilder<Set<String>>(
          valueListenable: FavoritesStore.ids,
          builder: (context, ids, _) {
            final liked = ids.contains(widget.product.documentId);
            return circleButton(
              onTap: () => FavoritesStore.toggle(widget.product.documentId),
              child: Icon(
                liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: liked ? KprimaryColor : KlightModeTextColor,
              ),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            BoxArtwork(product: widget.product, iconSize: 170),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Colors.transparent,
                    Color(0x66000000),
                  ],
                  stops: [0, 0.4, 1],
                ),
              ),
            ),
            PositionedDirectional(
              start: 20,
              end: 20,
              bottom: 22,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (discount > 0)
                    _glassChip(locale.bagCardOff('$discount'), filled: true),
                  _glassChip(locale.bagCardBagsLeft('$bagsLeft')),
                  if (_distanceLabel(locale) case final distance?)
                    _glassChip(distance),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassChip(String label, {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? KaccentColor : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : KlightModeTextColor,
        ),
      ),
    );
  }

  int _discountPercent() {
    final current = _currentPrice();
    final old = _oldPrice();
    return old > current && old > 0 ? ((1 - current / old) * 100).round() : 0;
  }

  // ── Title, store and rating ───────────────────────────────────────────────
  Widget _buildTitleBlock() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: SizedBox(width: 26, height: 26, child: _storeLogo()),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _restaurantName(context).toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: _secondaryTextColor(context),
                ),
              ),
            ),
            StreamBuilder<ReviewAnalyticsEntity>(
              stream: _reviewsRepo.watchProductReviewAnalytics(
                productId: widget.product.documentId,
              ),
              initialData: ReviewAnalyticsEntity(
                productId: widget.product.documentId,
                reviewCount: 0,
                averageRating: widget.product.avgRating,
                ratingBreakdown: const {},
              ),
              builder: (context, snapshot) {
                final data = snapshot.data;
                final rating = data?.averageRating ?? widget.product.avgRating;
                return Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: KaccentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _primaryTextColor(context),
                      ),
                    ),
                    if ((data?.reviewCount ?? 0) > 0)
                      Text(
                        ' (${data!.reviewCount})',
                        style: TextStyle(
                          fontSize: 13,
                          color: _secondaryTextColor(context),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _productTitle(context),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
            height: 1.1,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }

  // ── Three fact tiles ──────────────────────────────────────────────────────
  Widget _buildQuickFacts(int bagsLeft) {
    final locale = S.of(context)!;
    final pickup = _pickupTime(context).replaceFirst(RegExp(r'^Pickup\s*'), '');
    final third =
        _distanceLabel(locale) ??
        _categoryLabel(locale, widget.product.category) ??
        locale.bagelMysteryBagLocationLabel;
    final thirdIcon = _distanceLabel(locale) != null
        ? Icons.near_me_outlined
        : Icons.sell_outlined;

    Widget tile(IconData icon, String label, String value) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          decoration: BoxDecoration(
            color: _cardColor(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _secondaryTextColor(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: _primaryTextColor(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tile(
            Icons.schedule_rounded,
            locale.bagelMysteryBagPickupTimeLabel,
            pickup,
          ),
          const SizedBox(width: 10),
          tile(
            Icons.inventory_2_outlined,
            locale.detailsStockLabel,
            locale.bagelMysteryBagAvailableCount('$bagsLeft'),
          ),
          const SizedBox(width: 10),
          tile(
            thirdIcon,
            _distanceLabel(locale) != null
                ? locale.bagelMysteryBagLocationLabel
                : locale.bagCategoryLabel,
            third,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: _primaryTextColor(context),
      ),
    ),
  );

  // ── What's inside: checklist ──────────────────────────────────────────────
  Widget _buildWhatsInBox() {
    final items = widget.product.detectedItems;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(S.of(context)!.bagDetailsWhatInsideTitle),
        if (items.isEmpty)
          Text(
            _ingredients(context),
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: _secondaryTextColor(context),
            ),
          )
        else
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _primaryTextColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ── Sizes as round swatches + category ────────────────────────────────────
  Widget _buildSizes() {
    final locale = S.of(context)!;
    final sizes = widget.product.sizes;
    final category = _categoryLabel(locale, widget.product.category);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionTitle(locale.bagSizesLabel)),
            if (category != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${locale.bagCategoryLabel}: $category',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (sizes.isEmpty)
          Text(
            locale.bagSizesNotSpecified,
            style: TextStyle(fontSize: 14, color: _secondaryTextColor(context)),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: sizes
                .map(
                  (size) => Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _cardColor(context),
                      border: Border.all(
                        color: _primaryTextColor(context),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _primaryTextColor(context),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        if (sizes.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            locale.bagelMysteryBagAllergenNotice,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: _secondaryTextColor(context),
            ),
          ),
        ],
      ],
    );
  }

  // ── Store / pickup card ───────────────────────────────────────────────────
  Widget _buildStoreCard() {
    final locale = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(width: 52, height: 52, child: _storeLogo()),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _restaurantName(context),
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: _primaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _locationValue(context),
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: _secondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: FilledButton.icon(
                    onPressed: _openStoreOnMap,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 46),
                      backgroundColor: scheme.primaryContainer,
                      foregroundColor: scheme.primary,
                    ),
                    icon: const Icon(Icons.directions_outlined, size: 19),
                    label: Text(locale.mapDirections),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 46),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                      textStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(Icons.call_outlined, size: 18),
                    label: FittedBox(child: Text(_contactValue())),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Sticky price + reserve bar ────────────────────────────────────────────
  Widget _buildBottomBar(int bagsLeft) {
    final locale = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final isSoldOut = bagsLeft <= 0;
    final canReserve = !_reserved && !_isReserving && !isSoldOut;
    final buttonLabel = _isReserving
        ? (Directionality.of(context) == TextDirection.rtl
              ? 'جارٍ الحجز...'
              : 'Reserving...')
        : _reserved
        ? locale.bagelMysteryBagReservedState
        : isSoldOut
        ? (Directionality.of(context) == TextDirection.rtl
              ? 'نفدت الكمية'
              : 'Sold out')
        : locale.bagDetailsReservePickup;
    final currentPrice = _currentPrice();
    final oldPrice = _oldPrice();

    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        boxShadow: [
          BoxShadow(
            color: KprimaryColorDark.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentPrice.toStringAsFixed(0)} ${locale.bagCurrencySuffix}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.1,
                      color: scheme.primary,
                    ),
                  ),
                  if (oldPrice > currentPrice)
                    Text(
                      '${oldPrice.toStringAsFixed(0)} ${locale.bagCurrencySuffix}',
                      style: TextStyle(
                        fontSize: 13,
                        decoration: TextDecoration.lineThrough,
                        color: _secondaryTextColor(context),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: canReserve
                        ? () => _reserveProduct(bagsLeft)
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: _reserved
                          ? KaccentColor
                          : KdisabledColor,
                      disabledForegroundColor: Colors.white,
                    ),
                    child: FittedBox(child: Text(buttonLabel)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeLogo() {
    const fallback = 'assets/images/store_logo.png';
    final url = widget.product.restaurantImageUrl?.trim() ?? '';
    if (url.startsWith('http')) {
      return Image.network(
        url,
        cacheHeight: 112,
        cacheWidth: 112,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(fallback, fit: BoxFit.cover),
      );
    }
    return Image.asset(fallback, fit: BoxFit.cover);
  }

  String? _categoryLabel(S locale, String? category) {
    switch (category) {
      case 'men':
        return locale.categoryMen;
      case 'women':
        return locale.categoryWomen;
      case 'kids':
        return locale.categoryKids;
      case 'unisex':
        return locale.categoryUnisex;
      default:
        return null;
    }
  }

  Future<void> _showReviewComposer() async {
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewComposerBottomSheet(
        productId: widget.product.documentId,
        reviewsRepo: _reviewsRepo,
      ),
    );

    if (submitted == true && mounted) {
      await context.read<ProductsCubit>().loadProducts();
    }
  }

  Future<void> _editReview(ReviewEntity review) async {
    // Add current user ID to the review for editing
    final reviewWithUserId = review.copyWith(
      userId: _currentUid().isEmpty ? null : _currentUid(),
    );

    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewComposerBottomSheet(
        productId: widget.product.documentId,
        reviewsRepo: _reviewsRepo,
        existingReview: reviewWithUserId,
      ),
    );

    if (submitted == true && mounted) {
      await context.read<ProductsCubit>().loadProducts();
    }
  }

  void _deleteReview(String reviewId) async {
    final locale = S.of(context)!;
    final result = await _reviewsRepo.deleteProductReview(
      productId: widget.product.documentId,
      reviewId: reviewId,
    );

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${locale.reviewComposerDeleteError}: ${failure.message}',
              ),
            ),
          );
        }
      },
      (_) {
        if (mounted) {
          context.read<ProductsCubit>().loadProducts();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(locale.reviewComposerDeleteSuccess)),
          );
        }
      },
    );
  }
}

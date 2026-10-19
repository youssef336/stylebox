import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/entities/demo_products.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/helper_functions/restaurant_from_product.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'package:stylebox/core/services/location_service.dart';
import 'package:stylebox/core/widgets/box_artwork.dart';
import 'package:stylebox/core/widgets/box_product_card.dart';
import 'package:stylebox/core/widgets/empty_state_widget.dart';
import 'package:stylebox/features/home/presentation/views/bagel_mystery_bag_screen.dart';
import 'package:stylebox/features/stores_map/presentation/views/stores_map_view.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../../../constant.dart';
import '../../manager/cubits/products/products_cubit.dart';
import '../../manager/cubits/products/products_state.dart';
import 'home_category_rail.dart';
import 'home_featured_carousel.dart';
import 'home_header.dart';

/// Home: editorial header + search, category rail, featured carousel,
/// "New arrivals" strip, store shortcuts and a staggered two-column grid.
class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  String _query = '';
  String? _category;

  @override
  void initState() {
    super.initState();
    // Real store distances if the customer already allowed location.
    LocationService.position.addListener(_onPositionChanged);
    LocationService.currentIfPermitted();
  }

  @override
  void dispose() {
    LocationService.position.removeListener(_onPositionChanged);
    super.dispose();
  }

  void _onPositionChanged() {
    if (mounted) setState(() {});
  }

  String _title(BuildContext context, ProductEntity product) =>
      Directionality.of(context) == TextDirection.rtl
      ? product.nameAr
      : product.nameEn;

  List<ProductEntity> _filter(BuildContext context, List<ProductEntity> all) {
    final q = _query.trim().toLowerCase();
    return all.where((p) {
      if (_category != null && p.category != _category) return false;
      if (q.isEmpty) return true;
      return p.nameEn.toLowerCase().contains(q) ||
          p.nameAr.contains(q) ||
          (p.restaurantName ?? '').toLowerCase().contains(q) ||
          p.detectedItems.any((i) => i.toLowerCase().contains(q));
    }).toList();
  }

  List<_StoreGroup> _groupByStore(List<ProductEntity> products) {
    final groups = <String, _StoreGroup>{};
    for (final product in products) {
      final key = _storeKey(product);
      groups
          .putIfAbsent(
            key,
            () => _StoreGroup(restaurantFromProduct(context, product)),
          )
          .products
          .add(product);
    }
    return groups.values.toList();
  }

  String _storeKey(ProductEntity product) {
    final id = product.restaurantId?.trim();
    if (id != null && id.isNotEmpty) return id;
    final name = product.restaurantName?.trim();
    if (name != null && name.isNotEmpty) return name.toLowerCase();
    return product.documentId.isNotEmpty ? product.documentId : product.code;
  }

  void _openProduct(ProductEntity product) {
    Navigator.of(context).pushNamed(
      BagelMysteryBagScreen.routeName,
      arguments: {
        'product': product,
        'restaurant': restaurantFromProduct(context, product),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final realProducts = state is ProductsSuccess
            ? state.products
            : <ProductEntity>[];
        // Demo boxes until the first store adds real ones
        final allProducts = realProducts.isEmpty && state is ProductsSuccess
            ? demoProducts
            : realProducts;
        final products = _filter(context, allProducts);
        final stores = _groupByStore(allProducts);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(
                onSearchChanged: (value) => setState(() => _query = value),
              ),
            ),
            SliverToBoxAdapter(
              child: HomeCategoryRail(
                selected: _category,
                onSelected: (value) => setState(() => _category = value),
              ),
            ),
            const SliverToBoxAdapter(child: HomeFeaturedCarousel()),
            if (state is ProductsLoading || state is ProductsInitial)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (allProducts.isEmpty)
              SliverToBoxAdapter(
                child: EmptyStateWidget(
                  icon: Icons.checkroom_rounded,
                  title: locale.emptyHomeTitle,
                  subtitle: locale.emptyHomeSubtitle,
                ),
              )
            else ...[
              if (_query.isEmpty && _category == null) ...[
                SliverToBoxAdapter(
                  child: _SectionHeader(title: locale.homeNewArrivalsTitle),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 252,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: KhorzontalPadding,
                      ),
                      itemCount: allProducts.length.clamp(0, 6),
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final product =
                            allProducts[allProducts.length - 1 - index];
                        return _card(context, product, width: 150, height: 186);
                      },
                    ),
                  ),
                ),
                if (stores.length > 1) ...[
                  SliverToBoxAdapter(
                    child: _SectionHeader(title: locale.homeShopByStoreTitle),
                  ),
                  SliverToBoxAdapter(child: _StoreStrip(stores: stores)),
                ],
              ],
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: locale.homeAllBoxesTitle,
                  trailing: locale.mapBoxesCount('${products.length}'),
                ),
              ),
              if (products.isEmpty)
                SliverToBoxAdapter(
                  child: EmptyStateWidget(
                    icon: Icons.search_off_rounded,
                    title: locale.homeNoResults,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    KhorzontalPadding,
                    0,
                    KhorzontalPadding,
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _StaggeredGrid(
                      children: [
                        for (var i = 0; i < products.length; i++)
                          _card(
                            context,
                            products[i],
                            // Masonry rhythm: tall / short / short / tall...
                            height: (i % 4 == 0 || i % 4 == 3) ? 226 : 176,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
            // Room for the docked tab bar drawn over the content.
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ),
          ],
        );
      },
    );
  }

  Widget _card(
    BuildContext context,
    ProductEntity product, {
    double? width,
    required double height,
  }) {
    return BoxProductCard(
      width: width,
      imageHeight: height,
      artwork: BoxArtwork(product: product, iconSize: height * 0.36),
      title: _title(context, product),
      storeName: product.restaurantName,
      price: product.price.toDouble(),
      oldPrice: product.oldPrice > 0
          ? product.oldPrice.toDouble()
          : product.price.toDouble(),
      rating: product.avgRating.toDouble(),
      bagsLeft: product.bagsLeft,
      favoriteId: product.documentId,
      onTap: () => _openProduct(product),
    );
  }
}

class _StoreGroup {
  _StoreGroup(this.restaurant);

  final RestaurantEntity restaurant;
  final List<ProductEntity> products = <ProductEntity>[];
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KhorzontalPadding,
        26,
        KhorzontalPadding,
        14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: scheme.onSurface,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// Two independent columns so cards of different heights interlock.
class _StaggeredGrid extends StatelessWidget {
  const _StaggeredGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final start = <Widget>[];
    final end = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      (i.isEven ? start : end).add(
        Padding(padding: const EdgeInsets.only(bottom: 20), child: children[i]),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: start)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            children: [const SizedBox(height: 28), ...end],
          ),
        ),
      ],
    );
  }
}

/// Store shortcuts: logo, name and open/closed state, opening the map.
class _StoreStrip extends StatelessWidget {
  const _StoreStrip({required this.stores});

  final List<_StoreGroup> stores;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = S.of(context)!;

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: KhorzontalPadding),
        itemCount: stores.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final store = stores[index];
          final restaurant = store.restaurant;
          final logoUrl = restaurant.restaurantImageUrl;
          return Material(
            color: scheme.surface,
            shape: StadiumBorder(
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => Navigator.of(context).pushNamed(
                StoresMapView.routeName,
                arguments: {'storeId': store.products.first.restaurantId},
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 18, 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: scheme.primaryContainer,
                      backgroundImage: logoUrl != null
                          ? NetworkImage(logoUrl)
                          : AssetImage(restaurant.logoImage) as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name.split(' - ').first,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: restaurant.isOpenNow
                                    ? const Color(0xFF2E7D5B)
                                    : scheme.outline,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${restaurant.isOpenNow ? locale.mapOpenNow : locale.mapClosedNow} · ${locale.mapBoxesCount('${store.products.length}')}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

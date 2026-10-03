// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/entities/demo_products.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/models/bag_item_model.dart';
import 'package:stylebox/core/helper_functions/restaurant_from_product.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'package:stylebox/core/services/location_service.dart';
import 'package:stylebox/features/stores_map/presentation/views/widgets/stores_map_preview.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../../../constant.dart';
import '../../manager/cubits/products/products_cubit.dart';
import 'package:stylebox/core/widgets/available_bags_list.dart';
import 'package:stylebox/core/widgets/resturant_card.dart';
import 'package:stylebox/core/widgets/empty_state_widget.dart';
import 'home_hero_banner.dart';

import 'custom_home_appbar.dart';
import '../../manager/cubits/products/products_state.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
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

  List<BagItemModel> _buildBags(
    BuildContext context,
    List<ProductEntity> products,
    RestaurantEntity restaurant,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return products.map((product) {
      final title = isRtl ? product.nameAr : product.nameEn;
      final price = product.price.toDouble();
      final oldPrice = product.oldPrice > 0
          ? product.oldPrice.toDouble()
          : price;

      return BagItemModel(
        title: title,
        price: price,
        oldPrice: oldPrice,
        bagsLeft: product.bagsLeft,
        rating: product.avgRating.toDouble(),
        product: product,
        restaurant: restaurant,
      );
    }).toList();
  }

  List<BagItemModel> _defaultBags(BuildContext context) {
    return [
      BagItemModel(
        title: S.of(context)!.bagTitleAroussaSandwich,
        price: 50,
        oldPrice: 100,
        bagsLeft: 5,
        rating: 5,
      ),
      BagItemModel(
        title: S.of(context)!.bagTitleMasrawy,
        price: 60,
        oldPrice: 120,
        bagsLeft: 3,
        rating: 4.5,
      ),
    ];
  }

  List<_RestaurantProductsSection> _groupProductsByRestaurant(
    List<ProductEntity> products,
  ) {
    final groupedProducts = <String, _RestaurantProductsSection>{};

    for (final product in products) {
      final restaurantKey = _restaurantKey(product);
      print(
        '🏠 Grouping product ${product.nameEn}: restaurantImageUrl=${product.restaurantImageUrl}, imageUrl=${product.imageUrl}',
      );
      final section = groupedProducts.putIfAbsent(
        restaurantKey,
        () => _RestaurantProductsSection(
          restaurant: restaurantFromProduct(context, product),
        ),
      );
      section.products.add(product);
    }

    return groupedProducts.values.toList();
  }

  String _restaurantKey(ProductEntity product) {
    final restaurantId = product.restaurantId?.trim();
    if (restaurantId != null && restaurantId.isNotEmpty) {
      return restaurantId;
    }

    final restaurantName = product.restaurantName?.trim();
    if (restaurantName != null && restaurantName.isNotEmpty) {
      return restaurantName.toLowerCase();
    }

    return product.documentId.isNotEmpty ? product.documentId : product.code;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KhorzontalPadding),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const CustomHomeAppBar(),
                const SizedBox(height: 18),
                const HomeHeroBanner(),
                const SizedBox(height: 24),
                const StoresMapPreview(),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    S.of(context)!.homeStoresTitle,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? KdarkModeTextColor
                          : KlightModeTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final realProducts = state is ProductsSuccess
                        ? state.products
                        : <ProductEntity>[];
                    // Demo boxes until the first store adds real ones
                    final products =
                        realProducts.isEmpty && state is ProductsSuccess
                        ? demoProducts
                        : realProducts;

                    if (products.isEmpty && state is ProductsSuccess) {
                      return EmptyStateWidget(
                        icon: Icons.checkroom_rounded,
                        title: S.of(context)!.emptyHomeTitle,
                        subtitle: S.of(context)!.emptyHomeSubtitle,
                      );
                    }

                    final restaurantSections = products.isNotEmpty
                        ? _groupProductsByRestaurant(products)
                        : <_RestaurantProductsSection>[];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restaurantSections.length,
                      itemBuilder: (context, index) {
                        final section = restaurantSections[index];
                        final bags = _buildBags(context, section.products, section.restaurant);

                        return Column(
                          children: [
                            RestaurantCard(restaurant: section.restaurant),
                            const SizedBox(height: 16),
                            AvailableBagsList(
                              title: S.of(context)!.availableBagsTitle,
                              bags: bags,
                            ),
                            const SizedBox(height: 28),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantProductsSection {
  _RestaurantProductsSection({required this.restaurant});

  final RestaurantEntity restaurant;
  final List<ProductEntity> products = <ProductEntity>[];

  String get foodImage {
    for (final product in products) {
      final imageUrl = product.imageUrl.trim();
      if (imageUrl.isNotEmpty) {
        return imageUrl;
      }
    }

    return 'assets/images/store_cover.png';
  }
}

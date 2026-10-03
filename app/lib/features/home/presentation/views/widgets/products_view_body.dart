import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/entities/demo_products.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/models/bag_item_model.dart';
import 'package:stylebox/core/helper_functions/restaurant_from_product.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'package:stylebox/core/services/location_service.dart';
import 'package:stylebox/core/widgets/available_bags_list.dart';
import 'package:stylebox/core/widgets/resturant_card.dart';
import 'package:stylebox/core/widgets/empty_state_widget.dart';
import '../../manager/cubits/products/products_cubit.dart';
import '../../manager/cubits/products/products_state.dart';
import '../../../../../constant.dart';
import 'package:stylebox/generated/l10n.dart';

class ProductsViewBody extends StatefulWidget {
  const ProductsViewBody({super.key});

  @override
  State<ProductsViewBody> createState() => _ProductsViewBodyState();
}

class _ProductsViewBodyState extends State<ProductsViewBody> {
  @override
  void initState() {
    super.initState();
    LocationService.position.addListener(_onPositionChanged);
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

  List<_RestaurantProductsSection> _groupProductsByRestaurant(
    List<ProductEntity> products,
  ) {
    final groupedProducts = <String, _RestaurantProductsSection>{};

    for (final product in products) {
      final restaurantKey = _restaurantKey(product);
      print(
        '📦 Grouping product ${product.nameEn}: restaurantImageUrl=${product.restaurantImageUrl}, imageUrl=${product.imageUrl}',
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
                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    final realProducts = state is ProductsSuccess
                        ? state.products
                        : <ProductEntity>[];
                    // Demo boxes until the first store adds real ones
                    final products =
                        realProducts.isEmpty && state is ProductsSuccess
                        ? demoProducts
                        : realProducts;
                    final restaurantSections = products.isNotEmpty
                        ? _groupProductsByRestaurant(products)
                        : <_RestaurantProductsSection>[];

                    return Column(
                      children: [
                        const SizedBox(height: KTopPadding),
                        if (restaurantSections.isEmpty) ...[
                          if (state is! ProductsLoading)
                            EmptyStateWidget(
                              icon: Icons.checkroom_rounded,
                              title: S.of(context)!.emptyHomeTitle,
                              subtitle: S.of(context)!.emptyHomeSubtitle,
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.all(48),
                              child: CircularProgressIndicator(),
                            ),
                        ] else ...[
                          for (final section in restaurantSections) ...[
                            RestaurantCard(restaurant: section.restaurant),
                            const SizedBox(height: 16),
                            AvailableBagsList(
                              title: S.of(context)!.availableBagsTitle,
                              bags: _buildBags(
                                context,
                                section.products,
                                section.restaurant,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ],
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

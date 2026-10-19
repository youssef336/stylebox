import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/models/bag_item_model.dart';
import 'package:stylebox/core/widgets/box_artwork.dart';
import 'package:stylebox/core/widgets/box_product_card.dart';
import 'package:stylebox/features/home/presentation/views/bagel_mystery_bag_screen.dart';

/// Horizontal-list version of the image-first [BoxProductCard].
class BagCard extends StatelessWidget {
  final String title;
  final double price;
  final double oldPrice;
  final int bagsLeft;
  final double rating;
  final double width;

  final BagItemModel? bagItemModel;
  const BagCard({
    super.key,
    required this.width,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.bagsLeft,
    required this.rating,
    required this.bagItemModel,
  });

  static const double imageHeight = 190;

  void _openDetails(BuildContext context) {
    final product = bagItemModel?.product;
    if (product == null) return;
    Navigator.of(context).pushNamed(
      BagelMysteryBagScreen.routeName,
      arguments: {'product': product, 'restaurant': bagItemModel?.restaurant},
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = bagItemModel?.product;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 14),
      child: BoxProductCard(
        width: width,
        imageHeight: imageHeight,
        artwork: product != null
            ? BoxArtwork(product: product)
            : const DecoratedBox(
                decoration: BoxDecoration(gradient: KbrandGradient),
                child: Center(
                  child: Icon(
                    Icons.checkroom_rounded,
                    size: 64,
                    color: Colors.white38,
                  ),
                ),
              ),
        title: title,
        storeName: product?.restaurantName,
        price: price,
        oldPrice: oldPrice,
        rating: rating,
        bagsLeft: bagsLeft,
        favoriteId: product?.documentId,
        onTap: () => _openDetails(context),
      ),
    );
  }
}

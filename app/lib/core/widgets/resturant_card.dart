// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'status_badges_widget.dart';
import 'restaurant_logo_widget.dart';
import 'restaurant_info_widget.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final ProductEntity? product;
  const RestaurantCard({super.key, required this.restaurant, this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : KprimaryColor.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cover image with status pills
          SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image(
                    image: _getImageProvider(restaurant),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/store_cover.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 12,
                  start: 12,
                  child: StatusBadgesWidget(
                    isAvailable: restaurant.isAvailable,
                    isOpenNow: restaurant.isOpenNow,
                  ),
                ),
              ],
            ),
          ),

          // Logo + name + chips
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              children: [
                RestaurantLogoWidget(restaurant: restaurant),
                const SizedBox(width: 12),
                Expanded(
                  child: RestaurantInfoWidget(
                    name: restaurant.name,
                    branches: restaurant.branches,
                    distance: restaurant.distance,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(RestaurantEntity restaurant) {
    // Prefer the store image from Firebase (ignore QR-code images)
    if (restaurant.restaurantImageUrl?.isNotEmpty == true) {
      final url = restaurant.restaurantImageUrl!.trim();
      if (url.startsWith('http') && !url.toLowerCase().contains('qrcode')) {
        return NetworkImage(url);
      }
    }

    // Fall back to the first box image
    String imagePath = restaurant.foodImage.trim();
    if (imagePath.startsWith('file://')) {
      imagePath = imagePath.replaceFirst('file://', '');
    }
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    }
    return AssetImage(imagePath);
  }
}

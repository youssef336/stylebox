// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';

class RestaurantLogoWidget extends StatelessWidget {
  final RestaurantEntity restaurant;
  const RestaurantLogoWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image(
          image: _getImageProvider(restaurant),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/store_logo.png',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(RestaurantEntity restaurant) {
    final url = restaurant.restaurantImageUrl?.trim() ?? '';
    if (url.startsWith('http') && !url.toLowerCase().contains('qrcode')) {
      return NetworkImage(url);
    }
    return const AssetImage('assets/images/store_logo.png');
  }
}

import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';

class BagItemModel {
  final String title;
  final double price;
  final double oldPrice;
  final int bagsLeft;
  final double rating;
  final ProductEntity? product;
  final RestaurantEntity? restaurant;

  BagItemModel({
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.bagsLeft,
    required this.rating,
    this.product,
    this.restaurant,
  });
}

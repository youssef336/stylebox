// ignore_for_file: file_names

import 'package:stylebox/core/helper_functions/getCurrency.dart';
import 'package:stylebox/features/home/domain/entities/cart_item_entity.dart';

class Items {
  String? name;
  int? quantity;
  String? price;
  String? currency;

  Items({this.name, this.quantity, this.price, this.currency});

  factory Items.fromEntity(CartItemEntity entity) {
    return Items(
      name: entity.productEntity.nameAr,
      quantity: entity.count,
      price: entity.productEntity.price.toString(),
      currency: getCurrency(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["quantity"] = quantity;
    data["price"] = price;
    data["currency"] = currency;
    return data;
  }
}

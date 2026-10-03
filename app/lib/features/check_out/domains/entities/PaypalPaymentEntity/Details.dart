// ignore_for_file: file_names

import '../order_entity.dart';

class DetailsEntity {
  String? subtotal;
  String? shipping;
  double? shippingDiscount;

  DetailsEntity({this.subtotal, this.shipping, this.shippingDiscount});

  factory DetailsEntity.fromEntity(OrderEntity entity) {
    return DetailsEntity(
      subtotal: entity.cartEntites.calculateTotalPrice().toString(),
      shipping: entity.calculateShipingCost().toString(),
      shippingDiscount: entity.calulateShipingDiscount(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["subtotal"] = subtotal;
    data["shipping"] = shipping;
    data["shipping_discount"] = shippingDiscount;
    return data;
  }
}

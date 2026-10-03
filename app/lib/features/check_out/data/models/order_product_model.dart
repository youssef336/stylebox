import '../../../home/domain/entities/cart_item_entity.dart';

class OrderProductModel {
  final String nameEn;
  final String nameAr;
  final String imageUrl;
  final String code;
  final double price;
  final int quantity;

  OrderProductModel({
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
    required this.code,
    required this.price,
    required this.quantity,
  });
  factory OrderProductModel.fromEntity({required CartItemEntity entity}) {
    return OrderProductModel(
      nameEn: entity.productEntity.nameEn,
      nameAr: entity.productEntity.nameAr,
      imageUrl: entity.productEntity.imageUrl,
      code: entity.productEntity.code,
      price: entity.productEntity.price.toDouble(),
      quantity: entity.count,
    );
  }
  Map<String, Object> toJson() => {
    'nameEn': nameEn,
    'nameAr': nameAr,
    'imageUrl': imageUrl,
    'code': code,
    'price': price,
    'quantity': quantity,
  };
}

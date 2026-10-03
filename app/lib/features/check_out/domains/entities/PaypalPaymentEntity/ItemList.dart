// ignore_for_file: file_names

import 'package:stylebox/features/check_out/domains/entities/PaypalPaymentEntity/Items.dart';

import '../../../../home/domain/entities/cart_item_entity.dart';

class ItemList {
  List<Items>? items;

  ItemList({this.items});
  factory ItemList.fromEntity({required List<CartItemEntity> items}) {
    {
      return ItemList(items: items.map((e) => Items.fromEntity(e)).toList());
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data["items"] = items?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

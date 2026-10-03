// ignore_for_file: file_names

import '../../../../../core/helper_functions/getCurrency.dart';
import '../order_entity.dart';
import 'Details.dart';

class Amount {
  String? total;
  String? currency;
  DetailsEntity? details;

  Amount({this.total, this.currency, this.details});

  factory Amount.fromEntity(OrderEntity entity) {
    return Amount(
      total: entity.calculateTotalPriceAfterDiscountAndShiping().toString(),
      currency: getCurrency(),
      details: DetailsEntity.fromEntity(entity),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["total"] = total;
    data["currency"] = currency;
    if (details != null) {
      data["details"] = details?.toJson();
    }
    return data;
  }
}

import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/helper_functions/get_avg_rating.dart';

import 'review_model.dart';

class ProductModel {
  final String documentId;
  final String nameEn;
  final String nameAr;
  final String code;
  final String description;
  final num price;
  final num oldPrice;
  final int bagsLeft;
  final String? restaurantName;
  final String? branchLocation;
  final String? pickupTime;
  final List<String> detectedItems;
  final String? userEmail;
  final String? restaurantId;
  final String? restaurantImageUrl;
  final bool? restaurantIsAvailable;
  final bool? restaurantIsOpenNow;
  final double? restaurantLatitude;
  final double? restaurantLongitude;
  final int? restaurantTotalBranches;

  final bool isfeatured;
  final num sellingCount;
  String? imageurl;
  final int experationMonths;
  final bool isOrganic;
  final int numbersOfCalories;
  final num avgRating;
  final num ratingCount = 0;
  final int unitAmount;
  final List<ReviewModel> reviews;
  final List<String> sizes;
  final String? category;

  ProductModel({
    this.documentId = '',
    required this.nameEn,
    required this.nameAr,

    required this.code,
    required this.description,
    required this.experationMonths,
    required this.numbersOfCalories,
    required this.avgRating,
    required this.unitAmount,
    required this.sellingCount,
    required this.reviews,
    required this.price,
    required this.isOrganic,
    required this.isfeatured,
    this.oldPrice = 0,
    this.bagsLeft = 0,
    this.detectedItems = const [],
    this.restaurantName,
    this.branchLocation,
    this.pickupTime,
    this.userEmail,
    this.restaurantId,
    this.restaurantImageUrl,
    this.restaurantIsAvailable,
    this.restaurantIsOpenNow,
    this.restaurantLatitude,
    this.restaurantLongitude,
    this.restaurantTotalBranches,
    this.imageurl,
    this.sizes = const [],
    this.category,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    String? documentId,
  }) {
    String safeString(dynamic v) => v?.toString() ?? '';
    num safeNum(dynamic v) {
      if (v is num) return v;
      if (v is String) return num.tryParse(v) ?? 0;
      return 0;
    }

    double? nullableDouble(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    bool safeBool(dynamic v) => v == true || v == 'true' || v == 1;
    bool? nullableBool(dynamic v) {
      if (v == null) return null;
      if (v == true || v == 'true' || v == 1) return true;
      if (v == false || v == 'false' || v == 0) return false;
      return null;
    }

    List<String> parseStringList(dynamic raw) {
      if (raw is! List) return <String>[];
      return raw
          .map((item) => item?.toString().trim() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }

    List<ReviewModel> parseReviews(dynamic reviewsRaw) {
      if (reviewsRaw == null) return <ReviewModel>[];
      if (reviewsRaw is List) {
        return reviewsRaw.map((e) {
          if (e is Map<String, dynamic>) return ReviewModel.fromJson(e);
          if (e is Map) {
            return ReviewModel.fromJson(Map<String, dynamic>.from(e));
          }
          return ReviewModel.fromJson({});
        }).toList();
      }
      return <ReviewModel>[];
    }

    final parsedReviews = parseReviews(json['reviews']);
    final title = safeString(json['title']);
    final resolvedNameEn = safeString(json['nameEn']).isNotEmpty
        ? safeString(json['nameEn'])
        : title;
    final resolvedNameAr = safeString(json['nameAr']).isNotEmpty
        ? safeString(json['nameAr'])
        : resolvedNameEn;
    final resolvedDocumentId = documentId ?? safeString(json['documentId']);

    return ProductModel(
      documentId: resolvedDocumentId,
      nameEn: resolvedNameEn,
      nameAr: resolvedNameAr,
      code: safeString(json['code']),
      description: safeString(json['description']).isNotEmpty
          ? safeString(json['description'])
          : parseStringList(json['detectedItems']).join(', '),
      experationMonths: safeNum(json['experationMonths']).toInt(),
      numbersOfCalories: safeNum(json['numbersOfCalories']).toInt(),
      unitAmount: safeNum(json['unitAmount']).toInt(),
      sellingCount: safeNum(json['sellingCount']),
      reviews: parsedReviews,
      price: safeNum(json['price']),
      oldPrice: safeNum(json['oldPrice']),
      bagsLeft: safeNum(json['bagsLeft']).toInt(),
      detectedItems: parseStringList(json['detectedItems']),
      restaurantName: safeString(json['restaurantName']).isNotEmpty
          ? safeString(json['restaurantName'])
          : null,
      pickupTime: safeString(json['pickupTime']).isNotEmpty
          ? safeString(json['pickupTime'])
          : null,
      userEmail: safeString(json['userEmail']).isNotEmpty
          ? safeString(json['userEmail'])
          : null,
      restaurantId: safeString(json['restaurantId']).isNotEmpty
          ? safeString(json['restaurantId'])
          : null,
      restaurantImageUrl: safeString(json['restaurantImageUrl']).isNotEmpty
          ? safeString(json['restaurantImageUrl'])
          : null,
        restaurantIsAvailable: nullableBool(json['restaurantIsAvailable']),
        restaurantIsOpenNow: nullableBool(json['restaurantIsOpenNow']),
      branchLocation: safeString(json['branchLocation']).isNotEmpty
          ? safeString(json['branchLocation'])
          : null,
      restaurantLatitude: nullableDouble(json['restaurantLatitude']),
      restaurantLongitude: nullableDouble(json['restaurantLongitude']),
      restaurantTotalBranches: nullableDouble(
        json['restaurantTotalBranches'],
      )?.toInt(),
      isOrganic: safeBool(json['isOrganic']),
      isfeatured: safeBool(json['isfeatured']) || safeBool(json['isFeatured']),
      imageurl: safeString(json['imageurl']).isNotEmpty
          ? safeString(json['imageurl'])
          : (safeString(json['imageUrl']).isNotEmpty
                ? safeString(json['imageUrl'])
                : null),
      avgRating: safeNum(json['avgRating']) > 0
          ? safeNum(json['avgRating'])
          : getAvgRating(parsedReviews),
      sizes: parseStringList(json['sizes']),
      category: safeString(json['category']).isNotEmpty
          ? safeString(json['category'])
          : null,
    );
  }

  // product_model.dart
  ProductEntity toEntity() {
    return ProductEntity(
      documentId: documentId,
      nameAr: nameAr,
      nameEn: nameEn,
      code: code,
      description: description,
      price: price,
      reviews: reviews.map((e) => e.toEntity()).toList(),
      expirationsMonths: experationMonths,
      numbersOfCalories: numbersOfCalories,
      unitAmount: unitAmount,
      isOrganic: isOrganic,
      isFeatured: isfeatured,
      oldPrice: oldPrice,
      bagsLeft: bagsLeft,
      restaurantName: restaurantName,
      pickupTime: pickupTime,
      detectedItems: detectedItems,
      userEmail: userEmail,
      restaurantId: restaurantId,
      restaurantImageUrl: restaurantImageUrl,
      restaurantIsAvailable: restaurantIsAvailable,
      restaurantIsOpenNow: restaurantIsOpenNow,
      branchLocation: branchLocation,
      restaurantLatitude: restaurantLatitude,
      restaurantLongitude: restaurantLongitude,
      restaurantTotalBranches: restaurantTotalBranches,
      avgRating: avgRating,
      imageUrl: imageurl ?? '',
      sizes: sizes,
      category: category,
    );
  }
}

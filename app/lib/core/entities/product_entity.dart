// product_entity.dart

// ignore_for_file: unused_import, must_be_immutable

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stylebox/core/entities/review_entity.dart';

class ProductEntity extends Equatable {
  final String documentId;
  final String nameEn;
  final String nameAr;

  final String code;
  final String description;
  final num price;
  final num oldPrice;
  final int bagsLeft;
  final String? restaurantName;
  final String? pickupTime;
  final List<String> detectedItems;
  final String? userEmail;
  final String? restaurantId;
  final String? restaurantImageUrl;
  final bool? restaurantIsAvailable;
  final bool? restaurantIsOpenNow;
  final String? branchLocation;
  final double? restaurantLatitude;
  final double? restaurantLongitude;
  final int? restaurantTotalBranches;

  final bool isFeatured;
  final String imageUrl;
  final int expirationsMonths;
  final bool isOrganic;
  final int numbersOfCalories;
  final num avgRating;
  final num ratingCount = 0;
  final int unitAmount;
  final List<ReviewEntity> reviews;
  final List<String> sizes; // e.g. ['S', 'M', 'L']
  final String? category; // men | women | kids | unisex
  bool isFavorite = false; // Managed by FavoriteProvider

  ProductEntity({
    this.documentId = '',
    required this.nameEn,
    required this.nameAr,
    required this.code,
    required this.description,
    required this.price,
    required this.reviews,
    required this.expirationsMonths,
    required this.numbersOfCalories,
    required this.unitAmount,
    this.isOrganic = false,
    required this.isFeatured,
    this.oldPrice = 0,
    this.bagsLeft = 0,
    this.restaurantName,
    this.pickupTime,
    this.detectedItems = const [],
    this.userEmail,
    this.restaurantId,
    this.restaurantImageUrl,
    this.restaurantIsAvailable,
    this.restaurantIsOpenNow,
    this.branchLocation,
    this.restaurantLatitude,
    this.restaurantLongitude,
    this.restaurantTotalBranches,
    this.avgRating = 0,
    required this.imageUrl,
    this.sizes = const [],
    this.category,
  });

  @override
  List<Object?> get props => [
    documentId,
    restaurantId,
    code,
    nameAr,
    nameEn,
    bagsLeft,
    avgRating,
    price,
    oldPrice,
  ];
}

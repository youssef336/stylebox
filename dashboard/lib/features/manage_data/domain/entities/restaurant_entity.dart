// ignore_for_file: non_constant_identifier_names

import 'dart:io';

/// A store's position on the customers' map.
typedef StorePin = ({double latitude, double longitude});

/// Core domain entity — no dependency on any framework or data layer.
/// Each branch is stored as a separate restaurant with the same name.
class RestaurantEntity {
  final String? docId; // Firestore document ID
  final String name;
  final String branchLocation; // Location of this specific branch
  final int totalBranches; // Total number of branches for this restaurant
  final int branchIndex; // Index of this branch (1, 2, 3, ...)
  final bool isOpend;
  final bool isAvailable;
  final String? RestaurantimageUrl; // Remote URL (Supabase)
  final File? imageFile; // Local file picked by the user (edit flow)
  final String? userEmail;
  final List<ReviewEntity> reviews;
  // Map pin shown to customers on the StyleBox stores map
  final double? latitude;
  final double? longitude;

  const RestaurantEntity({
    this.docId,
    required this.name,
    required this.branchLocation,
    required this.totalBranches,
    required this.branchIndex,
    required this.isOpend,
    required this.isAvailable,
    this.RestaurantimageUrl,
    this.imageFile,
    this.userEmail,
    this.reviews = const [],
    this.latitude,
    this.longitude,
  });

  bool get hasPin => latitude != null && longitude != null;

  String get displayName =>
      totalBranches > 1 ? '$name - Branch $branchIndex' : name;

  String get branchesDisplay =>
      '$totalBranches branch${totalBranches > 1 ? 'es' : ''}';

  RestaurantEntity copyWith({
    String? docId,
    String? name,
    String? branchLocation,
    int? totalBranches,
    int? branchIndex,
    bool? isOpend,
    bool? isAvailable,
    String? RestaurantimageUrl,
    File? imageFile,
    String? userEmail,
    List<ReviewEntity>? reviews,
    double? latitude,
    double? longitude,
  }) {
    return RestaurantEntity(
      docId: docId ?? this.docId,
      name: name ?? this.name,
      branchLocation: branchLocation ?? this.branchLocation,
      totalBranches: totalBranches ?? this.totalBranches,
      branchIndex: branchIndex ?? this.branchIndex,
      isOpend: isOpend ?? this.isOpend,
      isAvailable: isAvailable ?? this.isAvailable,
      RestaurantimageUrl: RestaurantimageUrl ?? this.RestaurantimageUrl,
      imageFile: imageFile ?? this.imageFile,
      userEmail: userEmail ?? this.userEmail,
      reviews: reviews ?? this.reviews,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class ReviewEntity {
  final String? id;
  final String? userId;
  final String? name;
  final String? image;
  final String? review;
  final int? rating;
  final DateTime? date;

  const ReviewEntity({
    this.id,
    this.userId,
    this.name,
    this.image,
    this.review,
    this.rating,
    this.date,
  });
}

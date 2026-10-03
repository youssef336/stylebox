import 'package:stylebox/core/entities/review_entity.dart';

class ReviewModel {
  final String id;
  final String name;
  final String image;
  final num rating;
  final String review;
  final String date;
  final String? userId;

  ReviewModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.review,
    required this.date,
    this.userId,
  });

  factory ReviewModel.fromEntity(ReviewEntity reviewEntity) => ReviewModel(
    id: reviewEntity.id,
    name: reviewEntity.name,
    image: reviewEntity.image,
    rating: reviewEntity.rating,
    review: reviewEntity.review,
    date: reviewEntity.date,
    userId: reviewEntity.userId,
  );

  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    name: name,
    image: image,
    rating: rating,
    review: review,
    date: date,
    userId: userId,
  );

  factory ReviewModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ReviewModel(
      id: id ?? (json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      rating: (json['rating'] as num?) ?? 0,
      review: json['review']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      userId: json['userId']?.toString(),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'rating': rating,
    'review': review,
    'date': date,
    'userId': userId,
  };
}

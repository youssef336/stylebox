class ReviewEntity {
  final String id;
  final String name;
  final String image;
  final num rating;
  final String review;
  final String date;
  final String? userId;

  ReviewEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.review,
    required this.date,
    this.userId,
  });

  ReviewEntity copyWith({
    String? id,
    String? name,
    String? image,
    num? rating,
    String? review,
    String? date,
    String? userId,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }
}

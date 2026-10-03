class ReviewAnalyticsEntity {
  final String productId;
  final int reviewCount;
  final num averageRating;
  final Map<int, int> ratingBreakdown;

  const ReviewAnalyticsEntity({
    required this.productId,
    required this.reviewCount,
    required this.averageRating,
    required this.ratingBreakdown,
  });

  const ReviewAnalyticsEntity.empty({required this.productId})
    : reviewCount = 0,
      averageRating = 0,
      ratingBreakdown = const {};
}

class RestaurantEntity {
  final String name;
  final String foodImage;
  final String logoImage;
  final String branches;
  final String distance;
  final String? location;
  final bool isAvailable;
  final bool isOpenNow;
  final String? restaurantImageUrl;

  RestaurantEntity({
    required this.name,
    required this.foodImage,
    required this.logoImage,
    required this.branches,
    required this.distance,
    this.location,
    required this.isAvailable,
    required this.isOpenNow,
    this.restaurantImageUrl,
  });
}

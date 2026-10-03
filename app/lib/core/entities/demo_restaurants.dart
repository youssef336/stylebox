import 'package:stylebox/core/models/restaurant_entity_model.dart';

/// Demo stores for home page display
final List<RestaurantEntity> demoRestaurants = [
  RestaurantEntity(
    name: 'Cotton Corner - Zamalek',
    foodImage: 'assets/images/store_cover.png',
    logoImage: 'assets/images/store_logo.png',
    branches: '1 branch',
    distance: '2.7 kilometers',
    isAvailable: true,
    isOpenNow: true,
    restaurantImageUrl: null,
  ),
  RestaurantEntity(
    name: 'Urban Threads',
    foodImage: 'assets/images/store_cover.png',
    logoImage: 'assets/images/store_logo.png',
    branches: '3 branches',
    distance: '1.5 kilometers',
    isAvailable: true,
    isOpenNow: true,
    restaurantImageUrl: null,
  ),
  RestaurantEntity(
    name: 'Denim Lab',
    foodImage: 'assets/images/store_cover.png',
    logoImage: 'assets/images/store_logo.png',
    branches: '2 branches',
    distance: '3.2 kilometers',
    isAvailable: true,
    isOpenNow: false,
    restaurantImageUrl: null,
  ),
];

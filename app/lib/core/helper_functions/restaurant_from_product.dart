import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'package:stylebox/core/services/location_service.dart';
import 'package:stylebox/generated/l10n.dart';

/// Store card data for the store a box belongs to.
RestaurantEntity restaurantFromProduct(
  BuildContext context,
  ProductEntity product,
) {
  final locale = S.of(context)!;
  final name = product.restaurantName?.trim();
  final image = product.imageUrl.trim();
  final storeImage = product.restaurantImageUrl?.trim();

  return RestaurantEntity(
    name: name != null && name.isNotEmpty
        ? name
        : locale.restaurantNameMadbinaZamalek,
    foodImage: image.isNotEmpty ? image : 'assets/images/store_cover.png',
    logoImage: 'assets/images/store_logo.png',
    branches: locale.restaurantBranchesCount(
      '${product.restaurantTotalBranches ?? 1}',
    ),
    distance: storeDistanceLabel(context, product),
    location: product.branchLocation ?? locale.bagelMysteryBagLocationValue,
    isAvailable: product.restaurantIsAvailable ?? true,
    isOpenNow: product.restaurantIsOpenNow ?? true,
    restaurantImageUrl: storeImage != null && storeImage.isNotEmpty
        ? storeImage
        : null,
  );
}

/// Real distance when both the customer and the store have a location,
/// otherwise the store's area so the card never shows a made-up number.
String storeDistanceLabel(BuildContext context, ProductEntity product) {
  final me = LocationService.position.value;
  final lat = product.restaurantLatitude;
  final lng = product.restaurantLongitude;
  if (me != null && lat != null && lng != null) {
    final km = LocationService.distanceKm(me, LatLng(lat, lng));
    return S.of(context)!.mapDistanceKm(formatKm(km));
  }
  return product.branchLocation ?? '';
}

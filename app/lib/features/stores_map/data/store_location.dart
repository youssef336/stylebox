import 'package:latlong2/latlong.dart';
import 'package:stylebox/core/entities/demo_products.dart';

/// A store branch that can be pinned on the map.
class StoreLocation {
  final String id;
  final String name;
  final String address;
  final LatLng point;
  final String? imageUrl;
  final bool isOpen;
  final int boxesCount;
  final bool isDemo;

  const StoreLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.point,
    this.imageUrl,
    this.isOpen = true,
    this.boxesCount = 0,
    this.isDemo = false,
  });

  /// Builds a store from a `resturants` document.
  /// Returns null when the store has no coordinates yet.
  static StoreLocation? fromFirestore(String id, Map<String, dynamic> data) {
    final lat = _toDouble(data['latitude']);
    final lng = _toDouble(data['longitude']);
    if (lat == null || lng == null) return null;

    final products = (data['products'] as List?) ?? const [];
    final boxes = products.whereType<Map>().where((p) {
      final left = p['bagsLeft'];
      final count = left is num ? left : num.tryParse('$left') ?? 0;
      return p['isAvailable'] != false && count > 0;
    }).length;

    final imageUrl = (data['RestaurantimageUrl'] ?? data['restaurantImageUrl'])
        ?.toString()
        .trim();

    return StoreLocation(
      id: id,
      name: (data['name'] ?? '').toString().trim(),
      address: (data['branchLocation'] ?? '').toString().trim(),
      point: LatLng(lat, lng),
      imageUrl: imageUrl != null && imageUrl.startsWith('http')
          ? imageUrl
          : null,
      isOpen: (data['isOpend'] ?? data['isOpenNow']) != false,
      boxesCount: boxes,
    );
  }

  static double? _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}

/// Stores behind the demo boxes, shown until real stores pin their location.
List<StoreLocation> demoStoreLocations() {
  final byId = <String, StoreLocation>{};
  for (final p in demoProducts) {
    final id = p.restaurantId;
    final lat = p.restaurantLatitude;
    final lng = p.restaurantLongitude;
    if (id == null || lat == null || lng == null) continue;
    final existing = byId[id];
    byId[id] = StoreLocation(
      id: id,
      name: p.restaurantName ?? '',
      address: p.branchLocation ?? '',
      point: LatLng(lat, lng),
      isOpen: p.restaurantIsOpenNow ?? true,
      boxesCount: (existing?.boxesCount ?? 0) + 1,
      isDemo: true,
    );
  }
  return byId.values.toList();
}

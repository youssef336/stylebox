import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreRoute {
  final List<LatLng> points;
  final double distanceKm;

  /// Null when the road route couldn't be fetched and [points] is a
  /// straight line between the customer and the store.
  final int? minutes;

  const StoreRoute({
    required this.points,
    required this.distanceKm,
    this.minutes,
  });

  bool get isStraightLine => minutes == null;
}

class RouteService {
  RouteService._();

  /// Driving route from the public OSRM server (no API key needed).
  /// Falls back to a straight line when the server can't be reached.
  static Future<StoreRoute> drivingRoute(LatLng from, LatLng to) async {
    final uri = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final res = await http
          .get(uri, headers: {'User-Agent': 'StyleBox (com.stylebox.app)'})
          .timeout(const Duration(seconds: 12));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final routes = body['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final route = routes.first as Map<String, dynamic>;
          final coords = (route['geometry']['coordinates'] as List)
              .map(
                (c) => LatLng(
                  (c[1] as num).toDouble(),
                  (c[0] as num).toDouble(),
                ),
              )
              .toList();
          if (coords.length >= 2) {
            return StoreRoute(
              points: coords,
              distanceKm: (route['distance'] as num).toDouble() / 1000,
              minutes: ((route['duration'] as num).toDouble() / 60)
                  .ceil()
                  .clamp(1, 100000),
            );
          }
        }
      }
    } catch (_) {
      // Offline or server busy: fall through to the straight line.
    }

    return StoreRoute(
      points: [from, to],
      distanceKm: const Distance().as(LengthUnit.Meter, from, to) / 1000,
    );
  }

  /// Turn-by-turn navigation in the Google Maps app (or the browser).
  static Future<bool> openInGoogleMaps(LatLng destination) {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${destination.latitude},${destination.longitude}'
      '&travelmode=driving',
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

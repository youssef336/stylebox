import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum LocationIssue { serviceDisabled, denied, deniedForever, unavailable }

/// 2.4 / 12 — one decimal only for short distances.
String formatKm(double km) =>
    km < 10 ? km.toStringAsFixed(1) : km.round().toString();

/// Customer location, shared by the map, store cards and box details.
class LocationService {
  LocationService._();

  /// Last known position; null until the user allows location.
  static final ValueNotifier<LatLng?> position = ValueNotifier<LatLng?>(null);

  /// Reads the position only when permission was already granted,
  /// so screens like Home never show a permission prompt.
  static Future<LatLng?> currentIfPermitted() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return position.value;
      }
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) _set(last);
      return position.value;
    } catch (_) {
      return position.value;
    }
  }

  /// Asks for permission when needed and returns a fresh position.
  static Future<({LatLng? point, LocationIssue? issue})> request() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return (point: position.value, issue: LocationIssue.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return (point: null, issue: LocationIssue.deniedForever);
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        return (point: null, issue: LocationIssue.denied);
      }

      final current = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      _set(current);
      return (point: position.value, issue: null);
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition().catchError(
        (_) => null,
      );
      if (last != null) _set(last);
      return (
        point: position.value,
        issue: position.value == null ? LocationIssue.unavailable : null,
      );
    }
  }

  static Future<void> openSettings(LocationIssue issue) async {
    if (issue == LocationIssue.serviceDisabled) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
  }

  /// Straight-line distance in kilometers.
  static double distanceKm(LatLng a, LatLng b) =>
      const Distance().as(LengthUnit.Meter, a, b) / 1000;

  static void _set(Position p) {
    position.value = LatLng(p.latitude, p.longitude);
  }
}

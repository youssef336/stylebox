import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'store_location.dart';

/// Live list of stores that have a map pin.
/// Falls back to the demo stores while Firestore has no stores at all,
/// the same way Home falls back to the demo boxes.
Stream<List<StoreLocation>> watchStoreLocations() {
  return FirebaseFirestore.instance
      .collection('resturants')
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isEmpty) return demoStoreLocations();
        return snapshot.docs
            .map((doc) => StoreLocation.fromFirestore(doc.id, doc.data()))
            .whereType<StoreLocation>()
            .toList();
      });
}

/// OpenStreetMap tiles (free, no API key), darkened in dark mode.
TileLayer storesTileLayer(BuildContext context) {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.stylebox.app',
    tileBuilder: Theme.of(context).brightness == Brightness.dark
        ? darkModeTileBuilder
        : null,
  );
}

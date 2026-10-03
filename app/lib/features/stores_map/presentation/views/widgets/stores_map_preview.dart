// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/features/stores_map/data/store_location.dart';
import 'package:stylebox/features/stores_map/data/stores_location_source.dart';
import 'package:stylebox/features/stores_map/presentation/views/stores_map_view.dart';
import 'package:stylebox/generated/l10n.dart';

/// Small live map on Home that opens the full stores map.
class StoresMapPreview extends StatefulWidget {
  const StoresMapPreview({super.key});

  @override
  State<StoresMapPreview> createState() => _StoresMapPreviewState();
}

class _StoresMapPreviewState extends State<StoresMapPreview> {
  late final Stream<List<StoreLocation>> _stores = watchStoreLocations();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StoreLocation>>(
      stream: _stores,
      builder: (context, snapshot) {
        final stores = snapshot.data ?? const <StoreLocation>[];
        if (stores.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildCard(context, stores),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, List<StoreLocation> stores) {
    final locale = S.of(context)!;
    final points = stores.map((s) => s.point).toList();

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(StoresMapView.routeName),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: KprimaryColor.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              IgnorePointer(
                child: FlutterMap(
                  // Rebuild the camera when the set of stores changes.
                  key: ValueKey(Object.hashAll(points)),
                  options: MapOptions(
                    initialCenter: points.first,
                    initialZoom: 13,
                    initialCameraFit: points.length > 1
                        ? CameraFit.coordinates(
                            coordinates: points,
                            padding: const EdgeInsets.fromLTRB(40, 28, 40, 80),
                            maxZoom: 14,
                          )
                        : null,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    storesTileLayer(context),
                    MarkerLayer(
                      markers: [
                        for (final point in points)
                          Marker(
                            point: point,
                            width: 20,
                            height: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: KprimaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Caption over the bottom of the map
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 28, 12, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.mapPreviewTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              locale.mapPreviewSubtitle('${stores.length}'),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: KprimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.map_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

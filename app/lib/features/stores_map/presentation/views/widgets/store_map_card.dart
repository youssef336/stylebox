// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/location_service.dart';
import 'package:stylebox/features/stores_map/data/route_service.dart';
import 'package:stylebox/features/stores_map/data/store_location.dart';
import 'package:stylebox/generated/l10n.dart';

/// Store info under the map, with in-app directions and a Google Maps link.
class StoreMapCard extends StatelessWidget {
  const StoreMapCard({
    super.key,
    required this.store,
    required this.selected,
    this.distanceKm,
    this.route,
    this.routing = false,
    required this.onTap,
    required this.onDirections,
    required this.onGoogleMaps,
  });

  final StoreLocation store;
  final bool selected;
  final double? distanceKm;

  /// The route drawn on the map, when it leads to this store.
  final StoreRoute? route;
  final bool routing;
  final VoidCallback onTap;
  final VoidCallback onDirections;
  final VoidCallback onGoogleMaps;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? KdarkModeTextColor : KlightModeTextColor;
    final secondary = isDark ? KdarkModeTextSecondary : KlightModeTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? KdarkModeCardColor : KlightModeCardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? KprimaryColor : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.14),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(width: 68, height: 68, child: _photo()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      if (store.address.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          store.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: secondary),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _chip(
                            context,
                            store.isOpen
                                ? locale.mapOpenNow
                                : locale.mapClosedNow,
                            store.isOpen
                                ? const Color(0xFF16A34A)
                                : KaccentColor,
                          ),
                          if (store.boxesCount > 0)
                            _chip(
                              context,
                              locale.mapBoxesCount('${store.boxesCount}'),
                              KprimaryColor,
                            ),
                          if (distanceKm != null)
                            _chip(
                              context,
                              locale.mapDistanceKm(formatKm(distanceKm!)),
                              KprimaryColor,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: routing ? null : onDirections,
                    style: FilledButton.styleFrom(
                      backgroundColor: KprimaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: KprimaryColor.withOpacity(0.7),
                      disabledForegroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: routing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.directions_rounded, size: 20),
                    label: Text(
                      route != null
                          ? _routeSummary(locale, route!)
                          : locale.mapDirections,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onGoogleMaps,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KprimaryColor,
                    minimumSize: const Size(0, 42),
                    side: const BorderSide(color: KprimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.navigation_rounded, size: 18),
                  label: Text(locale.mapGoogleMaps),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _routeSummary(S locale, StoreRoute route) {
    final km = locale.mapDistanceKm(formatKm(route.distanceKm));
    final time = route.isStraightLine
        ? locale.mapRouteStraightLine
        : locale.mapRouteMinutes('${route.minutes}');
    return '$km · $time';
  }

  Widget _photo() {
    final fallback = Container(
      decoration: const BoxDecoration(gradient: KbrandGradient),
      child: const Icon(Icons.storefront_rounded, color: Colors.white),
    );
    final url = store.imageUrl;
    if (url == null) return fallback;
    return Image.network(
      url,
      fit: BoxFit.cover,
      cacheWidth: 200,
      errorBuilder: (_, _, _) => fallback,
    );
  }

  Widget _chip(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

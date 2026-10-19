import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/favorites_store.dart';
import 'package:stylebox/generated/l10n.dart';

/// Image-first product card: the artwork fills the top, with a discount
/// ribbon, a heart button and a price tag floating on the picture. Text sits
/// underneath without a card background, like a fashion catalogue.
class BoxProductCard extends StatelessWidget {
  const BoxProductCard({
    super.key,
    required this.artwork,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.imageHeight,
    this.storeName,
    this.rating = 0,
    this.bagsLeft,
    this.favoriteId,
    this.onTap,
    this.width,
  });

  final Widget artwork;
  final String title;
  final String? storeName;
  final double price;
  final double oldPrice;
  final double rating;
  final int? bagsLeft;
  final String? favoriteId;
  final VoidCallback? onTap;
  final double imageHeight;
  final double? width;

  static String money(double value) =>
      value.toStringAsFixed(value % 1 == 0 ? 0 : 1);

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final discount = oldPrice > price && oldPrice > 0
        ? ((1 - price / oldPrice) * 100).round()
        : 0;
    final lowStock = bagsLeft != null && bagsLeft! <= 3;

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: artwork,
                  ),
                  if (discount > 0)
                    PositionedDirectional(
                      top: 10,
                      start: 10,
                      child: _Tag(
                        text: '-$discount%',
                        ltr: true,
                        background: KaccentColor,
                        foreground: Colors.white,
                      ),
                    ),
                  if (favoriteId != null)
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: _FavoriteButton(id: favoriteId!),
                    ),
                  PositionedDirectional(
                    bottom: 10,
                    start: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: money(price),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: scheme.primary,
                              ),
                            ),
                            TextSpan(
                              text: ' ${locale.bagCurrencySuffix}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (lowStock)
                    PositionedDirectional(
                      bottom: 10,
                      end: 10,
                      child: _Tag(
                        text: locale.bagCardBagsLeft('$bagsLeft'),
                        background: Colors.black.withValues(alpha: 0.55),
                        foreground: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                if (rating > 0) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.star_rounded, size: 15, color: KaccentColor),
                  const SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                if (storeName != null && storeName!.isNotEmpty)
                  Flexible(
                    child: Text(
                      storeName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                if (oldPrice > price) ...[
                  const SizedBox(width: 6),
                  Text(
                    money(oldPrice),
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
    required this.background,
    required this.foreground,
    this.ltr = false,
  });

  final bool ltr;
  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        textDirection: ltr ? TextDirection.ltr : null,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FavoritesStore.ids,
      builder: (context, ids, _) {
        final liked = ids.contains(id);
        return Material(
          color: Colors.white.withValues(alpha: 0.92),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => FavoritesStore.toggle(id),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Icon(
                liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 18,
                color: liked ? KprimaryColor : KlightModeTextColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

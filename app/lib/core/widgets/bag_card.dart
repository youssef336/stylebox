// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/models/bag_item_model.dart';
import 'package:stylebox/features/home/presentation/views/bagel_mystery_bag_screen.dart';
import 'package:stylebox/generated/l10n.dart';

class BagCard extends StatelessWidget {
  final String title;
  final double price;
  final double oldPrice;
  final int bagsLeft;
  final double rating;
  final double width;

  final BagItemModel? bagItemModel;
  const BagCard({
    super.key,
    required this.width,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.bagsLeft,
    required this.rating,
    required this.bagItemModel,
  });

  static String _money(double value) =>
      value.toStringAsFixed(value % 1 == 0 ? 0 : 1);

  void _openDetails(BuildContext context) {
    final product = bagItemModel?.product;
    if (product == null) return;
    Navigator.of(context).pushNamed(
      BagelMysteryBagScreen.routeName,
      arguments: {'product': product, 'restaurant': bagItemModel?.restaurant},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final locale = S.of(context)!;
    final textColor = isDark ? KdarkModeTextColor : KlightModeTextColor;
    final subColor = isDark ? KdarkModeTextSecondary : KlightModeTextSecondary;

    final discount = oldPrice > price && oldPrice > 0
        ? ((1 - price / oldPrice) * 100).round()
        : 0;
    final soldOut = bagsLeft <= 0;
    final lowStock = !soldOut && bagsLeft <= 3;
    final stockColor = soldOut || lowStock ? scheme.error : scheme.primary;

    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        width: width,
        margin: const EdgeInsetsDirectional.only(end: 12, top: 4, bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(KradiusCard),
          border: isDark
              ? Border.all(color: Theme.of(context).dividerColor)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.25)
                  : KprimaryColorDark.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + title + discount
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.checkroom_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: textColor,
                    ),
                  ),
                ),
                if (discount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: KaccentColor.withOpacity(0.6)),
                    ),
                    child: Text(
                      locale.bagCardOff('$discount'),
                      style: TextStyle(
                        color: scheme.onSecondaryContainer,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Prices
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${_money(price)} ${locale.bagCurrencySuffix}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 8),
                if (oldPrice > price)
                  Text(
                    _money(oldPrice),
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: subColor,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Stock + rating
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: stockColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(KradiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 14,
                        color: stockColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        locale.bagCardBagsLeft(bagsLeft.toString()),
                        style: TextStyle(
                          color: stockColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (rating > 0) ...[
                  const Icon(Icons.star_rounded, size: 18, color: KaccentColor),
                  const SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                ],
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: soldOut ? null : () => _openDetails(context),
                child: Text(
                  locale.bagCardReserve,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

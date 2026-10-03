import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/generated/l10n.dart';

class HomeBestSellerHeader extends StatelessWidget {
  const HomeBestSellerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Text(
          S.of(context)!.homeBestSellersTitle,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? KdarkModeTextColor : KlightModeTextColor,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // Navigate to best selling view
          },
          child: Text(
            S.of(context)!.homeBestSellersViewAll,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? KdarkModeTextSecondary : KlightModeTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

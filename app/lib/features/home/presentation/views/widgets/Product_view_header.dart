// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/generated/l10n.dart';

class ProductViewHeader extends StatelessWidget {
  const ProductViewHeader({super.key, required this.productLength});
  final int productLength;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Text(
          S.of(context)!.productViewResults(productLength.toString()),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? KdarkModeTextColor : KlightModeTextColor,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? KdarkModeCardColor : Colors.grey[200],
            border: Border.all(
              color: isDark ? KdarkModeTextSecondary : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.tune,
            size: 20,
            color: isDark ? KdarkModeTextColor : KlightModeTextColor,
          ),
        ),
      ],
    );
  }
}

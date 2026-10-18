import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';

/// The StyleBox wordmark: letter-spaced caps over a short champagne rule.
/// Used at the top of the auth screens.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.color, this.fontSize = 22});

  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? Theme.of(context).colorScheme.onSurface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'STYLEBOX',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: fontSize * 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 36, height: 1.5, color: KaccentColor),
      ],
    );
  }
}

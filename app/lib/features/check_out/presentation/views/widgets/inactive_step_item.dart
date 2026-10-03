import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';

class InactiveStepItem extends StatelessWidget {
  const InactiveStepItem({super.key, required this.text, required this.index});
  final String text;
  final String index;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final numberTextColor = isDark ? KdarkModeTextColor : KprimaryColor;
    final labelTextColor = isDark
        ? KdarkModeTextSecondary
        : const Color(0xFFAAAAAA);
    final circleColor = isDark ? KdarkModeCardColor : const Color(0xFFF2F3F3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: circleColor,
          child: Text(
            index,
            style: AppTextStyles.bodySmallSemibold.copyWith(
              height: 1.70,
              color: numberTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.bodySmallSemibold.copyWith(
            color: labelTextColor,
            height: 1.70,
          ),
        ),
      ],
    );
  }
}

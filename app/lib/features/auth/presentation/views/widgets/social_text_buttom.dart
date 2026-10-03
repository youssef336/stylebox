import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylebox/constant.dart';

import 'package:stylebox/core/utils/text_styles.dart';

class SocialTextButtom extends StatelessWidget {
  const SocialTextButtom({
    super.key,
    this.onPressed,
    required this.image,
    required this.text,
  });
  final void Function()? onPressed;
  final String image;
  final String text;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? KdarkModeCardColor : KlightModeCardColor;
    final borderColor = isDark
        ? KprimaryColorLight.withValues(alpha: 0.25)
        : const Color(0xFFDCDEDE);
    final textColor = isDark ? KdarkModeTextColor : const Color(0xFF0C0D0D);

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor, width: 1),
          ),
        ),
        onPressed: onPressed,

        child: ListTile(
          visualDensity: const VisualDensity(
            vertical: VisualDensity.minimumDensity,
          ),
          leading: SvgPicture.asset(image),
          title: Text(
            textAlign: TextAlign.center,
            text,
            style: AppTextStyles.bodyBaseSemibold.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

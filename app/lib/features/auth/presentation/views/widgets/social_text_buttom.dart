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
    final borderColor = isDark ? KdarkModeDivider : KdisabledColor;
    final textColor = isDark ? KdarkModeTextColor : KlightModeTextColor;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: StadiumBorder(side: BorderSide(color: borderColor, width: 1)),
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

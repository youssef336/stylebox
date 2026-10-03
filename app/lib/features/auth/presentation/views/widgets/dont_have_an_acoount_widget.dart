// ignore_for_file: non_constant_identifier_names

import 'package:flutter/gestures.dart';
// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';

import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/features/auth/presentation/views/sign_up_view.dart';
import 'package:stylebox/generated/l10n.dart';

Text DontHaveAnAcoountWidget(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: S.of(context)!.onLoginCreateAccountText,
          style: AppTextStyles.bodyBaseSemibold.copyWith(
            color: isDark ? KdarkModeTextSecondary : const Color(0xFF949D9E),
          ),
        ),
        TextSpan(
          text: ' ',
          style: AppTextStyles.bodyBaseSemibold.copyWith(
            color: isDark ? KdarkModeTextSecondary : const Color(0xFF616A6B),
          ),
        ),

        TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, SignUpView.routeName);
            },
          text: S.of(context)!.onLoginCreateAccount,
          style: AppTextStyles.bodyBaseSemibold.copyWith(
            color: isDark ? KaccentColor : KprimaryColor,
          ),
        ),
      ],
    ),
    textAlign: TextAlign.center,
  );
}

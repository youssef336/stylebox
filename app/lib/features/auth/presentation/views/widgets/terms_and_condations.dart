// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';

import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/custom_chek_box.dart';
import 'package:stylebox/generated/l10n.dart';

class TermsAndConditionsWidget extends StatefulWidget {
  const TermsAndConditionsWidget({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;
  @override
  State<TermsAndConditionsWidget> createState() =>
      _TermsAndConditionsWidgetState();
}

class _TermsAndConditionsWidgetState extends State<TermsAndConditionsWidget> {
  bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomChekBox(
          onChanged: (value) {
            isTermsAccepted = value;
            widget.onChanged(value);
            setState(() {});
          },
          isChecked: isTermsAccepted,
        ),
        const SizedBox(width: 16),
        SizedBox(
          width:
              MediaQuery.of(context).size.width - (KhorzontalPadding * 2) - 48,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: S.of(context)!.onSignupTermsandConditions,
                  style: AppTextStyles.bodySmallSemibold.copyWith(
                    color: const Color(0xFF949D9E) /* Grayscale-600 */,
                  ),
                ),
                TextSpan(
                  text: S.of(context)!.onSignupTermsandConditionsText,
                  style: AppTextStyles.bodySmallSemibold.copyWith(
                    color: KprimaryColorLight /* Green1-600 */,
                  ),
                ),
                TextSpan(
                  text: ' ',
                  style: AppTextStyles.bodySmallSemibold.copyWith(
                    color: const Color(0xFF616A6B) /* Grayscale-600 */,
                  ),
                ),
                TextSpan(
                  text: S.of(context)!.onSignupTermsandConditionsText2,
                  style: AppTextStyles.bodySmallSemibold.copyWith(
                    color: KprimaryColorLight /* Green1-600 */,
                  ),
                ),
                TextSpan(
                  text: ' ',
                  style: AppTextStyles.bodySmallSemibold.copyWith(
                    color: const Color(0xFF616A6B) /* Grayscale-600 */,
                  ),
                ),
                TextSpan(
                  text: S.of(context)!.onSignupTermsandConditionsText3,
                  style: AppTextStyles.bodySmallSemibold.copyWith(
                    color: KprimaryColorLight /* Green1-600 */,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

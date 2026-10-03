import 'package:flutter/material.dart';
import 'package:stylebox/core/utils/app_decoration.dart';

import 'package:stylebox/core/utils/text_styles.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodysmallBold),
        const SizedBox(height: 8),
        Container(
          decoration: AppDecoration.grayBoxDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
            child: child,
          ),
        ),
      ],
    );
  }
}

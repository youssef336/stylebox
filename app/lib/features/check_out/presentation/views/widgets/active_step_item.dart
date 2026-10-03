import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';

class ActiveStepItem extends StatelessWidget {
  final String text;

  const ActiveStepItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 11.5,
          backgroundColor: KprimaryColor,
          child: Icon(Icons.check, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodysmallBold.copyWith(color: KprimaryColor),
        ),
      ],
    );
  }
}

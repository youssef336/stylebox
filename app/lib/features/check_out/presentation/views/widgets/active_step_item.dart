import 'package:flutter/material.dart';
import 'package:stylebox/core/utils/text_styles.dart';

class ActiveStepItem extends StatelessWidget {
  final String text;

  const ActiveStepItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 11.5,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.check,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodysmallBold.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';

import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/generated/l10n.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 2,
            color: Theme.of(context).dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            S.of(context)!.onLoginLoginOrDivider,
            style: AppTextStyles.bodyBaseSemibold,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ],
    );
  }
}

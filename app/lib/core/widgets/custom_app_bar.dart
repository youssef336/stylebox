// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:stylebox/core/utils/text_styles.dart';

AppBar Custom_app_bar(
  BuildContext context, {
  required String title,
  void Function()? onPressed,
}) {
  return AppBar(
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: onPressed,
    ),
    centerTitle: true,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: AppTextStyles.bodyLargeBold,
    ),
  );
}

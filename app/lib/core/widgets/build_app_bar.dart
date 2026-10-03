import 'package:flutter/material.dart';
import 'package:stylebox/core/widgets/notification_widget.dart';

import '../utils/text_styles.dart';

AppBar buildAppbar(
  BuildContext context, {
  required String title,
  bool showBackButton = true,
  bool showNotification = true,
}) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    leading: Visibility(
      visible: showBackButton,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    actions: [
      Visibility(
        visible: showNotification,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: NotificationWidget(),
        ),
      ),
    ],
    title: Text(title, style: AppTextStyles.cairoBold19),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

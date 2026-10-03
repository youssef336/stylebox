import 'package:flutter/material.dart';

void showErrorBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(duration: const Duration(seconds: 3), content: Text(message)),
  );
}

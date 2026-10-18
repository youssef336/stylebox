import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';

abstract class AppDecoration {
  static var grayBoxDecoration = ShapeDecoration(
    color: KlightModeFieldColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(KradiusField),
    ),
  );
}

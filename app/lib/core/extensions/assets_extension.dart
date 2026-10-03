import 'package:flutter/material.dart';
import 'package:stylebox/core/utils/assets.dart';

extension AssetsExt on BuildContext {
  AssetsData get assets => AssetsData.brightness(Theme.of(this).brightness);
}

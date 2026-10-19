// Builds docs/screens.jpg from the PNGs in docs/screenshots (run after the
// app and dashboard screenshot tests):
//
//   flutter test --dart-define=SCREENSHOTS=true test/screenshots/montage_test.dart
@Tags(['screenshots'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:stylebox/constant.dart';

import 'screenshot_harness.dart';

const _rows = [
  (
    'Customer app',
    [
      'app_onboarding',
      'app_login',
      'app_home',
      'app_product_details',
      'app_cart',
      'app_profile',
    ],
  ),
  (
    'Checkout · Arabic RTL · Store dashboard',
    [
      'app_checkout',
      'app_home_ar',
      'dashboard_login',
      'dashboard_home',
      'dashboard_products',
      'dashboard_add_product',
    ],
  ),
];

const _phoneW = 330.0;
const _phoneH = _phoneW * 2532 / 1170;
const _gap = 40.0;
const _pad = 80.0;

void main() {
  testWidgets(
    'compose montage',
    skip: !kCaptureScreenshots,
    (tester) async {
      await loadAppFonts();
      const width = _pad * 2 + 6 * _phoneW + 5 * _gap;
      const height = 175 + 2 * (_phoneH + 70) + _gap + _pad;
      tester.view.physicalSize = const Size(width, height);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final images = <String, MemoryImage>{
        for (final row in _rows)
          for (final name in row.$2)
            name: MemoryImage(
              File('../docs/screenshots/$name.png').readAsBytesSync(),
            ),
      };

      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RepaintBoundary(
            key: key,
            child: Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFAF7F4), Color(0xFFF3E6E9)],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(_pad, 56, _pad, _pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'STYLEBOX',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 14,
                          color: KlightModeTextColor,
                        ),
                      ),
                      SizedBox(width: 24),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Atelier redesign — customer app & store dashboard',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: KprimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  for (final row in _rows) ...[
                    Text(
                      row.$1.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                        color: KlightModeTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        for (var i = 0; i < row.$2.length; i++) ...[
                          if (i > 0) const SizedBox(width: _gap),
                          _Phone(image: images[row.$2[i]]!),
                        ],
                      ],
                    ),
                    const SizedBox(height: _gap),
                  ],
                ],
              ),
            ),
          ),
        ),
      );

      await tester.runAsync(() async {
        for (final provider in images.values) {
          await precacheImage(provider, key.currentContext!);
        }
      });
      await tester.pump();

      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final raw = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final out = img.Image.fromBytes(
          width: image.width,
          height: image.height,
          bytes: raw!.buffer,
          numChannels: 4,
        );
        File('../docs/screens.jpg').writeAsBytesSync(
          img.encodeJpg(out, quality: 86),
        );
      });
    },
  );
}

class _Phone extends StatelessWidget {
  const _Phone({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _phoneW,
      height: _phoneH,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1816),
        borderRadius: BorderRadius.circular(46),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(39),
        child: Image(image: image, fit: BoxFit.cover),
      ),
    );
  }
}

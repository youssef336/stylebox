// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/features/stores_map/data/store_location.dart';

/// Teardrop pin with the store photo. The tip sits on the store's location.
class StoreMapPin extends StatelessWidget {
  const StoreMapPin({super.key, required this.store, required this.selected});

  static const double markerWidth = 60;
  static const double markerHeight = 70;

  final StoreLocation store;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final size = selected ? 56.0 : 44.0;
    final ring = selected ? KprimaryColor : Colors.white;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: size,
          height: size,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: ring,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(child: _photo()),
        ),
        CustomPaint(size: const Size(14, 9), painter: _PinTipPainter(ring)),
      ],
    );
  }

  Widget _photo() {
    final fallback = Container(
      color: KprimaryColorLight,
      child: const Icon(
        Icons.checkroom_rounded,
        color: KprimaryColor,
        size: 20,
      ),
    );
    final url = store.imageUrl;
    if (url == null) return fallback;
    return Image.network(
      url,
      fit: BoxFit.cover,
      cacheWidth: 140,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class _PinTipPainter extends CustomPainter {
  _PinTipPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PinTipPainter oldDelegate) => oldDelegate.color != color;
}

/// The customer's position.
class UserLocationDot extends StatelessWidget {
  const UserLocationDot({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1A73E8);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: blue.withOpacity(0.22),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4),
          ],
        ),
      ),
    );
  }
}

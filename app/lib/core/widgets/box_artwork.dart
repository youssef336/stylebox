import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/entities/product_entity.dart';

/// Image-first visual for a Style Box.
///
/// Shows the box photo when the store uploaded one, otherwise an editorial
/// "fabric swatch": a tonal gradient picked from the Atelier palette by
/// category, a soft weave texture and an oversized garment glyph. Used by the
/// home cards, cart rows and the product hero so every box has a picture.
class BoxArtwork extends StatelessWidget {
  const BoxArtwork({
    super.key,
    required this.product,
    this.iconSize = 72,
    this.borderRadius = BorderRadius.zero,
  });

  final ProductEntity product;
  final double iconSize;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = product.imageUrl.trim();
    final tone = BoxTone.of(product);

    Widget fallback = _Swatch(tone: tone, iconSize: iconSize);
    Widget child;
    if (url.startsWith('http')) {
      child = Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    } else if (url.startsWith('assets/')) {
      child = Image.asset(url, fit: BoxFit.cover);
    } else {
      child = fallback;
    }

    return ClipRRect(borderRadius: borderRadius, child: child);
  }
}

/// Colour story for a box without a photo.
class BoxTone {
  const BoxTone(this.colors, this.ink, this.icon);

  final List<Color> colors;
  final Color ink;
  final IconData icon;

  static const _blush = BoxTone(
    [Color(0xFFF6E8EC), Color(0xFFE7C3CF)],
    KprimaryColor,
    Icons.checkroom_rounded,
  );
  static const _espresso = BoxTone(
    [Color(0xFF3A2C29), Color(0xFF1E1816)],
    KaccentColor,
    Icons.dry_cleaning_rounded,
  );
  static const _champagne = BoxTone(
    [Color(0xFFF5ECDD), Color(0xFFE3CBA3)],
    Color(0xFF8A6631),
    Icons.child_care_rounded,
  );
  static const _bordeaux = BoxTone(
    [Color(0xFFB0506B), Color(0xFF5E1A2F)],
    Color(0xFFF5ECDD),
    Icons.shopping_bag_outlined,
  );

  static const all = [_blush, _espresso, _champagne, _bordeaux];

  static BoxTone of(ProductEntity product) {
    switch (product.category) {
      case 'women':
        return _blush;
      case 'men':
        return _espresso;
      case 'kids':
        return _champagne;
      case 'unisex':
        return _bordeaux;
    }
    final seed = product.documentId.isNotEmpty
        ? product.documentId
        : product.code;
    return all[seed.hashCode.abs() % all.length];
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.tone, required this.iconSize});

  final BoxTone tone;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: tone.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomPaint(
        painter: _WeavePainter(tone.ink.withValues(alpha: 0.07)),
        child: Center(
          child: Icon(
            tone.icon,
            size: iconSize,
            color: tone.ink.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

/// Fine diagonal twill lines, like a close-up of fabric.
class _WeavePainter extends CustomPainter {
  _WeavePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const gap = 9.0;
    for (double x = -size.height; x < size.width; x += gap) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeavePainter oldDelegate) =>
      oldDelegate.color != color;
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InActiveItem extends StatelessWidget {
  const InActiveItem({super.key, required this.imagePath});
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unselected =
        Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
        scheme.onSurfaceVariant;

    return Center(
      child: SvgPicture.asset(
        imagePath,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(unselected, BlendMode.srcIn),
      ),
    );
  }
}

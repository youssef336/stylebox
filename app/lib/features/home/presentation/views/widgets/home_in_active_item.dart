import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InActiveItem extends StatelessWidget {
  const InActiveItem({super.key, required this.imagePath, this.text});
  final String imagePath;
  final String? text;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unselected =
        Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
        scheme.onSurfaceVariant;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          child: Center(
            child: SvgPicture.asset(
              imagePath,
              width: 21,
              height: 21,
              colorFilter: ColorFilter.mode(unselected, BlendMode.srcIn),
            ),
          ),
        ),
        if (text != null) ...[
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text!,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: unselected,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

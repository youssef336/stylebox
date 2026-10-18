import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Selected tab: Bordeaux icon and label under a short "tailor's mark"
/// indicator, sitting on a soft blush pill.
class ActiveItem extends StatelessWidget {
  const ActiveItem({super.key, required this.text, required this.image});

  final String text;
  final String image;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 30,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            image,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: scheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

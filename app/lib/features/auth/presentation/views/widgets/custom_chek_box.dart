import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylebox/core/utils/assets.dart';

import 'package:stylebox/constant.dart';

class CustomChekBox extends StatelessWidget {
  const CustomChekBox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked);
      },
      child: AnimatedContainer(
        width: 24,
        height: 24,
        duration: const Duration(milliseconds: 120),
        decoration: ShapeDecoration(
          color: isChecked ? KprimaryColor : Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.50,
              color: isChecked
                  ? Colors.transparent
                  : Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isChecked
            ? Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(AssetsData.light().images.Check_svg),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

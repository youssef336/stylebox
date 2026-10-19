// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';

class ShipinngItem extends StatelessWidget {
  const ShipinngItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });
  final String title, subTitle;
  final Widget price;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.only(
          top: 16,
          left: 13,
          right: 28,
          bottom: 16,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).inputDecorationTheme.fillColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(KradiusField),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isSelected
                  ? const ActiveShipinngItemDot()
                  : const InActiveShipinngItemDot(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cairoRegular.copyWith(
                        height: 1.70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.cairoRegular.copyWith(
                        height: 1.60,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(child: price),
            ],
          ),
        ),
      ),
    );
  }
}

class InActiveShipinngItemDot extends StatelessWidget {
  const InActiveShipinngItemDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const ShapeDecoration(
        shape: OvalBorder(side: BorderSide(width: 1.2, color: KdisabledColor)),
      ),
    );
  }
}

class ActiveShipinngItemDot extends StatelessWidget {
  const ActiveShipinngItemDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: OvalBorder(
          side: BorderSide(width: 4, color: Theme.of(context).cardColor),
        ),
      ),
    );
  }
}

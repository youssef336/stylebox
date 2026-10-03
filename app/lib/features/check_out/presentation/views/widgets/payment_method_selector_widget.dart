// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/features/check_out/domains/entities/checkout_payment_method.dart';

class PaymentMethodSelectorWidget extends StatelessWidget {
  const PaymentMethodSelectorWidget({
    super.key,
    required this.selectedIndex,
    required this.onMethodSelected,
    required this.methods,
    required this.titles,
    required this.subtitles,
    required this.prices,
  });

  final int selectedIndex;
  final Function(int) onMethodSelected;
  final List<CheckoutPaymentMethod> methods;
  final List<String> titles;
  final List<String> subtitles;
  final List<String> prices;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(
          methods.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 16, top: index == 0 ? 0 : 0),
            child: _PaymentMethodCard(
              isSelected: selectedIndex == index,
              title: titles[index],
              subtitle: subtitles[index],
              price: prices[index],
              onTap: () => onMethodSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  });

  final bool isSelected;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlightColor = isDark ? KaccentColor : KprimaryColor;
    final titleColor = isDark ? KdarkModeTextColor : KlightModeTextColor;
    final subtitleColor = isDark
        ? KdarkModeTextSecondary
        : KlightModeTextSecondary;
    final priceColor = isDark ? KsecondaryColor : KprimaryColor;
    final cardBackgroundColor = isDark
        ? KdarkModeCardColor
        : const Color(0x33D9D9D9);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: ShapeDecoration(
          color: isSelected
              ? highlightColor.withOpacity(isDark ? 0.18 : 0.1)
              : cardBackgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected ? highlightColor : Colors.transparent,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 26,
              height: 26,
              decoration: ShapeDecoration(
                color: isSelected ? highlightColor : Colors.transparent,
                shape: OvalBorder(
                  side: BorderSide(
                    width: 2,
                    color: isSelected
                        ? highlightColor
                        : (isDark
                              ? KdarkModeTextSecondary
                              : const Color(0xFF949D9E)),
                  ),
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.check, size: 16, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cairoRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cairoRegular.copyWith(
                      fontSize: 12,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Price
            Text(
              price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodysmallBold.copyWith(
                color: priceColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_points_cupon.dart';
import 'package:stylebox/generated/l10n.dart';

class DiscountTierCard extends StatelessWidget {
  final int requiredPoints;
  final int discountPercent;
  final bool isUnlocked;
  final double progress;
  final int currentPoints;

  const DiscountTierCard({
    super.key,
    required this.requiredPoints,
    required this.discountPercent,
    required this.isUnlocked,
    required this.progress,
    required this.currentPoints,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileViewPointsCupon(discountPercent: discountPercent),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnlocked
              ? KsecondaryColor
              : (isDark ? KdarkModeCardColor : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? KprimaryColorLight
                : (isDark
                      ? KdarkModeTextSecondary.withOpacity(0.35)
                      : Colors.grey[300]!),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isUnlocked
                  ? KprimaryColorLight.withOpacity(0.2)
                  : (isDark
                        ? Colors.black.withOpacity(0.25)
                        : Colors.grey.withOpacity(0.1)),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon/Status Indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? KprimaryColor
                        : (isDark
                              ? KdarkModeTextSecondary.withOpacity(0.25)
                              : Colors.grey[300]),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUnlocked ? Icons.check_circle : Icons.lock,
                    color: isUnlocked
                        ? KsecondaryColor
                        : (isDark ? KdarkModeTextColor : Colors.grey[600]),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Discount Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$discountPercent% ${S.of(context)!.pointsPageDiscount}',
                        style: AppTextStyles.cairoBold.copyWith(
                          fontSize: 20,
                          color: isUnlocked
                              ? KprimaryColor
                              : (isDark
                                    ? KdarkModeTextColor
                                    : Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$requiredPoints ${S.of(context)!.pointsPagePointsRequired}',
                        style: AppTextStyles.bodySmallRegular.copyWith(
                          color: isUnlocked
                              ? KprimaryColor.withOpacity(0.7)
                              : (isDark
                                    ? KdarkModeTextSecondary
                                    : Colors.grey[600]),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                if (isUnlocked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: KprimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      S.of(context)!.pointsPageUnlocked,
                      style: AppTextStyles.bodyXSmallSemibold.copyWith(
                        color: KsecondaryColor,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            // Progress Bar (only show if not unlocked)
            if (!isUnlocked) ...[
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context)!.pointsPageProgress,
                        style: AppTextStyles.bodySmallSemibold.copyWith(
                          color: isDark
                              ? KdarkModeTextSecondary
                              : Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$currentPoints/$requiredPoints',
                        style: AppTextStyles.bodySmallSemibold.copyWith(
                          color: isDark ? KaccentColor : KprimaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark
                          ? KdarkModeTextSecondary.withOpacity(0.25)
                          : Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? KaccentColor : KprimaryColor,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${requiredPoints - currentPoints} ${S.of(context)!.pointsPagePointsToGo}',
                    style: AppTextStyles.bodyXSmallRegular.copyWith(
                      color: isDark ? KdarkModeTextSecondary : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

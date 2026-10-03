// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/generated/l10n.dart';

class ProfileViewPointsCupon extends StatelessWidget {
  final int discountPercent;

  const ProfileViewPointsCupon({super.key, required this.discountPercent});
  static const String routeName = '/';

  String _generateShortCoupon() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  @override
  Widget build(BuildContext context) {
    // Check if a coupon already exists, if so use it; otherwise generate new one
    String couponCode = Prefs.getString(KCupon);
    final existingDiscount = Prefs.getInt(KCuponDiscount);

    // Only generate a new coupon if none exists or the discount has changed
    if (couponCode.isEmpty || existingDiscount != discountPercent) {
      couponCode = _generateShortCoupon();
      Prefs.setString(KCupon, couponCode);
      Prefs.setInt(KCuponDiscount, discountPercent);
    }

    return Scaffold(
      backgroundColor: KlightModeBgColor,
      appBar: AppBar(
        title: Text(S.of(context)!.couponPageTitle),
        centerTitle: true,
        backgroundColor: KprimaryColor,
        foregroundColor: KprimaryColorLight,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(KhorzontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Coupon Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: KprimaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Discount Badge at the top
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [KprimaryColor, KprimaryColorDark],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$discountPercent% ${S.of(context)!.pointsPageDiscount}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: KprimaryColorLight,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: KprimaryColorLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 48,
                        color: KaccentColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      S.of(context)!.couponCodeLabel,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: KprimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context)!.couponPageDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        color: KlightModeTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Coupon Code with Dashed Border
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: KprimaryColorLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: KaccentColor,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            couponCode,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: KprimaryColor,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Copy Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: couponCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context)!.couponCopiedMessage),
                              backgroundColor: KaccentColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: Text(S.of(context)!.couponCopyButton),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KprimaryColor,
                          foregroundColor: KprimaryColorLight,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info Text
              Text(
                S.of(context)!.couponUniqueText,
                style: const TextStyle(
                  fontSize: 12,
                  color: KlightModeTextSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

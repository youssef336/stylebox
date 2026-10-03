// ignore_for_file: unchecked_use_of_nullable_value, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import '../../../../../core/services/shared_preferences_singletone.dart';
import '../../../../../core/utils/text_styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../auth/presentation/views/Sign_in_view.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.subtitle,
    required this.title,
    required this.isVisible,
  });

  final String image;
  final String subtitle;
  final Widget title;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight),
        child: IntrinsicHeight(
          child: Column(
            children: [
              /// 🔹 Hero: brand gradient + illustration
              Container(
                height: screenHeight * 0.55,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: KbrandGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -60,
                      right: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: -50,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 56, 28, 24),
                      child: Image.asset(image, fit: BoxFit.contain),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              title,

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyBaseSemibold.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Prefs.setBool(KisBoardingViewSeen, true);
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(SigninView.routeName);
                    },
                    child: Text(
                      S.of(context)!.onBoardingSkip,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

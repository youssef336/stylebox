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
              /// Hero: an arched "boutique window" frame around the
              /// illustration.
              SafeArea(
                bottom: false,
                child: Container(
                  height: screenHeight * 0.5,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                  decoration: BoxDecoration(
                    gradient: KbrandGradient,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(220),
                      bottom: Radius.circular(KradiusCard),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: KprimaryColorDark.withOpacity(0.18),
                        blurRadius: 30,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(210),
                                bottom: Radius.circular(KradiusCard - 6),
                              ),
                              border: Border.all(
                                color: KaccentColor.withOpacity(0.55),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 64, 32, 28),
                        child: Image.asset(image, fit: BoxFit.contain),
                      ),
                    ],
                  ),
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Prefs.setBool(KisBoardingViewSeen, true);
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(SigninView.routeName);
                    },
                    child: Text(
                      S.of(context)!.onBoardingSkip,
                      style: const TextStyle(fontSize: 15),
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

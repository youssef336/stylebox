// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/generated/l10n.dart';

/// Gradient promo card at the top of the home screen.
class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;

    return Container(
      width: double.infinity,
      height: 152,
      decoration: BoxDecoration(
        gradient: KbrandGradient,
        borderRadius: BorderRadius.circular(KradiusCard),
        boxShadow: [
          BoxShadow(
            color: KprimaryColorDark.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KradiusCard),
        child: Stack(
          children: [
            // Champagne hairline rings: a quiet, boutique-style ornament.
            PositionedDirectional(
              end: -40,
              top: -40,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: KaccentColor.withOpacity(0.45),
                    width: 1,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              end: -10,
              top: -10,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: KaccentColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              end: 18,
              bottom: 14,
              child: Icon(
                Icons.checkroom_outlined,
                size: 76,
                color: Colors.white.withOpacity(0.16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 18, height: 1.5, color: KaccentColor),
                      const SizedBox(width: 8),
                      const Text(
                        'STYLEBOX',
                        style: TextStyle(
                          color: KaccentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    locale.homeHeroTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      locale.homeHeroSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

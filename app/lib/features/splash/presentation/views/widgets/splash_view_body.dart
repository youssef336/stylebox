import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/firebase_auth_services.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/features/auth/presentation/views/Sign_in_view.dart';
import 'package:stylebox/features/home/presentation/views/main_view.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../../onBoarding/presentation/views/on_boarding.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  bool isBorderingViewSeen = Prefs.getBool(KisBoardingViewSeen);
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Fade from transparent to fully visible
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start animation
    _controller.forward();

    // Navigate after animation completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        if (!mounted) return; // Check if widget is still mounted

        try {
          if (isBorderingViewSeen) {
            var isLoggedIn = FirebaseAuthServices().isUserLoggedIn();
            if (isLoggedIn) {
              // User is logged in, navigate to home
              Navigator.pushReplacementNamed(context, MainView.routeName);
            } else {
              // User is not logged in, navigate to sign-in
              Navigator.pushReplacementNamed(context, SigninView.routeName);
            }
          } else {
            Navigator.pushReplacementNamed(context, OnBoarding.routeName);
          }
        } catch (e) {
          print('Navigation error: $e');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: KbrandGradient),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icon/splash_logo.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const Text(
                  'StyleBox',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  S.of(context)!.homeHeroTitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

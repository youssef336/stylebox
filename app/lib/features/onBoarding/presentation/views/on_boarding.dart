import 'package:flutter/material.dart';

import 'package:stylebox/features/onBoarding/presentation/views/widgets/on_boarding_body.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});
  static const routeName = '/onBoarding';
  @override
  Widget build(BuildContext context) {
    // Full-bleed: the hero runs under the status bar.
    return const Scaffold(body: OnBoardingViewBody());
  }
}

import 'package:flutter/material.dart';

import 'package:stylebox/features/onBoarding/presentation/views/widgets/on_boarding_body.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});
  static const routeName = '/onBoarding';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: OnBoardingViewBody()));
  }
}

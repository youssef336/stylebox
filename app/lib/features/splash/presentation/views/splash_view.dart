import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: KprimaryColor,
      body: SplashViewBody(),
    );
  }
}

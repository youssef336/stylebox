// ignore_for_file: deprecated_member_use

import 'package:dots_indicator/dots_indicator.dart';
// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/widgets/custom_buttom.dart';
import 'package:stylebox/features/auth/presentation/views/Sign_in_view.dart';
import 'package:stylebox/features/onBoarding/presentation/views/widgets/on_boarding_page_view.dart';

import '../../../../../generated/l10n.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;

  var currentPage = 0;
  @override
  void initState() {
    pageController = PageController();

    pageController.addListener(() {
      currentPage = pageController.page!.round();

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: OnBoardingPageView(pageController: pageController)),
        DotsIndicator(
          dotsCount: 2,
          position: currentPage.toDouble(),
          decorator: DotsDecorator(
            activeColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.22),
            size: const Size.square(7),
            activeSize: const Size(24, 7),
            activeShape: const StadiumBorder(),
            spacing: const EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
        const SizedBox(height: 25),

        Visibility(
          visible: currentPage == 1 ? true : false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: KhorzontalPadding),
            child: CustomButtom(
              onPressed: () {
                Prefs.setBool(KisBoardingViewSeen, true);
                Navigator.of(
                  context,
                ).pushReplacementNamed(SigninView.routeName);
              },
              text: S.of(context)!.onBoardingButtomText,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
      ],
    );
  }
}

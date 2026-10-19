import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';

class OnBoardingPageData {
  const OnBoardingPageData({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final String title;
  final String subtitle;
}

/// Swipeable full-bleed hero: Bordeaux gradient, champagne hairline rings
/// and the illustration set inside a large ivory "spotlight" disc.
class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.pageController,
    required this.pages,
    required this.onPageChanged,
  });

  final PageController pageController;
  final List<OnBoardingPageData> pages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: KbrandGradient),
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        itemCount: pages.length,
        itemBuilder: (context, index) => _Hero(image: pages[index].image),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth * 0.82;
        return Stack(
          alignment: Alignment.center,
          children: [
            for (final scale in const [1.28, 1.12])
              Container(
                width: size * scale,
                height: size * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: KaccentColor.withValues(alpha: 0.35),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
              child: Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(size * 0.12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: KlightModeBgColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 40,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ],
        );
      },
    );
  }
}

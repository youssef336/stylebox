import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/features/auth/presentation/views/Sign_in_view.dart';
import 'package:stylebox/features/onBoarding/presentation/views/widgets/on_boarding_page_view.dart';

import '../../../../../generated/l10n.dart';

/// Full-bleed onboarding: a swipeable Bordeaux hero with the illustration,
/// and a fixed ivory sheet with a segmented progress bar, the copy and the
/// next / start control.
class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _finish() {
    Prefs.setBool(KisBoardingViewSeen, true);
    Navigator.of(context).pushReplacementNamed(SigninView.routeName);
  }

  void _next() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final pages = [
      OnBoardingPageData(
        image: AssetsData.light().images.onboardingImage_png,
        title: locale.onBoardingTitle,
        subtitle: locale.onBoardingSubtitle,
      ),
      OnBoardingPageData(
        image: 'assets/images/onboarding_scan.png',
        title: locale.onBoardingTitle2,
        subtitle: locale.onBoardingSubtitle2,
      ),
    ];
    final isLast = currentPage == pages.length - 1;
    final page = pages[currentPage];
    final scheme = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        // ── Hero (swipeable) ────────────────────────────────────────────
        Positioned.fill(
          bottom: MediaQuery.sizeOf(context).height * 0.36,
          child: OnBoardingPageView(
            pageController: pageController,
            pages: pages,
            onPageChanged: (value) => setState(() => currentPage = value),
          ),
        ),

        // ── Top bar: step counter + skip ────────────────────────────────
        Positioned(
          top: topInset + 8,
          left: 24,
          right: 12,
          child: Row(
            children: [
              Text(
                '0${currentPage + 1} / 0${pages.length}',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _finish,
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Text(locale.onBoardingSkip),
              ),
            ],
          ),
        ),

        // ── Bottom sheet card ───────────────────────────────────────────
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              28,
              28,
              28,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(34),
              ),
              boxShadow: [
                BoxShadow(
                  color: KprimaryColorDark.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(pages.length, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsetsDirectional.only(
                          end: index == pages.length - 1 ? 0 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: AlignmentDirectional.centerStart,
                        child: AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 350),
                          widthFactor: index <= currentPage ? 1 : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 26),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(currentPage),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          height: 1.15,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        page.subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: isLast
                            ? SizedBox(
                                key: const ValueKey('start'),
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _finish,
                                  child: Text(locale.onBoardingButtomText),
                                ),
                              )
                            : SizedBox(
                                key: const ValueKey('next'),
                                height: 56,
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Text(
                                    locale.onBoardingNext,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                      color: scheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    if (!isLast) ...[
                      const SizedBox(width: 16),
                      Material(
                        color: scheme.primary,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _next,
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: Icon(
                              Directionality.of(context) == TextDirection.rtl
                                  ? Icons.arrow_back_rounded
                                  : Icons.arrow_forward_rounded,
                              color: scheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

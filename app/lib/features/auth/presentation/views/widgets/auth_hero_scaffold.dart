import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/generated/l10n.dart';

/// Shared auth layout: a Bordeaux hero with an arched bottom edge, and a
/// floating form card that overlaps it. The card starts with a segmented
/// Login / Sign up switch.
class AuthHeroLayout extends StatelessWidget {
  const AuthHeroLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isLogin,
    required this.onSwitch,
    required this.child,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final bool isLogin;
  final VoidCallback onSwitch;
  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    const heroHeight = 300.0;

    return SingleChildScrollView(
      child: Stack(
        children: [
          ClipPath(
            clipper: _ArchClipper(),
            child: Container(
              height: heroHeight + topInset,
              width: double.infinity,
              decoration: const BoxDecoration(gradient: KbrandGradient),
              child: Stack(
                children: [
                  PositionedDirectional(
                    end: -70,
                    top: -40,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: KaccentColor.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    end: 24,
                    top: topInset + 70,
                    child: Icon(
                      Icons.checkroom_rounded,
                      size: 120,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(28, topInset + 12, 28, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 44,
                          child: Row(
                            children: [
                              if (onBack != null)
                                IconButton(
                                  onPressed: onBack,
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  alignment: AlignmentDirectional.centerStart,
                                  icon: const BackButtonIcon(),
                                )
                              else
                                const Text(
                                  'STYLEBOX',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 4.5,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        Container(width: 28, height: 2, color: KaccentColor),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: 270,
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 290,
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              18,
              heroHeight + topInset - 46,
              18,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: KprimaryColorDark.withValues(alpha: 0.08),
                    blurRadius: 36,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _AuthSwitch(isLogin: isLogin, onSwitch: onSwitch),
                  const SizedBox(height: 22),
                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 70)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 10,
        size.width,
        size.height - 70,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _AuthSwitch extends StatelessWidget {
  const _AuthSwitch({required this.isLogin, required this.onSwitch});

  final bool isLogin;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    Widget segment(String label, bool active) => Expanded(
      child: GestureDetector(
        onTap: active ? null : onSwitch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? scheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          segment(locale.onLoginLogin, isLogin),
          segment(locale.onSignupSignup, !isLogin),
        ],
      ),
    );
  }
}

/// "or continue with" + a row of round social icon buttons.
class SocialIconRow extends StatelessWidget {
  const SocialIconRow({super.key, required this.buttons});

  final List<({String? svg, IconData? icon, VoidCallback onTap})> buttons;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Theme.of(context).dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                S.of(context)!.authContinueWith,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(child: Divider(color: Theme.of(context).dividerColor)),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final b in buttons)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Material(
                  color: scheme.surface,
                  shape: CircleBorder(
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: b.onTap,
                    child: SizedBox(
                      width: 58,
                      height: 58,
                      child: Center(
                        child: b.svg != null
                            ? SvgPicture.asset(b.svg!, width: 24, height: 24)
                            : Icon(b.icon, size: 26, color: scheme.onSurface),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

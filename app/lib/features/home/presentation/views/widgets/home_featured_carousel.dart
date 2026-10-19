import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/features/ai_chat/presentation/views/ai_chat_view.dart';
import 'package:stylebox/features/stores_map/presentation/views/stores_map_view.dart';
import 'package:stylebox/generated/l10n.dart';

/// Peeking carousel of editorial slides (promo, stores map, AI stylist)
/// with a segmented progress indicator.
class HomeFeaturedCarousel extends StatefulWidget {
  const HomeFeaturedCarousel({super.key});

  @override
  State<HomeFeaturedCarousel> createState() => _HomeFeaturedCarouselState();
}

class _HomeFeaturedCarouselState extends State<HomeFeaturedCarousel> {
  final _controller = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final slides = [
      _Slide(
        eyebrow: 'STYLEBOX',
        title: locale.homeHeroTitle,
        subtitle: locale.homeHeroSubtitle,
        colors: const [Color(0xFF5E1A2F), KprimaryColor, Color(0xFFB0506B)],
        ink: Colors.white,
        accent: KaccentColor,
        badge: '-70%',
        icon: Icons.checkroom_rounded,
      ),
      _Slide(
        eyebrow: locale.mapTitle.toUpperCase(),
        title: locale.mapPreviewTitle,
        subtitle: locale.mapShowAll,
        colors: const [Color(0xFFF5ECDD), Color(0xFFE3CBA3)],
        ink: KlightModeTextColor,
        accent: KprimaryColor,
        icon: Icons.map_outlined,
        onTap: () => Navigator.of(context).pushNamed(StoresMapView.routeName),
      ),
      _Slide(
        eyebrow: locale.aiChatTitle.toUpperCase(),
        title: locale.homeAiSlideTitle,
        subtitle: locale.homeAiSlideSubtitle,
        colors: const [Color(0xFF3A2C29), Color(0xFF1E1816)],
        ink: Colors.white,
        accent: KaccentColor,
        icon: Icons.auto_awesome_outlined,
        onTap: () => Navigator.of(context).pushNamed(AiChatView.routeName),
      ),
    ];

    return Column(
      children: [
        const SizedBox(height: 14),
        SizedBox(
          height: 172,
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: slides.length,
            onPageChanged: (value) => setState(() => _page = value),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsetsDirectional.only(
                start: index == 0 ? KhorzontalPadding : 6,
                end: 6,
              ),
              child: slides[index],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: KhorzontalPadding),
          child: Row(
            children: List.generate(slides.length, (index) {
              final active = index == _page;
              return Expanded(
                flex: active ? 3 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 3,
                  margin: const EdgeInsetsDirectional.only(end: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.ink,
    required this.accent,
    required this.icon,
    this.badge,
    this.onTap,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final Color ink;
  final Color accent;
  final IconData icon;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PositionedDirectional(
              end: -26,
              bottom: -30,
              child: Icon(icon, size: 150, color: ink.withValues(alpha: 0.12)),
            ),
            if (badge != null)
              PositionedDirectional(
                end: 18,
                top: 18,
                child: Container(
                  width: 62,
                  height: 62,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent,
                  ),
                  child: Text(
                    badge!,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: TextStyle(
                      color: accent,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 220,
                    child: Text(
                      title,
                      maxLines: 2,
                      style: TextStyle(
                        color: ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 230,
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ink.withValues(alpha: 0.8),
                        fontSize: 12.5,
                        height: 1.4,
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

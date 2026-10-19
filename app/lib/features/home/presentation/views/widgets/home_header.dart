import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/cubits/avatar/avatar_cubit.dart';
import 'package:stylebox/core/helper_functions/get_user.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/features/ai_chat/presentation/views/ai_chat_view.dart';
import 'package:stylebox/features/food_scan/presentation/views/food_scan_view.dart';
import 'package:stylebox/features/home/presentation/views/widgets/custom_app_bar_points.dart';
import 'package:stylebox/generated/l10n.dart';

/// Editorial home header: wordmark + points + AI stylist on top, a large
/// two-line greeting with the avatar, then a search field with a scan key.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onSearchChanged});

  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = S.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KhorzontalPadding,
        10,
        KhorzontalPadding,
        6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'STYLEBOX',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4.5,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Container(width: 18, height: 1.5, color: KaccentColor),
              const Spacer(),
              const CustomappBarPoints(),
              const SizedBox(width: 8),
              _RoundIconButton(
                icon: Icons.auto_awesome_outlined,
                onTap: () =>
                    Navigator.of(context).pushNamed(AiChatView.routeName),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.homeViewWelcomeAppbar,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      getUser().name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1.2,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const _HeaderAvatar(),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: locale.searchProductsHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    fillColor: scheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: scheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: scheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () =>
                      Navigator.of(context).pushNamed(FoodScanView.routeName),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(
                      Icons.center_focus_strong_outlined,
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      shape: CircleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: scheme.primary),
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvatarCubit(),
      child: BlocBuilder<AvatarCubit, AvatarState>(
        builder: (context, state) {
          var avatar = Prefs.getString(Kavatar);
          if (state is ChangeAvatar) avatar = state.avatar;
          return Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [KaccentColor, KprimaryColor, KaccentColor],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: ClipOval(
                child: Image.asset(
                  avatar.isEmpty
                      ? AssetsData.light().images.Avatar_1_png
                      : avatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

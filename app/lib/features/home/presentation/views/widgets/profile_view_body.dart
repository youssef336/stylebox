import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/cubits/avatar/avatar_cubit.dart';
import 'package:stylebox/core/cubits/theme/theme_cubit.dart';
import 'package:stylebox/core/helper_functions/get_user.dart';
import 'package:stylebox/core/services/favorites_store.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart/cart_cubit.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_item.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_logout.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_points_page.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../../../../constant.dart';
import 'profile_viewLanguage_page.dart';
import 'profile_view_avtar_page.dart';

/// Profile: a Bordeaux identity card with three stats, then grouped,
/// iOS-style settings sections and a separate sign-out row.
class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  Future<void> _showLogoutDialog() async {
    await ProfileViewLogout.showLogoutDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        KhorzontalPadding,
        12,
        KhorzontalPadding,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      children: [
        const _ProfileHeaderCard(),
        const SizedBox(height: 26),
        ProfileSection(
          title: locale.profileSectionAccount,
          children: [
            ProfileViewItem(
              headText: locale.profileViewProfileImage,
              icon: Icons.person_outline_rounded,
              onPressed: () =>
                  Navigator.pushNamed(context, ProfileViewAvtarPage.routeName),
            ),
            ProfileViewItem(
              headText: locale.profileViewPoints,
              icon: Icons.workspace_premium_outlined,
              trailingText: '${Prefs.getInt(Kpoints)}',
              onPressed: () =>
                  Navigator.pushNamed(context, ProfileViewPointsPage.routeName),
            ),
          ],
        ),
        const SizedBox(height: 22),
        ProfileSection(
          title: locale.profileSectionPreferences,
          children: [
            ProfileViewItem(
              headText: locale.profileViewLanguage,
              icon: Icons.translate_rounded,
              trailingText: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'العربية'
                  : 'English',
              onPressed: () => Navigator.pushNamed(
                context,
                ProfileViewLanguagePage.routeName,
              ),
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeState) {
                return ProfileViewItem(
                  headText: locale.profileDarkMode,
                  icon: context.read<ThemeCubit>().getThemeIcon(),
                  trailing: Switch.adaptive(
                    value: themeState == ThemeMode.dark,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 22),
        ProfileSection(
          children: [
            ProfileViewItem(
              headText: locale.profileViewLogout,
              icon: Icons.logout_rounded,
              destructive: true,
              onPressed: _showLogoutDialog,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final user = getUser();
    final cartCount = context
        .watch<CartCubit>()
        .cartEntites
        .calculateTotalCount();

    return Container(
      decoration: BoxDecoration(
        gradient: KbrandGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: KprimaryColorDark.withValues(alpha: 0.14),
            blurRadius: 26,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            end: -50,
            top: -60,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: KaccentColor.withValues(alpha: 0.4)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    BlocProvider(
                      create: (_) => AvatarCubit(),
                      child: BlocBuilder<AvatarCubit, AvatarState>(
                        builder: (context, state) {
                          var avatar = Prefs.getString(Kavatar);
                          if (state is ChangeAvatar) avatar = state.avatar;
                          return Container(
                            width: 68,
                            height: 68,
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: KaccentColor,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                avatar.isEmpty
                                    ? AssetsData.light().images.Avatar_1_png
                                    : avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        ProfileViewAvtarPage.routeName,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text(locale.profileEditProfile),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ValueListenableBuilder<Set<String>>(
                    valueListenable: FavoritesStore.ids,
                    builder: (context, favourites, _) => Row(
                      children: [
                        _Stat(
                          value: '${Prefs.getInt(Kpoints)}',
                          label: locale.profileViewPoints,
                        ),
                        const _StatDivider(),
                        _Stat(
                          value: '$cartCount',
                          label: locale.buttonNavigationBarEntityCart,
                        ),
                        const _StatDivider(),
                        _Stat(
                          value: '${favourites.length}',
                          label: locale.profileViewFavourites,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: KaccentColor.withValues(alpha: 0.95),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 30,
    color: Colors.white.withValues(alpha: 0.2),
  );
}

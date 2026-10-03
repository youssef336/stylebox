// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/cubits/theme/theme_cubit.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/core/widgets/build_app_bar.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_item.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_logout.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_points_page.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../../../../constant.dart';
import 'custom_home_appbar.dart';
import 'profile_viewLanguage_page.dart';
import 'profile_view_avtar_page.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KhorzontalPadding),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppbar(
                  context,
                  title: S.of(context)!.homeViewWelcomeAppbar,
                  showBackButton: false,
                  showNotification: false,
                ),
                const CustomHomeAppBar(showNotification: false),
                const SizedBox(height: KTopPadding),
                Text(
                  S.of(context)!.profileViewSettingsTitle,
                  style: AppTextStyles.cairoBold.copyWith(height: 1.70),
                ),
                const SizedBox(height: 16),
                ProfileViewItem(
                  headText: S.of(context)!.profileViewLanguage,
                  icon: Icons.language_outlined,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ProfileViewLanguagePage.routeName,
                    );
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                ),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeState) {
                    return ProfileViewItem(
                      headText:
                          '${S.of(context)!.profileViewTheme} (${context.read<ThemeCubit>().getThemeDisplayName()})',
                      icon: context.read<ThemeCubit>().getThemeIcon(),
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    );
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                ),
                ProfileViewItem(
                  headText: S.of(context)!.profileViewProfileImage,
                  icon: Icons.person_outline_outlined,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ProfileViewAvtarPage.routeName,
                    );
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                ),
                ProfileViewItem(
                  headText: S.of(context)!.profileViewPoints,
                  icon: Icons.point_of_sale,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ProfileViewPointsPage.routeName,
                    );
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                ),
                ProfileViewItem(
                  headText: S.of(context)!.profileViewLogout,
                  icon: Icons.logout_outlined,
                  onPressed: () => _showLogoutDialog(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

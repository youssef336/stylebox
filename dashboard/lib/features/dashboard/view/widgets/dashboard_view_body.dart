// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:stylebox_dashboard/core/widgets/language_toggle_button.dart';
import 'package:stylebox_dashboard/core/widgets/special_logout_button.dart';
import 'package:stylebox_dashboard/features/add_product/presentation/views/add_product_view.dart';
import 'package:stylebox_dashboard/features/auth/presentation/manager/Login_cubit/login_cubit.dart';
import 'package:stylebox_dashboard/features/auth/presentation/manager/Login_cubit/login_state.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/views/manage_data_view.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/views/widgets/add_restaurant_simple.dart';
import 'package:stylebox_dashboard/features/analytics/view/analytics_view.dart';

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'LoginView',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // ── Header ───────────────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 190,
              pinned: true,
              backgroundColor: AppColors.primaryColor,
              actions: const [LanguageToggleButton(), SizedBox(width: 8)],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Stack(
                    children: [
                      PositionedDirectional(
                        top: -60,
                        end: -60,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentColor.withOpacity(0.45),
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        top: -20,
                        end: -20,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.accentColor,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.storefront_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'STYLEBOX',
                                      style: TextStyle(
                                        color: AppColors.accentColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      AppLocalizations.of(context)!.appTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.foodOutletManagement,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.quickActions.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Three action cards (2x2 grid) ──────────────────────
                  Row(
                    children: [
                      // Add Bag Item
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.shopping_bag_outlined,
                          label: AppLocalizations.of(context)!.addBagItemLabel,
                          subtitle: AppLocalizations.of(context)!.scanAddBags,
                          accent: AppColors.primaryColor,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AddProductView.routeName,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Add Restaurant
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.add_business_outlined,
                          label: AppLocalizations.of(
                            context,
                          )!.addRestaurantLabel,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.createNewRestaurant,
                          accent: AppColors.secoundryDark,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AddRestaurantSimple.routeName,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Manage Restaurants
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.manage_search_rounded,
                          label: AppLocalizations.of(
                            context,
                          )!.manageRestaurantsLabel,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.viewEditDelete,
                          accent: AppColors.black,
                          onTap: () => Navigator.pushNamed(
                            context,
                            ManageDataView.routeName,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Analytics Dashboard
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.analytics_outlined,
                          label: AppLocalizations.of(
                            context,
                          )!.analyticsStatsLabel,
                          subtitle: 'View reviews & ratings',
                          accent: AppColors.successColor,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AnalyticsView.routeName,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Logout ──────────────────────────────────────────────
                  SpecialLogoutButton(
                    onPressed: () {
                      context.read<LoginCubit>().logout();
                    },
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Card ───────────────────────────────────────────────────────────────
/// White tile with a tinted icon medallion and a short accent rule, so the
/// grid reads like a boutique catalogue rather than four loud gradients.
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppColors.radiusCard),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        child: Ink(
          height: 148,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accent, size: 22),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 18, height: 2, color: accent),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

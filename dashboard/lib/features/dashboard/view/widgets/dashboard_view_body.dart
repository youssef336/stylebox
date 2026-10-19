import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox_dashboard/core/errors/failures.dart';
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';
import 'package:stylebox_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:stylebox_dashboard/core/services/get_it_services.dart';
import 'package:stylebox_dashboard/core/services/user_session.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:stylebox_dashboard/core/widgets/language_toggle_button.dart';
import 'package:stylebox_dashboard/core/widgets/special_logout_button.dart';
import 'package:stylebox_dashboard/core/widgets/store_visuals.dart';
import 'package:stylebox_dashboard/features/add_product/domain/entities/add_product_input_entity.dart';
import 'package:stylebox_dashboard/features/add_product/presentation/views/add_product_view.dart';
import 'package:stylebox_dashboard/features/auth/presentation/manager/Login_cubit/login_cubit.dart';
import 'package:stylebox_dashboard/features/auth/presentation/manager/Login_cubit/login_state.dart';
import 'package:stylebox_dashboard/features/manage_data/domain/entities/restaurant_entity.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/cubit/restaurant_cubit.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/views/manage_data_view.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/views/widgets/add_restaurant_simple.dart';
import 'package:stylebox_dashboard/features/analytics/view/analytics_view.dart';

/// Store-owner home laid out as a dashboard: greeting header, an overview
/// card with live numbers, a 2x2 quick-actions grid and the recent stores.
class DashboardViewBody extends StatefulWidget {
  const DashboardViewBody({super.key});

  @override
  State<DashboardViewBody> createState() => _DashboardViewBodyState();
}

class _DashboardViewBodyState extends State<DashboardViewBody> {
  late final Future<Either<Failure, List<AddProductInputEntity>>> _boxes =
      getIt<ProductsRepo>().getProducts(
        userEmail: UserSession.instance.isLoggedIn
            ? UserSession.instance.currentEmail
            : null,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        body: SafeArea(
          child: BlocBuilder<RestaurantCubit, RestaurantState>(
            builder: (context, state) {
              final stores = switch (state) {
                RestaurantLoaded s => s.restaurants,
                RestaurantOperationLoading s => s.restaurants,
                RestaurantOperationSuccess s => s.restaurants,
                RestaurantError s => s.restaurants,
                _ => const <RestaurantEntity>[],
              };

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  const _Header(),
                  const SizedBox(height: 22),
                  FutureBuilder(
                    future: _boxes,
                    builder: (context, snapshot) {
                      final boxes =
                          snapshot.data?.fold(
                            (_) => const <AddProductInputEntity>[],
                            (list) => list,
                          ) ??
                          const <AddProductInputEntity>[];
                      return _OverviewCard(stores: stores, boxes: boxes);
                    },
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(l10n.quickActions),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.55,
                    children: [
                      _ActionTile(
                        icon: Icons.center_focus_strong_outlined,
                        label: l10n.addBagItem,
                        subtitle: l10n.scanAddBags,
                        highlighted: true,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AddProductView.routeName,
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.add_business_outlined,
                        label: l10n.addRestaurant,
                        subtitle: l10n.createNewRestaurant,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AddRestaurantSimple.routeName,
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.storefront_outlined,
                        label: l10n.manageRestaurants,
                        subtitle: l10n.viewEditDelete,
                        onTap: () => Navigator.pushNamed(
                          context,
                          ManageDataView.routeName,
                        ),
                      ),
                      _ActionTile(
                        icon: Icons.insights_outlined,
                        label: l10n.analyticsStats,
                        subtitle: l10n.dashFeatureReviews,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AnalyticsView.routeName,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(child: _SectionTitle(l10n.dashYourStores)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          ManageDataView.routeName,
                        ),
                        child: Text(l10n.dashSeeAll),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (state is RestaurantLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (stores.isEmpty)
                    _EmptyStores(
                      onAdd: () => Navigator.pushNamed(
                        context,
                        AddRestaurantSimple.routeName,
                      ),
                    )
                  else
                    ...stores
                        .take(4)
                        .map(
                          (store) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _StoreRow(
                              store: store,
                              onTap: () => Navigator.pushNamed(
                                context,
                                ManageDataView.routeName,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),
                  SpecialLogoutButton(
                    onPressed: () => context.read<LoginCubit>().logout(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final email = UserSession.instance.isLoggedIn
        ? UserSession.instance.currentEmail
        : l10n.dashStoreOwner;

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: AppColors.secondaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.dashGreeting,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const LanguageToggleButton(),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2,
      color: AppColors.black,
    ),
  );
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.stores, required this.boxes});

  final List<RestaurantEntity> stores;
  final List<AddProductInputEntity> boxes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final liveBoxes = boxes.fold<int>(0, (sum, b) => sum + b.bagsLeft);
    final open = stores.where((s) => s.isOpend).length;
    final low = boxes.where((b) => b.bagsLeft > 0 && b.bagsLeft <= 3).length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(26),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            end: -40,
            top: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentColor.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dashOverview.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$liveBoxes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        l10n.dashBoxesLive,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _MiniStat(
                      icon: Icons.storefront_outlined,
                      value: '${stores.length}',
                      label: l10n.totalRestaurants,
                    ),
                    const SizedBox(width: 8),
                    _MiniStat(
                      icon: Icons.schedule_rounded,
                      value: '$open',
                      label: l10n.dashActiveStores,
                    ),
                    const SizedBox(width: 8),
                    _MiniStat(
                      icon: Icons.warning_amber_rounded,
                      value: '$low',
                      label: l10n.lowStock,
                      warn: low > 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    this.warn = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: warn ? AppColors.warningColor : AppColors.accentColor,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final fg = highlighted ? Colors.white : AppColors.black;
    return Material(
      color: highlighted ? AppColors.primaryColor : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: highlighted
            ? BorderSide.none
            : const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: highlighted
                        ? AppColors.secondaryContainer
                        : AppColors.primaryColor,
                  ),
                  const Spacer(),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.north_west_rounded
                        : Icons.north_east_rounded,
                    size: 16,
                    color: fg.withValues(alpha: 0.5),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fg,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fg.withValues(alpha: 0.65),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreRow extends StatelessWidget {
  const _StoreRow({required this.store, required this.onTap});

  final RestaurantEntity store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final image = store.RestaurantimageUrl;
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              StoreThumbnail(imageUrl: image, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      store.branchLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(
                label: store.isOpend ? l10n.open : l10n.closed,
                positive: store.isOpend,
              ),
              const SizedBox(width: 4),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStores extends StatelessWidget {
  const _EmptyStores({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.store_outlined, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(l10n.noRestaurantsYet)),
          TextButton(onPressed: onAdd, child: Text(l10n.addRestaurant)),
        ],
      ),
    );
  }
}

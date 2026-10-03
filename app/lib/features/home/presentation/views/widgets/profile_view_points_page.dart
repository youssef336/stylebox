// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_points_discount_tier_card.dart';
import 'package:stylebox/generated/l10n.dart';

class ProfileViewPointsPage extends StatefulWidget {
  const ProfileViewPointsPage({super.key});
  static const routeName = '/profile/points';

  @override
  State<ProfileViewPointsPage> createState() => _ProfileViewPointsPageState();
}

class _ProfileViewPointsPageState extends State<ProfileViewPointsPage> {
  late final ValueNotifier<int> _pointsNotifier;

  @override
  void initState() {
    super.initState();
    _pointsNotifier = ValueNotifier<int>(Prefs.getInt(Kpoints));
  }

  // void _addPoints(int amount) {
  //   final newPoints = _pointsNotifier.value + amount;
  //   Prefs.setInt(Kpoints, newPoints);
  //   _pointsNotifier.value = newPoints;
  // }

  @override
  void dispose() {
    _pointsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final discountTiers = [
      {'points': 100, 'discount': 10},
      {'points': 250, 'discount': 25},
      {'points': 500, 'discount': 40},
      {'points': 750, 'discount': 55},
      {'points': 1000, 'discount': 70},
      {'points': 1500, 'discount': 85},
      {'points': 2000, 'discount': 100},
    ];

    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _pointsNotifier,
        builder: (context, points, _) {
          return Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 8),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: KhorzontalPadding,
                ),
                child: SizedBox(
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? KdarkModeCardColor
                                    : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                      isDark ? 0.22 : 0.08,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: IconTheme(
                                  data: IconThemeData(
                                    size: 20,
                                    color: isDark
                                        ? KdarkModeTextColor
                                        : KlightModeTextColor,
                                  ),
                                  child: const BackButtonIcon(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 52),
                        child: Text(
                          S.of(context)!.profileViewPoints,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.cairoBold19.copyWith(
                            color: isDark ? KdarkModeTextColor : KprimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Points Display Card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: KhorzontalPadding,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [KprimaryColor, KprimaryColorDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: KprimaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        S.of(context)!.pointsPageYourPoints,
                        style: AppTextStyles.bodyBaseRegular.copyWith(
                          color: KprimaryColorLight,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$points',
                            style: AppTextStyles.heading5Bold.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              S.of(context)!.pointsPagePts,
                              style: AppTextStyles.bodyBaseSemibold.copyWith(
                                color: KprimaryColorLight,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: KhorzontalPadding,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S.of(context)!.pointsPageRewardsTitle,
                    style: AppTextStyles.cairoBold19.copyWith(
                      color: isDark ? KdarkModeTextColor : KprimaryColor,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     IntrinsicWidth(
              //       stepWidth: 20,
              //       child: CustomButtom(
              //         text: S.of(context)!.pointsPageAdd,
              //         onPressed: () {
              //           _addPoints(50);
              //         },
              //       ),
              //     ),
              //     IntrinsicWidth(
              //       stepWidth: 20,
              //       child: CustomButtom(
              //         text: S.of(context)!.pointsPageDelete,
              //         onPressed: () {
              //           _addPoints(
              //             -Prefs.getInt(Kpoints) > -50
              //                 ? -50
              //                 : -Prefs.getInt(Kpoints),
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16),
              // Discount Tiers List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: KhorzontalPadding,
                  ),
                  itemCount: discountTiers.length,
                  itemBuilder: (context, index) {
                    final tier = discountTiers[index];
                    final requiredPoints = tier['points'] as int;
                    final discountPercent = tier['discount'] as int;
                    final isUnlocked = points >= requiredPoints;
                    final progress = (points / requiredPoints).clamp(0.0, 1.0);

                    return DiscountTierCard(
                      requiredPoints: requiredPoints,
                      discountPercent: discountPercent,
                      isUnlocked: isUnlocked,
                      progress: progress,
                      currentPoints: points,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

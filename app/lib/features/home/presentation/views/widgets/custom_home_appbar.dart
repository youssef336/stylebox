// ignore_for_file: camel_case_types
// ignore_for_file: unchecked_use_of_nullable_value
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/cubits/avatar/avatar_cubit.dart';
import 'package:stylebox/core/helper_functions/get_user.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/features/home/presentation/views/widgets/custom_app_bar_points.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../../../constant.dart';
import '../../../../../core/widgets/notification_widget.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key, this.showNotification = true});
  final bool showNotification;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvatarCubit(),
      child: CustomHomeAppBar_body(showNotification: showNotification),
    );
  }
}

class CustomHomeAppBar_body extends StatelessWidget {
  const CustomHomeAppBar_body({super.key, required this.showNotification});

  final bool showNotification;

  @override
  Widget build(BuildContext context) {
    String avatar = Prefs.getString(Kavatar);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Left side: User Avatar and Info
        Expanded(
          child: Row(
            children: [
              // Avatar with circular clip, border, and shadow
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: KaccentColor.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BlocBuilder<AvatarCubit, AvatarState>(
                    builder: (context, state) {
                      if (state is ChangeAvatar) {
                        avatar = state.avatar;
                      }
                      return Image.asset(
                        avatar.isEmpty
                            ? AssetsData.light().images.Avatar_1_png
                            : avatar,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User greeting and name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context)!.homeViewWelcomeAppbar,
                      style: AppTextStyles.cairoRegular.copyWith(
                        color: isDark ? KdarkModeTextSecondary : KlightModeTextSecondary,
                        fontSize: 12,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      getUser().name,
                      style: AppTextStyles.cairoBold.copyWith(
                        color: isDark ? KdarkModeTextColor : KlightModeTextColor,
                        fontSize: 16,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Right side: Points and Notification widgets
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomappBarPoints(),
            const SizedBox(width: 8),
            Visibility(
              visible: showNotification,
              child: const NotificationWidget(),
            ),
          ],
        ),
      ],
    );
  }
}

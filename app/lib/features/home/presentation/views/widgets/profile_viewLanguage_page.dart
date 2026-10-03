// ignore_for_file: file_names, camel_case_types, deprecated_member_use

// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/cubits/locale/locale_cubit.dart';
import 'package:stylebox/core/widgets/custom_divider.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../../../core/utils/text_styles.dart';
import '../../../../../core/widgets/build_app_bar.dart';

class ProfileViewLanguagePage extends StatefulWidget {
  const ProfileViewLanguagePage({super.key});
  static const String routeName = '/ProfileViewLanguage';

  @override
  State<ProfileViewLanguagePage> createState() =>
      _ProfileViewLanguagePageState();
}

class _ProfileViewLanguagePageState extends State<ProfileViewLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          children: [
            buildAppbar(
              context,
              title: S.of(context)!.profileViewLanguage,
              showNotification: false,
            ),
            Language_container(
              text: S.of(context)!.profileViewLanguageValueItem,
              onPressed: () {
                BlocProvider.of<LocaleCubit>(context).changeLocaleToArabic();
              },
            ),
            const CustomDivider(),
            Language_container(
              text: S.of(context)!.profileViewLanguageValueItem2,
              onPressed: () {
                BlocProvider.of<LocaleCubit>(context).changeLocaleToEnglish();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Language_container extends StatelessWidget {
  const Language_container({super.key, required this.text, this.onPressed});
  final String text;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? KdarkModeCardColor : KlightModeCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? KdarkModeTextSecondary.withOpacity(0.2)
                : KlightModeTextSecondary.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyles.cairoBold19.copyWith(
                        color: isDark
                            ? KdarkModeTextColor
                            : KlightModeTextColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDark
                        ? KdarkModeTextSecondary
                        : KlightModeTextSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

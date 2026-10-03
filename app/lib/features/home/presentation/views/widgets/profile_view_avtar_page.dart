// ignore_for_file: file_names, camel_case_types

// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/core/widgets/custom_divider.dart';

import '../../../../../core/cubits/avatar/avatar_cubit.dart';

import '../../../../../core/widgets/build_app_bar.dart';
import '../../../../../generated/l10n.dart';

class ProfileViewAvtarPage extends StatefulWidget {
  const ProfileViewAvtarPage({super.key});
  static const String routeName = '/ProfileViewAvtarPage';

  @override
  State<ProfileViewAvtarPage> createState() => _ProfileViewAvtarPageState();
}

class _ProfileViewAvtarPageState extends State<ProfileViewAvtarPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvatarCubit(),
      child: const ProfileViewAvtarBody(),
    );
  }
}

class ProfileViewAvtarBody extends StatelessWidget {
  const ProfileViewAvtarBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          children: [
            buildAppbar(
              context,
              title: S.of(context)!.profileViewProfileImage,
              showNotification: false,
            ),
            GestureDetector(
              onTap: () {
                context.read<AvatarCubit>().changeAvatar(
                  AssetsData.light().images.Avatar_1_png,
                );
                Phoenix.rebirth(context);
              },
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                height: 100,
                padding: const EdgeInsets.all(8),
                child: Image.asset(AssetsData.light().images.Avatar_1_png),
              ),
            ),
            const CustomDivider(),
            GestureDetector(
              onTap: () {
                context.read<AvatarCubit>().changeAvatar(
                  AssetsData.light().images.Avatar_2_png,
                );
                Phoenix.rebirth(context);
              },
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                height: 100,
                padding: const EdgeInsets.all(8),
                child: Image.asset(AssetsData.light().images.Avatar_2_png),
              ),
            ),
            const CustomDivider(),
            GestureDetector(
              onTap: () {
                context.read<AvatarCubit>().changeAvatar(
                  AssetsData.light().images.Avatar_3_png,
                );
                Phoenix.rebirth(context);
              },
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(8),
                child: Image.asset(AssetsData.light().images.Avatar_3_png),
              ),
            ),
            const CustomDivider(),
          ],
        ),
      ),
    );
  }
}

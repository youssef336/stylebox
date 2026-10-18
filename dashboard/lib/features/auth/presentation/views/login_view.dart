// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox_dashboard/core/services/get_it_services.dart';
import 'package:stylebox_dashboard/features/auth/domain/repo/login_repo.dart';
import 'package:stylebox_dashboard/features/auth/presentation/manager/Login_cubit/login_cubit.dart';
import 'package:stylebox_dashboard/features/auth/presentation/views/widgets/login_view_body_bloc_consumer.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const routeName = 'LoginView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentColor.withOpacity(0.35),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer.withOpacity(0.7),
                ),
              ),
            ),
            // Login content
            Center(
              child: BlocProvider(
                create: (context) => LoginCubit(getIt.get<LoginRepo>()),
                child: const LoginViewBodyBlocConsumer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

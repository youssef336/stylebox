// ignore_for_file: file_names

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
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => LoginCubit(getIt.get<LoginRepo>()),
        child: const LoginViewBodyBlocConsumer(),
      ),
    );
  }
}

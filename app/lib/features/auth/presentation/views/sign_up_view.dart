// ignore_for_file: unused_import

// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/services/get_it_service.dart';
import 'package:stylebox/core/widgets/custom_app_bar.dart';
import 'package:stylebox/features/auth/domains/repos/auth_repo.dart';
import 'package:stylebox/features/auth/presentation/manager/cubits/sign_up_cubit/signup_cubit.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/sign_up_view_body_bloc_consumer.dart';
import 'package:stylebox/generated/l10n.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const String routeName = '/sign-up';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        getIt<AuthRepo>(), // Use getIt to provide the AuthRepo instance
      ),
      child: Scaffold(
        appBar: Custom_app_bar(
          context,
          title: S.of(context)!.onSignupSignup,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: const SignupViewBodyBlocConsumer(),
      ),
    );
  }
}

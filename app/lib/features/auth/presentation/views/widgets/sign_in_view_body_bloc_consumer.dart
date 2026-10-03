import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/helper_functions/build_error_bar.dart';
import 'package:stylebox/features/auth/presentation/manager/cubits/sign_in_cubit/sign_in_cubit.dart';

import 'Sign_in_view_body.dart';
import '../../../../../core/widgets/custom_modal_progress_hub.dart';

class SigninViewBodyBlocConsumer extends StatelessWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is SignInError) {
          showErrorBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is SignInLoading ? true : false,
          child: const SigninViewBody(),
        );
      },
    );
  }
}

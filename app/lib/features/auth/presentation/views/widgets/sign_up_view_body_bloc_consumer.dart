import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stylebox/core/helper_functions/build_error_bar.dart';
import 'package:stylebox/features/auth/presentation/manager/cubits/sign_up_cubit/signup_cubit.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/sign_up_view_body.dart';

import '../../../../../core/widgets/custom_modal_progress_hub.dart';

class SignupViewBodyBlocConsumer extends StatelessWidget {
  const SignupViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupCubitState>(
      listener: (context, state) {
        if (state is SignupCubitSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is SignupCubitError) {
          showErrorBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is SignupCubitLoading ? true : false,
          child: const SignUpViewBody(),
        );
      },
    );
  }
}

// ignore_for_file: unchecked_use_of_nullable_value, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/helper_functions/build_error_bar.dart';
import 'package:stylebox/core/services/build_passward_state.dart';
import 'package:stylebox/core/widgets/custom_buttom.dart';
import 'package:stylebox/core/widgets/custom_text_feild.dart';
import 'package:stylebox/features/auth/presentation/manager/cubits/sign_up_cubit/signup_cubit.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/have_an_account_widget.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/terms_and_condations.dart';
import 'package:stylebox/generated/l10n.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  @override
  Widget build(BuildContext context) {
    return SignupViewBody(context);
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email, password, name;
  late bool isTermsAccepted = false;
  SingleChildScrollView SignupViewBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: KhorzontalPadding),
        child: Form(
          key: formKey,
          autovalidateMode: autoValidateMode,
          child: Column(
            children: [
              const SizedBox(height: 24),
              CustomTextFormFeild(
                onSaved: (value) {
                  name = value!;
                },
                hintText: S.of(context)!.onSignupName,
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              CustomTextFormFeild(
                onSaved: (value) {
                  email = value!;
                },
                hintText: S.of(context)!.onSignupEmail,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              BiludPasswordState(
                onSaved: (value) {
                  password = value!;
                },
              ),
              const SizedBox(height: 16),
              TermsAndConditionsWidget(
                onChanged: (value) {
                  isTermsAccepted = value;
                },
              ),
              const SizedBox(height: 30),
              CustomButtom(
                text: S.of(context)!.onSignupCreateNewAccount,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (isTermsAccepted) {
                      // Call the signup method from the SignupCubit
                      context
                          .read<SignupCubit>()
                          .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                            name: name,
                          );
                    } else {
                      showErrorBar(
                        context,
                        S.of(context)!.onSignupTermsandConditionsErrorBar,
                      );
                    }
                    // Perform signup logic here
                  } else {
                    setState(() {
                      autoValidateMode = AutovalidateMode.always;
                    });
                  }
                },
              ),
              const SizedBox(height: 26),
              HaveAnAcoountWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}

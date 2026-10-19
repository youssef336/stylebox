import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/helper_functions/build_error_bar.dart';
import 'package:stylebox/core/services/build_passward_state.dart';
import 'package:stylebox/core/widgets/custom_buttom.dart';
import 'package:stylebox/core/widgets/custom_text_feild.dart';
import 'package:stylebox/features/auth/presentation/manager/cubits/sign_up_cubit/signup_cubit.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/auth_hero_scaffold.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/terms_and_condations.dart';
import 'package:stylebox/generated/l10n.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email, password, name;
  late bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;

    return AuthHeroLayout(
      title: locale.authSignupHeroTitle,
      subtitle: locale.authSignupHeroSubtitle,
      isLogin: false,
      onBack: () => Navigator.pop(context),
      onSwitch: () => Navigator.pop(context),
      child: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          children: [
            CustomTextFormFeild(
              onSaved: (value) {
                name = value!;
              },
              hintText: locale.onSignupName,
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: 14),
            CustomTextFormFeild(
              onSaved: (value) {
                email = value!;
              },
              hintText: locale.onSignupEmail,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            BiludPasswordState(
              onSaved: (value) {
                password = value!;
              },
            ),
            const SizedBox(height: 14),
            TermsAndConditionsWidget(
              onChanged: (value) {
                isTermsAccepted = value;
              },
            ),
            const SizedBox(height: 22),
            CustomButtom(
              text: locale.onSignupCreateNewAccount,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  if (isTermsAccepted) {
                    context.read<SignupCubit>().createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                      name: name,
                    );
                  } else {
                    showErrorBar(
                      context,
                      locale.onSignupTermsandConditionsErrorBar,
                    );
                  }
                } else {
                  setState(() {
                    autoValidateMode = AutovalidateMode.always;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

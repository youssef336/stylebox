// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/core/widgets/custom_buttom.dart';
import 'package:stylebox/core/widgets/custom_text_feild.dart';
import 'package:stylebox/features/auth/presentation/views/sign_up_view.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/auth_hero_scaffold.dart';
import 'package:stylebox/generated/l10n.dart';
import '../../../../../core/services/build_passward_state.dart';
import '../../manager/cubits/sign_in_cubit/sign_in_cubit.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  String? email, password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return AuthHeroLayout(
      title: locale.authHeroTitle,
      subtitle: locale.authHeroSubtitle,
      isLogin: true,
      onSwitch: () => Navigator.pushNamed(context, SignUpView.routeName),
      child: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          children: [
            CustomTextFormFeild(
              onSaved: (value) {
                email = value!;
              },
              hintText: locale.onLoginEmail,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            BiludPasswordState(
              onSaved: (value) {
                password = value!;
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                locale.onLoginForgotPassword,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 22),
            CustomButtom(
              text: locale.onLoginLogin,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  context.read<SignInCubit>().signInWithEmailAndPassword(
                    email: email!,
                    password: password!,
                  );
                } else {
                  setState(() {
                    autoValidateMode = AutovalidateMode.always;
                  });
                }
              },
            ),
            const SizedBox(height: 26),
            SocialIconRow(
              buttons: [
                (
                  svg: AssetsData.light().images.google_icon_svg,
                  icon: null,
                  onTap: () => context.read<SignInCubit>().signInWithGoogle(),
                ),
                if (defaultTargetPlatform == TargetPlatform.iOS)
                  (svg: null, icon: Icons.apple, onTap: () {}),
                (
                  svg: AssetsData.light().images.facebook_icon_svg,
                  icon: null,
                  onTap: () => context.read<SignInCubit>().signInWithFacebook(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

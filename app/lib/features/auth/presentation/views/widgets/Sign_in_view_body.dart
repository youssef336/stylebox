// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:stylebox/core/utils/assets.dart';

import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/core/widgets/custom_buttom.dart';
import 'package:stylebox/core/widgets/custom_text_feild.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/dont_have_an_acoount_widget.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/or_divider.dart';
import 'package:stylebox/features/auth/presentation/views/widgets/social_text_buttom.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: KhorzontalPadding),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: autoValidateMode,
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextFormFeild(
                  onSaved: (value) {
                    email = value!;
                  },
                  hintText: S.of(context)!.onLoginEmail,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                BiludPasswordState(
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      S.of(context)!.onLoginForgotPassword,
                      style: AppTextStyles.bodySmallSemibold.copyWith(
                        color: isDark
                            ? KdarkModeTextSecondary
                            : KlightModeTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 33),
                CustomButtom(
                  text: S.of(context)!.onLoginLogin,
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
                const SizedBox(height: 33),
                DontHaveAnAcoountWidget(context),
                const SizedBox(height: 33),
                const OrDivider(),
                const SizedBox(height: 16),

                SocialTextButtom(
                  image: AssetsData.light().images.google_icon_svg,
                  text: S.of(context)!.onLoginLoginWithGoogle,
                  onPressed: () {
                    context.read<SignInCubit>().signInWithGoogle();
                  },
                ),
                const SizedBox(height: 16),
                defaultTargetPlatform == TargetPlatform.iOS
                    ? Column(
                        children: [
                          SocialTextButtom(
                            image: AssetsData.light().images.google_icon_svg,
                            text: S.of(context)!.onLoginLoginWithApple,
                            onPressed: () {},
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    : const SizedBox(),

                SocialTextButtom(
                  image: AssetsData.light().images.facebook_icon_svg,
                  text: S.of(context)!.onLoginLoginWithFacebook,
                  onPressed: () {
                    context.read<SignInCubit>().signInWithFacebook();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

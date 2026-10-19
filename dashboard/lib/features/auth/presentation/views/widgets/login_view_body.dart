// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox_dashboard/core/widgets/custom_text_field.dart';
import 'package:stylebox_dashboard/core/widgets/special_login_button.dart';
import 'package:stylebox_dashboard/features/auth/presentation/manager/Login_cubit/login_cubit.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String email, password;
  bool _isLoading = false;

  // Store-owner account (Firebase Auth). Leave the password empty to
  // auto-fill only the email.
  final List<MapEntry<String, String>> _demoAccounts = const [
    MapEntry('logina@gmail.com', ''),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _LoginHero(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeBack,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.signInToContinueDashboard,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildDemoCredentialsCard(),
                  const SizedBox(height: 18),
                  _buildEmailField(),
                  const SizedBox(height: 14),
                  _buildPasswordField(),
                  const SizedBox(height: 26),
                  _buildLoginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compact "store account" chips that auto-fill the email.
  Widget _buildDemoCredentialsCard() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final account in _demoAccounts)
          ActionChip(
            avatar: const Icon(
              Icons.storefront_outlined,
              size: 18,
              color: AppColors.primaryColor,
            ),
            label: Text(account.key),
            labelStyle: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            backgroundColor: AppColors.primaryContainer,
            side: BorderSide.none,
            shape: const StadiumBorder(),
            onPressed: () => _fillDemoAccount(account.key, account.value),
          ),
      ],
    );
  }

  void _fillDemoAccount(String email, String password) {
    _emailController.text = email;
    if (password.isNotEmpty) _passwordController.text = password;
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: _emailController,
      hintText: "Email Address",
      textInputType: TextInputType.emailAddress,
      obscureText: false,
      suffixIcon: const Icon(
        Icons.email_outlined,
        color: AppColors.primaryColor,
        size: 20,
      ),
      maxLines: 1,
      onSaved: (p0) {
        email = p0 ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomTextFormField(
      controller: _passwordController,
      hintText: "Password",
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      suffixIcon: const Icon(
        Icons.lock_outline,
        color: AppColors.primaryColor,
        size: 20,
      ),
      maxLines: 1,
      onSaved: (p0) {
        password = p0 ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SpecialLoginButton(
      text: 'Sign In',
      isLoading: _isLoading,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          setState(() {
            _isLoading = true;
          });
          context.read<LoginCubit>().login(email, password);
          // Reset loading state after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
        } else {
          setState(() {
            autovalidateMode = AutovalidateMode.always;
          });
        }
      },
    );
  }
}

/// Espresso top half of the split login: wordmark, role pill, promise and
/// three feature lines.
class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.paddingOf(context).top;

    Widget feature(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.accentColor),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(24, top + 20, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: -90,
            top: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentColor.withOpacity(0.3),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'STYLEBOX',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.accentColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.dashStoreOwner,
                      style: const TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Text(
                l10n.dashLoginHeroTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.dashLoginHeroSubtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              feature(Icons.center_focus_strong_outlined, l10n.dashFeatureScan),
              feature(Icons.inventory_2_outlined, l10n.dashFeatureStock),
              feature(Icons.star_outline_rounded, l10n.dashFeatureReviews),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 24),

              _buildDemoCredentialsCard(),
              const SizedBox(height: 24),

              // Email Field
              _buildEmailField(),
              const SizedBox(height: 24),

              // Password Field
              _buildPasswordField(),
              const SizedBox(height: 32),

              // Special Login Button
              _buildLoginButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'STYLEBOX',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 6.5,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 36, height: 1.5, color: AppColors.accentColor),
        const SizedBox(height: 28),
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sign in to continue to your dashboard',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDemoCredentialsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppColors.radiusField),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Store Account',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          ..._demoAccounts.map((account) {
            final accountEmail = account.key;
            final accountPassword = account.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _fillDemoAccount(accountEmail, accountPassword),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email: $accountEmail',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        if (accountPassword.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Password: $accountPassword',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 2),
          const Text(
            'Tap any account to auto-fill credentials',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
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

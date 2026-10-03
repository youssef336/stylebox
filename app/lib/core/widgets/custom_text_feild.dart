import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/generated/l10n.dart';

class CustomTextFormFeild extends StatelessWidget {
  const CustomTextFormFeild({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.obscureText = false,
    this.controller,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
  });
  final String hintText;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onSaved: onSaved,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context)!.onSignupTextFeils;
        }
        return null;
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: AppTextStyles.bodysmallBold.copyWith(
          color: Theme.of(context).hintColor,
        ),

        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,

        border: bulidBoarder(context),
        enabledBorder: bulidBoarder(context),
        focusedBorder: bulidBoarder(context).copyWith(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.6,
          ),
        ),
      ),

      onChanged: onChanged,
    );
  }

  OutlineInputBorder bulidBoarder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.0),
    );
  }
}

class CustomTextFormFeildforCopon extends StatelessWidget {
  const CustomTextFormFeildforCopon({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,

    this.controller,
    this.obscureText = false,
    required this.textInputAction,
  });
  final String hintText;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final Widget? suffixIcon;

  final bool obscureText;

  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,

      textInputAction: textInputAction,
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: AppTextStyles.bodysmallBold.copyWith(
          color: Theme.of(context).hintColor,
        ),

        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,

        border: bulidBoarder(context),
        enabledBorder: bulidBoarder(context),
        focusedBorder: bulidBoarder(context).copyWith(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.6,
          ),
        ),
      ),

      onChanged: (value) {
        // Handle text input changes here
      },
    );
  }

  OutlineInputBorder bulidBoarder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1.0),
    );
  }
}

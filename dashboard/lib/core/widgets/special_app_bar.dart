// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';

class SpecialAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SpecialAppBar({
    super.key,
    required this.title,
    this.backgroundColor = AppColors.primaryColor,
    this.showBackButton = false,
    this.actions,
    this.elevation = 2,
    this.onBackPressed,
    this.useGradient = false,
  });

  final String title;
  final Color backgroundColor;
  final bool showBackButton;
  final List<Widget>? actions;
  final double elevation;
  final VoidCallback? onBackPressed;
  final bool useGradient;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: useGradient ? AppColors.primaryGradient : null,
        color: !useGradient ? backgroundColor : null,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.2),
            blurRadius: elevation,
            offset: Offset(0, elevation * 0.5),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : null,
        actions: actions,
      ),
    );
  }
}

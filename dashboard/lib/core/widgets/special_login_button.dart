// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';

class SpecialLoginButton extends StatefulWidget {
  const SpecialLoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  @override
  State<SpecialLoginButton> createState() => _SpecialLoginButtonState();
}

class _SpecialLoginButtonState extends State<SpecialLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePressed() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: AppColors.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : _handlePressed,
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: widget.isLoading
                  ? _buildLoadingWidget()
                  : _buildButtonContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return RotationTransition(
      turns: _rotateAnimation,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withOpacity(0.8),
          ),
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
      ],
    );
  }
}

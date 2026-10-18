import 'package:flutter/material.dart';

import 'package:stylebox/constant.dart';

class ProfileViewItem extends StatelessWidget {
  const ProfileViewItem({
    super.key,
    required this.headText,
    required this.icon,
    required this.onPressed,
  });
  final String headText;
  final IconData icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(KradiusField),
        child: InkWell(
          borderRadius: BorderRadius.circular(KradiusField),
          onTap: onPressed,
          child: Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KradiusField),
              boxShadow: [
                BoxShadow(
                  color: KprimaryColorDark.withValues(alpha: isDark ? 0 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: scheme.primary, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    headText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? KdarkModeTextColor : KlightModeTextColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark
                      ? KdarkModeTextSecondary
                      : KlightModeTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

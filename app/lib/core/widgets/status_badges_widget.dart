// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/generated/l10n.dart';

/// Small glassy pills shown on top of the store cover.
class StatusBadgesWidget extends StatelessWidget {
  final bool isAvailable;
  final bool isOpenNow;

  const StatusBadgesWidget({
    super.key,
    required this.isAvailable,
    required this.isOpenNow,
  });

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _badge(
          text: isAvailable
              ? locale.statusBadgeAvailable
              : locale.statusBadgeUnavailable,
          dot: isAvailable ? const Color(0xFF22C55E) : KaccentColor,
        ),
        const SizedBox(width: 8),
        _badge(
          text: isOpenNow ? locale.statusBadgeNow : locale.statusBadgeClosed,
          dot: isOpenNow ? KprimaryColor : KdisabledColor,
        ),
      ],
    );
  }

  Widget _badge({required String text, required Color dot}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: KlightModeTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

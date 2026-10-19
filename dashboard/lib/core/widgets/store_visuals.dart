import 'package:flutter/material.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';

/// Rounded store picture with a branded fallback.
class StoreThumbnail extends StatelessWidget {
  const StoreThumbnail({super.key, required this.imageUrl, this.size = 56});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Icon(
        Icons.storefront_rounded,
        color: AppColors.secondaryContainer,
        size: size * 0.45,
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl != null && imageUrl!.startsWith('http')
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              )
            : fallback,
      ),
    );
  }
}

/// Small green / grey status capsule.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.positive});

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.successColor : AppColors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

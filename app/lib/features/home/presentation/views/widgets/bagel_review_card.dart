// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/entities/review_entity.dart';
import 'package:stylebox/generated/l10n.dart';

class BagelReviewCard extends StatelessWidget {
  const BagelReviewCard({
    super.key,
    required this.review,
    required this.currentUserId,
    required this.onEditReview,
    required this.onDeleteReview,
  });

  final ReviewEntity review;
  final String currentUserId;
  final Function(ReviewEntity) onEditReview;
  final Function(String, S) onDeleteReview;

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color _cardColor(BuildContext context) {
    return _isDark(context) ? KdarkModeCardColor : KlightModeCardColor;
  }

  Color _primaryTextColor(BuildContext context) {
    return _isDark(context) ? KdarkModeTextColor : KlightModeTextColor;
  }

  Color _secondaryTextColor(BuildContext context) {
    return _isDark(context) ? KdarkModeTextSecondary : KlightModeTextSecondary;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return (parts[0].isNotEmpty ? parts[0][0] : '') +
        (parts[1].isNotEmpty ? parts[1][0] : '');
  }

  Color _getRatingColor(num rating) {
    if (rating >= 4) return Colors.green;
    if (rating >= 3) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final ratingColor = _getRatingColor(review.rating);
    final isCurrentUserReview = review.userId == currentUserId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KdividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: KaccentColor.withOpacity(0.14),
                  border: Border.all(color: KaccentColor.withOpacity(0.25)),
                ),
                child: Center(
                  child: Text(
                    _getInitials(review.name),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: KaccentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _primaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      review.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: _secondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ratingColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: ratingColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ratingColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review text
          Text(
            review.review,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: _primaryTextColor(context),
            ),
          ),
          // Edit/Delete buttons if current user's review
          if (isCurrentUserReview) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onEditReview(review),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: KaccentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: KaccentColor.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color: KaccentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            locale.reviewComposerEditButton,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: KaccentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onDeleteReview(review.id, locale),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete_rounded,
                            size: 14,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            locale.reviewComposerDeleteButton,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

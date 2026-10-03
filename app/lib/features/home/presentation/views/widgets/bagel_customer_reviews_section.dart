import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/entities/review_entity.dart';
import 'package:stylebox/features/home/domains/repos/product_reviews_repo.dart';
import 'package:stylebox/generated/l10n.dart';
import 'bagel_review_card.dart';
import 'bagel_review_delete_dialog.dart';

class BagelCustomerReviewsSection extends StatelessWidget {
  const BagelCustomerReviewsSection({
    super.key,
    required this.productId,
    required this.reviewsRepo,
    required this.onWriteReviewPressed,
    required this.currentUserId,
    required this.onEditReview,
    required this.onDeleteReview,
  });

  final String productId;
  final ProductReviewsRepo reviewsRepo;
  final VoidCallback onWriteReviewPressed;
  final String currentUserId;
  final Function(ReviewEntity) onEditReview;
  final Function(String) onDeleteReview;

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

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and write review button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              locale.bagelMysteryBagCustomerReviews,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _primaryTextColor(context),
              ),
            ),
            GestureDetector(
              onTap: onWriteReviewPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: KprimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      locale.reviewComposerTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Reviews list
        StreamBuilder<List<ReviewEntity>>(
          stream: reviewsRepo.watchProductReviews(productId: productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardColor(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: KdividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.reviewComposerFailureMessage,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _primaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      locale.bagelMysteryBagReviewsComingSoon,
                      style: TextStyle(
                        fontSize: 13,
                        color: _secondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              );
            }

            final reviews = snapshot.data ?? [];

            if (reviews.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _cardColor(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: KdividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.reviewComposerNoReviewsTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _primaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      locale.reviewComposerNoReviewsSubtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: _secondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: reviews
                  .map(
                    (review) => BagelReviewCard(
                      review: review,
                      currentUserId: currentUserId,
                      onEditReview: onEditReview,
                      onDeleteReview: (reviewId, locale) {
                        showBagelReviewDeleteConfirmation(
                          context: context,
                          reviewId: reviewId,
                          locale: locale,
                          onConfirm: onDeleteReview,
                        );
                      },
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

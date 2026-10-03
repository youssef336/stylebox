// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/entities/review_entity.dart';
import 'package:stylebox/core/helper_functions/build_error_bar.dart';
import 'package:stylebox/core/helper_functions/get_user.dart';
import 'package:stylebox/features/home/domains/repos/product_reviews_repo.dart';
import 'package:stylebox/generated/l10n.dart';

class ReviewComposerBottomSheet extends StatefulWidget {
  const ReviewComposerBottomSheet({
    super.key,
    required this.productId,
    required this.reviewsRepo,
    this.existingReview,
  });

  final String productId;
  final ProductReviewsRepo reviewsRepo;
  final ReviewEntity? existingReview;

  @override
  State<ReviewComposerBottomSheet> createState() =>
      _ReviewComposerBottomSheetState();
}

class _ReviewComposerBottomSheetState extends State<ReviewComposerBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final existingReview = widget.existingReview;
    if (existingReview != null) {
      _commentController.text = existingReview.review;
      _rating = existingReview.rating.toDouble();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final locale = S.of(context)!;
    final comment = _commentController.text.trim();

    if (_rating <= 0) {
      showErrorBar(context, locale.reviewComposerSelectRatingError);
      return;
    }

    if (comment.isEmpty) {
      showErrorBar(context, locale.reviewComposerCommentRequiredError);
      return;
    }

    setState(() => _isSubmitting = true);

    final currentUser = FirebaseAuth.instance.currentUser;
    final fallbackUser = getUser();
    final reviewerName = currentUser?.displayName?.trim().isNotEmpty == true
        ? currentUser!.displayName!.trim()
        : fallbackUser.name;
    final reviewerImage = currentUser?.photoURL?.trim() ?? '';

    final review = ReviewEntity(
      id:
          widget.existingReview?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: reviewerName,
      image: reviewerImage,
      rating: _rating,
      review: comment,
      date: DateTime.now().toIso8601String(),
      userId: currentUser?.uid,
    );

    final result = widget.existingReview == null
        ? await widget.reviewsRepo.addProductReview(
            productId: widget.productId,
            review: review,
          )
        : await widget.reviewsRepo.updateProductReview(
            productId: widget.productId,
            review: review,
          );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        showErrorBar(context, failure.message);
      },
      (_) {
        Navigator.of(context).pop(true);
        showErrorBar(context, locale.reviewComposerSuccessMessage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _sheetCardColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 64,
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        KaccentColor.withOpacity(0.7),
                        KprimaryColorLight.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: KaccentColor.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.existingReview == null
                    ? locale.reviewComposerTitle
                    : locale.reviewComposerEditTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _primaryTextColor(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.existingReview == null
                    ? locale.reviewComposerSubtitle
                    : locale.reviewComposerEditSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: _secondaryTextColor(context),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                locale.reviewComposerRatingLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _primaryTextColor(context),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  final selected = starValue <= _rating;

                  return IconButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            setState(() {
                              _rating = starValue.toDouble();
                            });
                          },
                    icon: Icon(
                      selected ? Icons.star_rounded : Icons.star_border_rounded,
                      color: KaccentColor,
                      size: 30,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  );
                }),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _commentController,
                enabled: !_isSubmitting,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: locale.reviewComposerCommentLabel,
                  hintText: locale.reviewComposerCommentHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: KdividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: KaccentColor,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isSubmitting
                          ? [
                              KprimaryColor.withOpacity(0.6),
                              KaccentColor.withOpacity(0.55),
                            ]
                          : [KaccentColor, KprimaryColor],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: KprimaryColor.withOpacity(0.16),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.transparent,
                      disabledForegroundColor: Colors.white.withOpacity(0.75),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            widget.existingReview == null
                                ? locale.reviewComposerSubmitButton
                                : locale.reviewComposerUpdateButton,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _sheetCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? KdarkModeCardColor
        : KlightModeCardColor;
  }

  Color _primaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? KdarkModeTextColor
        : KlightModeTextColor;
  }

  Color _secondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? KdarkModeTextSecondary
        : KlightModeTextSecondary;
  }
}

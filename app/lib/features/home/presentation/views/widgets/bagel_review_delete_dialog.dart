import 'package:flutter/material.dart';
import 'package:stylebox/generated/l10n.dart';

void showBagelReviewDeleteConfirmation({
  required BuildContext context,
  required String reviewId,
  required S locale,
  required Function(String) onConfirm,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(locale.reviewComposerDeleteConfirmTitle),
      content: Text(locale.reviewComposerDeleteConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(S.of(context)!.reviewComposerDeleteConfirmCancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onConfirm(reviewId);
          },
          child: Text(
            locale.reviewComposerDeleteConfirmDelete,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

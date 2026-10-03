import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:stylebox_dashboard/features/manage_data/data/sample_collection.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/cubit/restaurant_cubit.dart';

/// Asks for confirmation, then uploads the sample stores and boxes for the
/// logged-in owner. Must be called under a [RestaurantCubit].
Future<void> addSampleCollection(BuildContext context) async {
  final cubit = context.read<RestaurantCubit>();
  final messenger = ScaffoldMessenger.of(context);
  final user = FirebaseAuth.instance.currentUser;
  final email = user?.email;

  if (user == null || email == null) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Please log in again, then retry.'),
        backgroundColor: AppColors.errorColor,
      ),
    );
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: AppColors.primaryColor),
          SizedBox(width: 10),
          Expanded(child: Text('Add sample collection')),
        ],
      ),
      content: Text(
        'Adds ${SampleCollectionSeeder.storeCount} store branches pinned '
        'around Cairo & Giza (Urban Threads, Denim Lab, Layla Boutique, '
        'Mini Me Kids) with ${SampleCollectionSeeder.boxCount} clothing boxes '
        'and photos to $email.\n\n'
        'Running it again resets these sample stores. Your other stores '
        'are not touched.',
        style: const TextStyle(fontSize: 14, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Add'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final progress = ValueNotifier<double>(0);
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (_, value, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Uploading the sample collection...',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: value == 0 ? null : value,
                color: AppColors.primaryColor,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 8),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  try {
    final boxes = await SampleCollectionSeeder().seed(
      userEmail: email,
      ownerId: user.uid,
      onProgress: (done, total) => progress.value = done / total,
    );
    navigator.pop();
    await cubit.refreshWithMessage(
      email,
      'Sample collection added: $boxes Style Boxes',
    );
  } catch (e) {
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Could not add the sample collection: $e'),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }
}

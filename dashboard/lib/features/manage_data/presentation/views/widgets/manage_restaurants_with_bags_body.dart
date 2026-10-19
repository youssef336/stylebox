import 'package:stylebox_dashboard/core/helper_functions/parse_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:stylebox_dashboard/core/services/get_it_services.dart';
import 'package:stylebox_dashboard/core/services/user_session.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';
import 'package:stylebox_dashboard/core/widgets/store_visuals.dart';
import 'package:stylebox_dashboard/features/add_product/domain/entities/add_product_input_entity.dart';
import 'package:stylebox_dashboard/features/manage_data/domain/entities/restaurant_entity.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/cubit/restaurant_cubit.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/views/widgets/restaurant_form_sheet.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/views/widgets/sample_collection_action.dart';
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';

class ManageRestaurantsWithBagsBody extends StatefulWidget {
  const ManageRestaurantsWithBagsBody({super.key});

  @override
  State<ManageRestaurantsWithBagsBody> createState() =>
      _ManageRestaurantsWithBagsBodyState();
}

class _ManageRestaurantsWithBagsBodyState
    extends State<ManageRestaurantsWithBagsBody> {
  final ProductsRepo _productsRepo = getIt<ProductsRepo>();
  Map<String, List<AddProductInputEntity>> _restaurantBags = {};
  bool _isLoadingBags = false;

  bool _bagsLoaded = false;

  @override
  void initState() {
    super.initState();
    // Don't load bags here - wait for restaurants to load in build
  }

  Future<void> _loadBagsForRestaurants(
    List<RestaurantEntity> restaurants,
  ) async {
    if (_bagsLoaded) return; // Already loaded

    setState(() => _isLoadingBags = true);

    final bagsMap = <String, List<AddProductInputEntity>>{};

    for (final restaurant in restaurants) {
      if (restaurant.docId != null) {
        final result = await _productsRepo.getProductsByRestaurant(
          restaurantId: restaurant.docId!,
        );
        result.fold(
          (failure) => bagsMap[restaurant.docId!] = [],
          (bags) => bagsMap[restaurant.docId!] = bags,
        );
      }
    }

    if (mounted) {
      setState(() {
        _restaurantBags = bagsMap;
        _isLoadingBags = false;
        _bagsLoaded = true;
      });
    }
  }

  Future<void> _refresh(List<RestaurantEntity> restaurants) async {
    setState(() => _bagsLoaded = false); // Reset to reload bags
    context.read<RestaurantCubit>().fetchRestaurants(
      UserSession.instance.currentEmail,
    );
    await _loadBagsForRestaurants(restaurants);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantCubit, RestaurantState>(
      listener: (context, state) {
        if (state is RestaurantOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(state.message),
                ],
              ),
              backgroundColor: AppColors.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          // Reload bags after successful operation
          setState(() => _bagsLoaded = false);
        }
        if (state is RestaurantError && state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RestaurantLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (state is RestaurantEmpty) {
          return _EmptyState(onAdd: () => _showAddSheet(context));
        }

        final restaurants = switch (state) {
          RestaurantLoaded s => s.restaurants,
          RestaurantOperationLoading s => s.restaurants,
          RestaurantOperationSuccess s => s.restaurants,
          RestaurantError s => s.restaurants,
          _ => <RestaurantEntity>[],
        };

        if (state is RestaurantError && restaurants.isEmpty) {
          return _ErrorState(
            message: state.message,
            onRetry: () => _refresh(restaurants),
          );
        }

        final busyId = state is RestaurantOperationLoading
            ? state.operationId
            : null;

        // Load bags when restaurants are first loaded
        if (restaurants.isNotEmpty && !_bagsLoaded && !_isLoadingBags) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadBagsForRestaurants(restaurants);
          });
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () => _refresh(restaurants),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: restaurants.length,
            itemBuilder: (_, index) {
              final restaurant = restaurants[index];
              final bags = _restaurantBags[restaurant.docId] ?? [];

              return _RestaurantWithBagsCard(
                restaurant: restaurant,
                bags: bags,
                isBusy: busyId == restaurant.docId,
                isLoadingBags: _isLoadingBags,
                onEdit: () => _showEditSheet(context, restaurant),
                onDelete: () => _confirmDelete(context, restaurant),
                onDeleteProduct: _deleteProduct,
                onEditBag: _showEditBagDialog,
                onRestockBag: _restockBag,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _restockBag(
    BuildContext context,
    String? restaurantId,
    AddProductInputEntity bag,
  ) async {
    final currentBagsLeft = bag.bagsLeft;
    final newBagsLeft = currentBagsLeft + 5; // Add 5 bags by default

    final updatedBag = AddProductInputEntity(
      docId: bag.docId,
      productId: bag.productId,
      isAvailable: bag.isAvailable,
      title: bag.title,
      price: bag.price,
      oldPrice: bag.oldPrice,
      bagsLeft: newBagsLeft,
      detectedItems: bag.detectedItems,
      imageUrl: bag.imageUrl,
      userEmail: bag.userEmail,
      restaurantId: bag.restaurantId,
      restaurantName: bag.restaurantName,
      pickupTime: bag.pickupTime,
      reviews: bag.reviews,
      avgRating: bag.avgRating,
      sizes: bag.sizes,
      category: bag.category,
    );

    // Optimistic update
    setState(() {
      final list = _restaurantBags[restaurantId] ?? [];
      final index = list.indexWhere((b) => b.productId == bag.productId);
      if (index != -1) {
        list[index] = updatedBag;
        _restaurantBags[restaurantId!] = List.from(list);
      }
    });

    final docId = bag.productId ?? bag.docId;
    if (docId != null) {
      final updateResult = await _productsRepo.updateProduct(docId, updatedBag);
      updateResult.fold(
        (failure) {
          // Revert on failure
          setState(() {
            final list = _restaurantBags[restaurantId] ?? [];
            final index = list.indexWhere((b) => b.productId == bag.productId);
            if (index != -1) {
              list[index] = bag;
              _restaurantBags[restaurantId!] = List.from(list);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to restock: ${failure.message}'),
              backgroundColor: AppColors.errorColor,
            ),
          );
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Restocked! Added 5 boxes (Total: $newBagsLeft)'),
              backgroundColor: AppColors.successColor,
            ),
          );
        },
      );
    }
  }

  Future<void> _showEditBagDialog(
    BuildContext context,
    String? restaurantId,
    AddProductInputEntity bag,
  ) async {
    final titleCtrl = TextEditingController(text: bag.title);
    final priceCtrl = TextEditingController(
      text: bag.price > 0 ? bag.price.toStringAsFixed(2) : '',
    );
    final oldPriceCtrl = TextEditingController(
      text: bag.oldPrice != null && bag.oldPrice! > 0
          ? bag.oldPrice!.toStringAsFixed(2)
          : '',
    );
    final bagsLeftCtrl = TextEditingController(
      text: bag.bagsLeft > 0 ? bag.bagsLeft.toString() : '',
    );
    bool isAvailable = bag.isAvailable;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.edit, color: AppColors.primaryColor, size: 24),
                  SizedBox(width: 10),
                  Text('Edit Style Box'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.shopping_bag_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: oldPriceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Old Price',
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'New Price *',
                              prefixIcon: Icon(Icons.local_offer_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bagsLeftCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Boxes Left *',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 20),
                        const SizedBox(width: 8),
                        const Text('Available'),
                        const Spacer(),
                        Switch(
                          value: isAvailable,
                          onChanged: (v) =>
                              setDialogState(() => isAvailable = v),
                          activeThumbColor: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
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
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      if (!context.mounted) return;
      final price = parsePrice(priceCtrl.text) ?? 0.0;
      final oldPrice = parsePrice(oldPriceCtrl.text);
      final bagsLeft = int.tryParse(bagsLeftCtrl.text) ?? 0;

      if (price <= 0 || bagsLeft <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Price and boxes left must be greater than 0'),
            backgroundColor: AppColors.errorColor,
          ),
        );
        return;
      }

      final updatedBag = AddProductInputEntity(
        docId: bag.docId,
        productId: bag.productId,
        isAvailable: isAvailable,
        title: titleCtrl.text.trim(),
        price: price,
        oldPrice: oldPrice != null && oldPrice > 0 ? oldPrice : null,
        bagsLeft: bagsLeft,
        detectedItems: bag.detectedItems,
        imageUrl: bag.imageUrl,
        userEmail: bag.userEmail,
        restaurantId: bag.restaurantId,
        restaurantName: bag.restaurantName,
        pickupTime: bag.pickupTime,
        reviews: bag.reviews,
        avgRating: bag.avgRating,
        sizes: bag.sizes,
        category: bag.category,
      );

      // Optimistic update
      setState(() {
        final list = _restaurantBags[restaurantId] ?? [];
        final index = list.indexWhere((b) => b.productId == bag.productId);
        if (index != -1) {
          list[index] = updatedBag;
          _restaurantBags[restaurantId!] = List.from(list);
        }
      });

      final docId = bag.productId ?? bag.docId;
      if (docId != null) {
        final updateResult = await _productsRepo.updateProduct(
          docId,
          updatedBag,
        );
        updateResult.fold(
          (failure) {
            // Revert on failure
            setState(() {
              final list = _restaurantBags[restaurantId] ?? [];
              final index = list.indexWhere(
                (b) => b.productId == bag.productId,
              );
              if (index != -1) {
                list[index] = bag;
                _restaurantBags[restaurantId!] = List.from(list);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update: ${failure.message}'),
                backgroundColor: AppColors.errorColor,
              ),
            );
          },
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Style Box updated successfully'),
                backgroundColor: AppColors.successColor,
              ),
            );
          },
        );
      }
    }

    titleCtrl.dispose();
    priceCtrl.dispose();
    oldPriceCtrl.dispose();
    bagsLeftCtrl.dispose();
  }

  void _showAddSheet(BuildContext context) {
    final cubit = context.read<RestaurantCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const RestaurantFormSheet()),
    );
  }

  void _showEditSheet(BuildContext context, RestaurantEntity entity) {
    final cubit = context.read<RestaurantCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: RestaurantFormSheet(existing: entity),
      ),
    );
  }

  void _confirmDelete(BuildContext context, RestaurantEntity entity) {
    final cubit = context.read<RestaurantCubit>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.errorColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.deleteRestaurant),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.delete_restaurant_confirm(entity.name),
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColors.primaryColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (entity.docId != null) cubit.deleteRestaurant(entity.docId!);
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(
    BuildContext context,
    String? restaurantId,
    String? productId,
  ) async {
    if (productId == null) return;
    if (restaurantId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteProduct),
        content: Text(AppLocalizations.of(context)!.deleteProductConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final previous = Map<String, List<AddProductInputEntity>>.from(
      _restaurantBags,
    );

    setState(() {
      final list = _restaurantBags[restaurantId] ?? [];
      _restaurantBags[restaurantId] = list
          .where((b) => b.productId != productId)
          .toList();
    });

    final result = await _productsRepo.deleteProduct(productId);
    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() => _restaurantBags = previous);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.errorColor,
          ),
        );
      },
      (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.productDeleted),
            backgroundColor: AppColors.successColor,
          ),
        );
      },
    );
  }
}

class _RestaurantWithBagsCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final List<AddProductInputEntity> bags;
  final bool isBusy;
  final bool isLoadingBags;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Future<void> Function(
    BuildContext context,
    String? restaurantId,
    String? productId,
  )
  onDeleteProduct;
  final void Function(BuildContext, String?, AddProductInputEntity) onEditBag;
  final void Function(BuildContext, String?, AddProductInputEntity)
  onRestockBag;

  const _RestaurantWithBagsCard({
    required this.restaurant,
    required this.bags,
    required this.isBusy,
    this.isLoadingBags = false,
    required this.onEdit,
    required this.onDelete,
    required this.onDeleteProduct,
    required this.onEditBag,
    required this.onRestockBag,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RestaurantHeader(
            restaurant: restaurant,
            isBusy: isBusy,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  l10n.availableBags.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (!isLoadingBags)
                  Text(
                    l10n.dashBoxesCount('${bags.length}'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
              ],
            ),
          ),
          if (isLoadingBags)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            )
          else if (bags.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: Text(
                l10n.dashNoBoxesYet,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Column(
                children: [
                  for (var i = 0; i < bags.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        height: 1,
                        indent: 84,
                        color: AppColors.divider,
                      ),
                    _BagCard(
                      bag: bags[i],
                      onDelete: () => onDeleteProduct(
                        context,
                        restaurant.docId,
                        bags[i].productId,
                      ),
                      onEdit: () =>
                          onEditBag(context, restaurant.docId, bags[i]),
                      onRestock: () =>
                          onRestockBag(context, restaurant.docId, bags[i]),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RestaurantHeader extends StatelessWidget {
  final RestaurantEntity restaurant;
  final bool isBusy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RestaurantHeader({
    required this.restaurant,
    required this.isBusy,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
      child: Row(
        children: [
          StoreThumbnail(imageUrl: restaurant.RestaurantimageUrl, size: 58),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        restaurant.branchLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    StatusPill(
                      label: restaurant.isAvailable
                          ? l10n.available
                          : l10n.notAvailable,
                      positive: restaurant.isAvailable,
                    ),
                    StatusPill(
                      label: restaurant.isOpend ? l10n.open : l10n.closed,
                      positive: restaurant.isOpend,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.edit,
            onPressed: isBusy ? null : onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.darkGrey,
            ),
          ),
          IconButton(
            tooltip: l10n.delete,
            onPressed: isBusy ? null : onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: AppColors.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BagCard extends StatelessWidget {
  final AddProductInputEntity bag;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onRestock;

  const _BagCard({
    required this.bag,
    this.onDelete,
    this.onEdit,
    this.onRestock,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final oldPrice = bag.oldPrice;
    final low = bag.bagsLeft <= 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 64,
              height: 64,
              child: bag.imageUrl != null && bag.imageUrl!.startsWith('http')
                  ? Image.network(bag.imageUrl!, fit: BoxFit.cover)
                  : const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                      ),
                      child: Icon(
                        Icons.checkroom_rounded,
                        color: AppColors.secoundryDark,
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
                  bag.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${bag.price.toStringAsFixed(0)} EGP',
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    if (oldPrice != null && oldPrice > bag.price) ...[
                      const SizedBox(width: 6),
                      Text(
                        oldPrice.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (low
                                    ? AppColors.warningColor
                                    : AppColors.successColor)
                                .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${bag.bagsLeft} ${l10n.bagsLeft}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: low
                              ? AppColors.warningColor
                              : AppColors.successColor,
                        ),
                      ),
                    ),
                    if (onRestock != null) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onRestock,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            '+ ${l10n.dashRestock}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit Style Box',
            onPressed: onEdit,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.darkGrey,
              size: 20,
            ),
          ),
          IconButton(
            tooltip: 'Delete product',
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.errorColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.store_outlined,
              size: 50,
              color: AppColors.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Stores Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first store to start selling Style Boxes.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Store'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => addSampleCollection(context),
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Or add a sample collection'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: AppColors.errorColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

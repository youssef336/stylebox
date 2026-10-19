import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/widgets/box_artwork.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart_item/cart_item_cubit.dart';
import 'package:stylebox/features/home/presentation/views/widgets/cart_item_action_buttoms.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../../domain/entities/cart_item_entity.dart';
import '../../manager/cubits/cart/cart_cubit.dart';

/// Bag row as a floating card: tall artwork thumbnail, name + store + sizes,
/// remove button in the corner and a pill quantity stepper next to the price.
class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartItemCubit, CartItemState>(
      buildWhen: (previous, current) {
        if (current is CartItemupdated) {
          if (current.cartItemEntity == cartItemEntity) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        if (cartItemEntity.count == 0) {
          context.read<CartCubit>().deleteCartItem(cartItemEntity);
        }
        final product = cartItemEntity.productEntity;
        final scheme = Theme.of(context).colorScheme;
        final locale = S.of(context)!;
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final total = cartItemEntity.calculateTotalPrice();

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 92,
                  height: 112,
                  child: BoxArtwork(
                    product: product,
                    iconSize: 38,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isRtl ? product.nameAr : product.nameEn,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    color: scheme.onSurface,
                                  ),
                                ),
                                if ((product.restaurantName ?? '').isNotEmpty)
                                  Text(
                                    product.restaurantName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          InkResponse(
                            radius: 18,
                            onTap: () => context
                                .read<CartCubit>()
                                .deleteCartItem(cartItemEntity),
                            child: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (product.sizes.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: product.sizes
                              .map(
                                (s) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  child: Text(
                                    s,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${total.toStringAsFixed(total % 1 == 0 ? 0 : 2)} ${locale.bagCurrencySuffix}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: scheme.primary,
                              ),
                            ),
                          ),
                          CartItemActionButtoms(cartItemEntity: cartItemEntity),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

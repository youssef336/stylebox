import 'package:flutter/material.dart';
import 'package:stylebox/features/home/presentation/views/widgets/cart_item.dart';

import '../../../domain/entities/cart_item_entity.dart';

class CartItemList extends StatelessWidget {
  const CartItemList({super.key, required this.cartItems});
  final List<CartItemEntity> cartItems;
  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return CartItem(cartItemEntity: cartItems[index]);
      },
    );
  }
}

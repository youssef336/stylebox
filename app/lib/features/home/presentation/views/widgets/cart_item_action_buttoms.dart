import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/features/home/domain/entities/cart_item_entity.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart_item/cart_item_cubit.dart';

/// Pill-shaped quantity stepper: − count +.
class CartItemActionButtoms extends StatelessWidget {
  const CartItemActionButtoms({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CartItemActionButtom(
            color: Colors.transparent,
            icon: Icon(Icons.remove_rounded, color: scheme.onSurface),
            onPressed: () {
              cartItemEntity.decreaseCount();
              context.read<CartItemCubit>().updateCartItem(cartItemEntity);
            },
          ),
          SizedBox(
            width: 22,
            child: Text(
              cartItemEntity.count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
          ),
          CartItemActionButtom(
            color: scheme.primary,
            icon: Icon(Icons.add_rounded, color: scheme.onPrimary),
            onPressed: () {
              cartItemEntity.icreaseCount();
              context.read<CartItemCubit>().updateCartItem(cartItemEntity);
            },
          ),
        ],
      ),
    );
  }
}

class CartItemActionButtom extends StatelessWidget {
  const CartItemActionButtom({
    super.key,
    required this.color,
    required this.icon,
    required this.onPressed,
  });
  final Color color;
  final Icon icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(5),
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: FittedBox(child: icon),
      ),
    );
  }
}

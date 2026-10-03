import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/features/home/domain/entities/cart_item_entity.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart_item/cart_item_cubit.dart';

class CartItemActionButtoms extends StatelessWidget {
  const CartItemActionButtoms({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CartItemActionButtom(
          color: KprimaryColorDark,
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            cartItemEntity.icreaseCount();
            context.read<CartItemCubit>().updateCartItem(cartItemEntity);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            cartItemEntity.count.toString(),
            textAlign: TextAlign.center,
            style: AppTextStyles.cairoBold.copyWith(fontSize: 16),
          ),
        ),
        CartItemActionButtom(
          color: const Color(0xFFF3F5F7),
          icon: const Icon(Icons.remove, color: Colors.grey),
          onPressed: () {
            cartItemEntity.decreaseCount();
            context.read<CartItemCubit>().updateCartItem(cartItemEntity);
          },
        ),
      ],
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
        padding: const EdgeInsets.all(2),
        width: 24,
        height: 24,
        decoration: ShapeDecoration(
          color: color /* Green1-500 */,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: FittedBox(child: icon),
      ),
    );
  }
}

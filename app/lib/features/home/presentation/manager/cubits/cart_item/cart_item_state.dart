part of 'cart_item_cubit.dart';

abstract class CartItemState {
  const CartItemState();
}

class CartItemInitial extends CartItemState {}

class CartItemupdated extends CartItemState {
  final CartItemEntity cartItemEntity;

  const CartItemupdated({required this.cartItemEntity});
}

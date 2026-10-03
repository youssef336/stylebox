// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/features/home/domain/entities/cart_entites.dart';

import '../../../../domain/entities/cart_item_entity.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  CartEntites cartEntites = CartEntites([]);
  void addProductToCart(ProductEntity productEntity) {
    bool isProductExist = cartEntites.isExist(productEntity);
    var cartItem = cartEntites.getCartItem(productEntity);
    if (isProductExist) {
      cartItem.icreaseCount();
    } else {
      cartEntites.addCartItem(cartItem);
    }
    emit(CartItemAdd());
  }

  void deleteCartItem(CartItemEntity cartItemEntity) {
    cartEntites.removeCartItem(cartItemEntity);
    emit(CartItemRemoved());
  }
}

part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartItemAdd extends CartState {}

class CartItemRemoved extends CartState {}

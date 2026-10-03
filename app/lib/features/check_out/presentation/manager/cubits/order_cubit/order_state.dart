part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderSuccess extends OrderState {}

class Orderfailure extends OrderState {
  final String message;
  const Orderfailure({required this.message});
}

class OrderLoading extends OrderState {}

import 'package:equatable/equatable.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/errors/failures.dart';

abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  final List<ProductEntity> products;
  final DateTime _timestamp;
  ProductsSuccess(this.products) : _timestamp = DateTime.now();

  @override
  List<Object?> get props => [products, _timestamp];
}

class ProductsFailure extends ProductsState {
  final Failure failure;
  ProductsFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

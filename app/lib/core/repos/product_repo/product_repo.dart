import 'package:dartz/dartz.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/errors/failures.dart';

abstract class ProductRepo {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? restaurantId,
  });

  Stream<Either<Failure, List<ProductEntity>>> watchProducts({
    String? restaurantId,
    int? restaurantLimit,
  });

  Future<Either<Failure, List<ProductEntity>>> getProductsWithLimit(
    int limit, {
    String? restaurantId,
  });

  Future<Either<Failure, List<ProductEntity>>> getBestSellingProduct({
    String? restaurantId,
  });

  Future<Either<Failure, List<ProductEntity>>> getBestSellingProductMoreLimit({
    String? restaurantId,
  });

  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query, {
    String? restaurantId,
  });
}

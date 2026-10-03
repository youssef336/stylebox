import 'package:dartz/dartz.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/errors/failures.dart';
import 'package:stylebox/core/models/product_model.dart';
import 'package:stylebox/core/repos/product_repo/product_repo.dart';
import 'package:stylebox/core/services/database_servies.dart';
import 'package:stylebox/core/utils/back_end_endpoints.dart';

class ProductRepoImpl extends ProductRepo {
  final DatabaseServies databaseServies;

  ProductRepoImpl(this.databaseServies);
  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProduct({
    String? restaurantId,
  }) async {
    try {
      final query = <String, dynamic>{
        'limit': 6,
        'orderBy': 'sellingCount',
        'descending': true,
      };

      if (restaurantId != null && restaurantId.isNotEmpty) {
        query['restaurantId'] = restaurantId;
      }

      var data =
          await databaseServies.getData(
                path: BackEndEndpoints.getProducts,
                query: query,
              )
              as List<Map<String, dynamic>>;

      List<ProductEntity> products = data
          .map((e) => ProductModel.fromJson(e).toEntity())
          .toList();
      return right(products);
    } catch (e, st) {
      print('Error in getBestSellingProduct: $e\n$st');
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? restaurantId,
  }) async {
    try {
      final query = <String, dynamic>{};

      if (restaurantId != null && restaurantId.isNotEmpty) {
        query['restaurantId'] = restaurantId;
      }

      var data =
          await databaseServies.getData(
                path: BackEndEndpoints.getProducts,
                query: query.isEmpty ? null : query,
              )
              as List<Map<String, dynamic>>;
      print('🔍 getProducts - Raw data count: ${data.length}');
      List<ProductModel> products = data
          .map((e) => ProductModel.fromJson(e))
          .toList();
      List<ProductEntity> productsEntity = products
          .map((e) => e.toEntity())
          .toList();
      print('✅ getProducts - Entities count: ${productsEntity.length}');

      return right(productsEntity);
    } catch (e, st) {
      print('Error in getProducts: $e\n$st');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ProductEntity>>> watchProducts({
    String? restaurantId,
    int? restaurantLimit,
  }) async* {
    final query = <String, dynamic>{};

    if (restaurantId != null && restaurantId.isNotEmpty) {
      query['restaurantId'] = restaurantId;
    }
    if (restaurantLimit != null) {
      query['restaurantLimit'] = restaurantLimit;
    }

    print('🔍 ProductRepoImpl.watchProducts query=$query');

    try {
      await for (final data in databaseServies.watchData(
        path: BackEndEndpoints.getProducts,
        query: query.isEmpty ? null : query,
      )) {
        try {
          final products = (data as List<Map<String, dynamic>>)
              .map((e) => ProductModel.fromJson(e).toEntity())
              .toList();
          yield right(products);
        } catch (e, st) {
          print('Error in watchProducts: $e\n$st');
          yield left(ServerFailure(e.toString()));
        }
      }
    } catch (e, st) {
      print('Stream error in watchProducts: $e\n$st');
      yield left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsWithLimit(
    int limit, {
    String? restaurantId,
  }) async {
    try {
      final query = <String, dynamic>{'limit': limit};

      if (restaurantId != null && restaurantId.isNotEmpty) {
        query['restaurantId'] = restaurantId;
      }

      var data =
          await databaseServies.getData(
                path: BackEndEndpoints.getProducts,
                query: query,
              )
              as List<Map<String, dynamic>>;
      print('🔍 getProductsWithLimit($limit) - Raw data count: ${data.length}');
      List<ProductModel> products = data
          .map((e) => ProductModel.fromJson(e))
          .toList();
      List<ProductEntity> productsEntity = products
          .map((e) => e.toEntity())
          .toList();
      print(
        '✅ getProductsWithLimit($limit) - Entities count: ${productsEntity.length}',
      );

      return right(productsEntity);
    } catch (e, st) {
      print('Error in getProductsWithLimit: $e\n$st');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProductMoreLimit({
    String? restaurantId,
  }) async {
    try {
      final query = <String, dynamic>{
        'orderBy': 'sellingCount',
        'descending': true,
      };

      if (restaurantId != null && restaurantId.isNotEmpty) {
        query['restaurantId'] = restaurantId;
      }

      var data =
          await databaseServies.getData(
                path: BackEndEndpoints.getProducts,
                query: query,
              )
              as List<Map<String, dynamic>>;

      List<ProductEntity> products = data
          .map((e) => ProductModel.fromJson(e).toEntity())
          .toList();
      return right(products);
    } catch (e, st) {
      print('Error in getBestSellingProductMoreLimit: $e\n$st');
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query, {
    String? restaurantId,
  }) async {
    try {
      // First get all products
      final result = await getProducts(restaurantId: restaurantId);

      return await result.fold((failure) => left(failure), (products) {
        // Filter products where nameEn or nameAr contains the query (case insensitive)
        final filteredProducts = products.where((product) {
          final queryLower = query.toLowerCase();
          return product.nameEn.toLowerCase().contains(queryLower) ||
              product.nameAr.toLowerCase().contains(queryLower);
        }).toList();

        return right(filteredProducts);
      });
    } catch (e) {
      return left(const ServerFailure('Failed to search products'));
    }
  }
}

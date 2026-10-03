// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stylebox/core/errors/failures.dart';
import 'package:stylebox/core/repos/product_repo/product_repo.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepo productRepo;
  StreamSubscription? _productsSubscription;

  ProductsCubit(this.productRepo) : super(ProductsInitial());

  Future<void> loadProducts({
    int? limit,
    String? restaurantId,
    int? restaurantLimit,
  }) async {
    print(
      '📦 ProductsCubit.loadProducts: limit=$limit, restaurantId=$restaurantId, restaurantLimit=$restaurantLimit',
    );
    await _productsSubscription?.cancel();
    emit(ProductsLoading());
    try {
      if (limit != null) {
        final result = await productRepo.getProductsWithLimit(
          limit,
          restaurantId: restaurantId,
        );
        result.fold((failure) => emit(ProductsFailure(failure)), (products) {
          print(
            '📦 Products loaded: ${products.length} products (limit: $limit)',
          );
          emit(ProductsSuccess(products));
        });
        return;
      }

      _productsSubscription = productRepo
          .watchProducts(
            restaurantId: restaurantId,
            restaurantLimit: restaurantLimit,
          )
          .listen(
            (result) {
              result.fold((failure) => emit(ProductsFailure(failure)), (
                products,
              ) {
                print('📦 Products refreshed: ${products.length} products');
                for (final p in products) {
                  try {
                    print(
                      '🔖 product documentId=${p.documentId} restaurantId=${p.restaurantId} title=${p.nameEn} bagsLeft=${p.bagsLeft}',
                    );
                  } catch (_) {}
                }
                emit(ProductsSuccess(products));
              });
            },
            onError: (error) {
              emit(ProductsFailure(ServerFailure(error.toString())));
            },
          );
    } catch (e) {
      print('❌ Error loading products: $e');
      emit(ProductsFailure(ServerFailure(e.toString())));
    }
  }

  @override
  Future<void> close() async {
    await _productsSubscription?.cancel();
    return super.close();
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/repos/ordres_repo/orders_repo.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';

import '../../../../domains/entities/order_entity.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.ordersRepo) : super(OrderInitial());
  final OrdersRepo ordersRepo;

  Future<void> addOrder({required OrderEntity order}) async {
    emit(OrderLoading());
    final result = await ordersRepo.addOrder(order: order);
    var orderConfirmed = false;
    result.fold(
      (failure) => emit(Orderfailure(message: failure.message)),
      (_) => orderConfirmed = true,
    );

    if (orderConfirmed) {
      final currentPoints = Prefs.getInt(Kpoints);
      await Prefs.setInt(Kpoints, currentPoints + KOrderConfirmationPoints);
      emit(OrderSuccess());
    }
  }
}

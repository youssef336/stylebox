import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:stylebox/core/repos/ordres_repo/orders_repo.dart';
import 'package:stylebox/core/services/get_it_service.dart';
import 'package:stylebox/features/check_out/domains/entities/order_entity.dart';
import 'package:stylebox/features/check_out/presentation/manager/cubits/order_cubit/order_cubit.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/check_out_view_body.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/order_cubit_bloc_consumer.dart';
import 'package:stylebox/features/home/domain/entities/cart_entites.dart';
import 'package:stylebox/generated/l10n.dart';

class CheckOutView extends StatelessWidget {
  const CheckOutView({super.key, required this.cartItems});

  static const String routeName = '/CheckOutView';
  final CartEntites cartItems;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<OrderEntity>(
          create: (_) => OrderEntity(cartEntites: cartItems, uID: 'debug-user'),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(getIt<OrdersRepo>()),
        ),
      ],
      child: OrderCubitBlocConsumer(
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context)!.checkOutViewTitle),
            centerTitle: true,
          ),
          body: const CheckOutViewBody(),
        ),
      ),
    );
  }
}

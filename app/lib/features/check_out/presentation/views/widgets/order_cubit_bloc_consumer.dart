// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/widgets/custom_modal_progress_hub.dart';
import 'package:stylebox/features/check_out/presentation/manager/cubits/order_cubit/order_cubit.dart';

import '../../../../../core/helper_functions/build_error_bar.dart';
import '../../../../../generated/l10n.dart';
import 'package:stylebox/features/check_out/domains/entities/order_entity.dart';
import 'package:stylebox/features/check_out/domains/entities/checkout_payment_method.dart';

class OrderCubitBlocConsumer extends StatelessWidget {
  const OrderCubitBlocConsumer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          final method = context.read<OrderEntity>().paymentMethod;
          final msg = switch (method) {
            CheckoutPaymentMethod.cashOnDelivery =>
              S.of(context)!.orderCashSuccessMessage,
            CheckoutPaymentMethod.visa =>
              S.of(context)!.orderVisaSuccessMessage,
            CheckoutPaymentMethod.paypal =>
              S.of(context)!.paymentSuccessMessage,
            null => S.of(context)!.orderCashSuccessMessage,
          };
          showErrorBar(context, msg);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home', // MainView.routeName
            (route) => false,
          );
        }
        if (state is Orderfailure) {
          showErrorBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is OrderLoading ? true : false,
          child: child,
        );
      },
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/cubits/locale/locale_cubit.dart';
import 'package:stylebox/features/check_out/presentation/views/check_out_view.dart';

import '../../../../../core/widgets/custom_buttom.dart';

import '../../manager/cubits/cart/cart_cubit.dart';
import '../../manager/cubits/cart_item/cart_item_cubit.dart';

class CustomCartButtomBlocBuilder extends StatelessWidget {
  const CustomCartButtomBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartItemCubit, CartItemState>(
      builder: (context, state) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            return BlocBuilder<LocaleCubit, LocaleState>(
              builder: (notificationContext, notificationState) {
                return BlocBuilder<LocaleCubit, LocaleState>(
                  builder: (context, localeState) {
                    final isAr = localeState is LocaleChangedtoArabic;
                    return CustomButtom(
                      text: isAr ? 'الدفع' : 'Checkout',
                      onPressed: () {
                        // Only pass a notification if we have successfully loaded notifications
                        // final notification =
                        //     notificationState is NotificationcubitSuccess &&
                        //             notificationState.notifications.isNotEmpty
                        //         ? notificationState.notifications
                        //         : null;

                        Navigator.pushNamed(
                          context,
                          CheckOutView.routeName,
                          arguments: {
                            'cartItems': context.read<CartCubit>().cartEntites,
                            // 'notificationEntity': notification,
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

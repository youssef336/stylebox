import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/cubits/locale/locale_cubit.dart';

import 'package:stylebox/features/home/presentation/manager/cubits/cart/cart_cubit.dart';

import '../../../../../core/utils/text_styles.dart';
import '../../manager/cubits/cart_item/cart_item_cubit.dart';

class CartViewHeader extends StatelessWidget {
  const CartViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<CartCubit>().cartEntites.cartItems.isNotEmpty,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),

        decoration: const BoxDecoration(
          color: Color(0xFFEBF9F1) /* Green1-50 */,
        ),
        child: BlocBuilder<CartItemCubit, CartItemState>(
          builder: (context, state) {
            return Center(
              child: BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, localeState) {
                  final isAr = localeState is LocaleChangedtoArabic;
                  return Text(
                    isAr
                        ? 'لديك ${context.watch<CartCubit>().cartEntites.calculateTotalCount()} منتجات في سله التسوق'
                        : ' You have ${context.watch<CartCubit>().cartEntites.calculateTotalCount()} items in your cart',
                    style: AppTextStyles.cairoRegular.copyWith(
                      height: 1.60,
                      color: KprimaryColor,
                    ),
                    textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

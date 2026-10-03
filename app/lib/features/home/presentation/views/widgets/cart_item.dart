import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/core/widgets/custom_network_image.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart_item/cart_item_cubit.dart';
import 'package:stylebox/core/cubits/locale/locale_cubit.dart';
import 'package:stylebox/features/home/presentation/views/widgets/cart_item_action_buttoms.dart';

import '../../../../../core/utils/text_styles.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../manager/cubits/cart/cart_cubit.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItemEntity});
  final CartItemEntity cartItemEntity;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartItemCubit, CartItemState>(
      buildWhen: (previous, current) {
        if (current is CartItemupdated) {
          if (current.cartItemEntity == cartItemEntity) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        if (cartItemEntity.count == 0) {
          context.read<CartCubit>().deleteCartItem(cartItemEntity);
        }
        return IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 73,
                height: 92,
                decoration: const BoxDecoration(color: Color(0xFFF3F5F7)),
                child: Builder(
                  builder: (context) {
                    final url = cartItemEntity.productEntity.imageUrl;
                    if (url.isNotEmpty) {
                      return CustomNetworkImage(ImageUrl: url);
                    }
                    return ClipRRect(
                      child: Image.asset(
                        'assets/images/app_icon.jpg',
                        fit: BoxFit.cover,
                        width: 73,
                        height: 92,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<LocaleCubit, LocaleState>(
                            builder: (context, localeState) {
                              final isAr = localeState is LocaleChangedtoArabic;
                              return Text(
                                isAr
                                    ? cartItemEntity.productEntity.nameAr
                                    : cartItemEntity.productEntity.nameEn,
                                style: AppTextStyles.cairoBold.copyWith(),
                                textDirection: isAr
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            context.read<CartCubit>().deleteCartItem(
                              cartItemEntity,
                            );
                          },
                          child: SvgPicture.asset(
                            AssetsData.light().images.trash_svg,
                          ),
                        ),
                      ],
                    ),

                    BlocBuilder<LocaleCubit, LocaleState>(
                      builder: (context, localeState) {
                        final isAr = localeState is LocaleChangedtoArabic;
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        final weightColor = isDark ? KdarkModeTextSecondary : KlightModeTextSecondary;
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "${cartItemEntity.calculateTotalWeight()}",
                                style: AppTextStyles.cairoRegular.copyWith(
                                  color: weightColor,
                                ),
                              ),
                              TextSpan(
                                text: isAr ? 'كيلو' : 'Kg',
                                style: AppTextStyles.cairoRegular.copyWith(
                                  color: weightColor,
                                ),
                              ),
                            ],
                          ),
                          textDirection: isAr
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        );
                      },
                    ),

                    Row(
                      children: [
                        CartItemActionButtoms(cartItemEntity: cartItemEntity),
                        const Spacer(),
                        BlocBuilder<LocaleCubit, LocaleState>(
                          builder: (context, localeState) {
                            final isAr = localeState is LocaleChangedtoArabic;
                            final isDark = Theme.of(context).brightness == Brightness.dark;
                            final priceColor = isDark ? KsecondaryColor : KprimaryColor;
                            return Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${cartItemEntity.calculateTotalPrice()}',
                                    style: AppTextStyles.cairoBold.copyWith(
                                      fontSize: 16,
                                      color: priceColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: isAr ? 'جنيه' : 'EGP',
                                    style: AppTextStyles.cairoBold.copyWith(
                                      fontSize: 16,
                                      color: priceColor,
                                    ),
                                  ),
                                ],
                              ),
                              textDirection: isAr
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

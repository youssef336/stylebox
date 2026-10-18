// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/payment_item.dart';

import '../../../../../core/utils/text_styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../domains/entities/order_entity.dart';

class OrderSummaryWidget extends StatelessWidget {
  const OrderSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaymentItem(
      title: S.of(context)!.orderSummaryWidgetTitle,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                S.of(context)!.orderSummaryWidgetSubtotal,
                style: AppTextStyles.cairoRegular.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: context
                          .read<OrderEntity>()
                          .cartEntites
                          .calculateTotalPrice()
                          .toString(),
                      style: AppTextStyles.bodyBaseSemibold.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: S.of(context)!.checkOutViewShipingPrice,
                      style: AppTextStyles.bodyBaseSemibold.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                S.of(context)!.orderSummaryWidgetShipping,
                style: AppTextStyles.cairoRegular.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: context
                          .read<OrderEntity>()
                          .calculateShipingCost()
                          .toString(),
                      style: AppTextStyles.cairoRegular.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextSpan(
                      text: S.of(context)!.checkOutViewShipingPrice,
                      style: AppTextStyles.cairoRegular.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),

          Visibility(
            visible: context.read<OrderEntity>().appliedDiscount != 0,
            child: Row(
              children: [
                Text(
                  "discount :",
                  style: AppTextStyles.cairoRegular.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "-",

                        style: AppTextStyles.cairoRegular.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      TextSpan(
                        text: context
                            .read<OrderEntity>()
                            .appliedDiscount
                            .toString(),

                        style: AppTextStyles.cairoRegular.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      TextSpan(
                        text: S.of(context)!.checkOutViewShipingPrice,
                        style: AppTextStyles.cairoRegular.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(
            color: Theme.of(context).dividerColor,
            indent: 32,
            endIndent: 32,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                S.of(context)!.orderSummaryWidgetTotal,
                style: AppTextStyles.cairoBold.copyWith(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: context
                          .read<OrderEntity>()
                          .calculateTotalPriceAfterDiscountAndShiping()
                          .toString(),
                      style: AppTextStyles.cairoBold.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: S.of(context)!.checkOutViewShipingPrice,
                      style: AppTextStyles.cairoBold.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

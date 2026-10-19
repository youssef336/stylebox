import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/widgets/empty_state_widget.dart';
import 'package:stylebox/features/check_out/presentation/views/check_out_view.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart/cart_cubit.dart';
import 'package:stylebox/features/home/presentation/views/widgets/cart_item_list.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../manager/cubits/cart_item/cart_item_cubit.dart';

/// Shopping bag: large left-aligned title with an item counter, item cards,
/// and a docked summary sheet with the totals and the checkout action.
class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final cart = context.watch<CartCubit>().cartEntites;
    // Rebuild totals when a quantity changes.
    context.watch<CartItemCubit>();
    final isEmpty = cart.cartItems.isEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            KhorzontalPadding,
            18,
            KhorzontalPadding,
            8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                locale.cartViewHeader,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(width: 10),
              if (!isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    locale.cartItemsCount('${cart.calculateTotalCount()}'),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              if (isEmpty)
                SliverToBoxAdapter(
                  child: EmptyStateWidget(
                    icon: Icons.shopping_bag_outlined,
                    title: locale.emptyCartTitle,
                    subtitle: locale.emptyCartSubtitle,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    KhorzontalPadding,
                    8,
                    KhorzontalPadding,
                    16,
                  ),
                  sliver: CartItemList(cartItems: cart.cartItems),
                ),
            ],
          ),
        ),
        if (!isEmpty) _SummarySheet(total: cart.calculateTotalPrice()),
        if (isEmpty) SizedBox(height: MediaQuery.paddingOf(context).bottom),
      ],
    );
  }
}

class _SummarySheet extends StatelessWidget {
  const _SummarySheet({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    String money(double v) =>
        '${v.toStringAsFixed(v % 1 == 0 ? 0 : 2)} ${locale.bagCurrencySuffix}';

    Widget line(String label, String value, {bool strong = false}) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: strong ? 16 : 14,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
              color: strong ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: strong ? 20 : 14,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
              color: strong ? scheme.primary : scheme.onSurface,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.paddingOf(context).bottom + 14,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: KprimaryColorDark.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          line(locale.cartSubtotal, money(total)),
          Divider(height: 16, color: Theme.of(context).dividerColor),
          line(locale.cartTotal, money(total), strong: true),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                CheckOutView.routeName,
                arguments: {
                  'cartItems': context.read<CartCubit>().cartEntites,
                },
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locale.cartCheckout),
                  const SizedBox(width: 10),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_back_rounded
                        : Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: unchecked_use_of_nullable_value, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/core/services/visa_card_prefs_services.dart';
import 'package:stylebox/features/check_out/domains/entities/checkout_payment_method.dart';
import 'package:stylebox/features/check_out/domains/entities/order_entity.dart';

import 'package:provider/provider.dart';

import '../../../../../generated/l10n.dart';
import 'payment_method_selector_widget.dart';

class ShipinngSection extends StatefulWidget {
  const ShipinngSection({super.key, required this.onSelectionChanged});
  final VoidCallback onSelectionChanged;

  @override
  State<ShipinngSection> createState() => _ShipinngSectionState();
}

class _ShipinngSectionState extends State<ShipinngSection>
    with AutomaticKeepAliveClientMixin {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final m = context.read<OrderEntity>().paymentMethod;
      if (m != null) {
        setState(() {
          selectedIndex = m.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = context.read<OrderEntity>();
    final cartTotal = order.cartEntites.calculateTotalPrice();
    final codTotal = cartTotal + 40;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          PaymentMethodSelectorWidget(
            selectedIndex: selectedIndex,
            onMethodSelected: (index) {
              setState(() {
                selectedIndex = index;
                if (index == 0) {
                  order.paymentMethod = CheckoutPaymentMethod.cashOnDelivery;
                } else if (index == 1) {
                  order.paymentMethod = CheckoutPaymentMethod.paypal;
                } else if (index == 2) {
                  order.paymentMethod = CheckoutPaymentMethod.visa;
                }
              });
              widget.onSelectionChanged();
            },
            methods: const [
              CheckoutPaymentMethod.cashOnDelivery,
              CheckoutPaymentMethod.paypal,
              CheckoutPaymentMethod.visa,
            ],
            titles: [
              S.of(context)!.checkOutViewShipingTitle1,
              S.of(context)!.checkOutViewShipingTitle2,
              S.of(context)!.checkOutViewShipingTitle3,
            ],
            subtitles: [
              S.of(context)!.checkOutViewShipingSubtitle1,
              S.of(context)!.checkOutViewShipingSubtitle2,
              S.of(context)!.checkOutViewShipingSubtitle3,
            ],
            prices: [
              '$codTotal ${S.of(context)!.checkOutViewShipingPrice}',
              '$cartTotal ${S.of(context)!.checkOutViewShipingPrice}',
              '$cartTotal ${S.of(context)!.checkOutViewShipingPrice}',
            ],
          ),
          if (selectedIndex == 2 && VisaCardPrefsServices.hasSavedCard()) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? KdarkModeCardColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? KdarkModeTextSecondary.withOpacity(0.15)
                      : KdividerColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S
                          .of(context)!
                          .visaDetailsEndsWith(
                            VisaCardPrefsServices.loadCard()!.last4,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cairoRegular.copyWith(
                        color: isDark
                            ? KdarkModeTextColor
                            : KlightModeTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: S.of(context)!.visaDetailsDelete,
                    color: isDark
                        ? KdarkModeTextSecondary
                        : KlightModeTextSecondary,
                    onPressed: () async {
                      await VisaCardPrefsServices.clearCard();
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

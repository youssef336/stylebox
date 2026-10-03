import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/generated/l10n.dart';
import 'package:provider/provider.dart';

import 'package:stylebox/features/check_out/domains/entities/order_entity.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/payment_item.dart';
import 'package:stylebox/features/check_out/domains/entities/checkout_payment_method.dart';

class OnlinePaymentMethodSection extends StatefulWidget {
  const OnlinePaymentMethodSection({
    super.key,
    required this.visaFormKey,
    required this.cardHolderController,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
    required this.onPaymentMethodChanged,
  });

  final GlobalKey<FormState> visaFormKey;
  final TextEditingController cardHolderController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;
  final VoidCallback onPaymentMethodChanged;

  @override
  State<OnlinePaymentMethodSection> createState() =>
      _OnlinePaymentMethodSectionState();
}

class _OnlinePaymentMethodSectionState
    extends State<OnlinePaymentMethodSection> {
  @override
  Widget build(BuildContext context) {
    final order = context.read<OrderEntity>();
    final isCashOnDelivery =
        order.paymentMethod == CheckoutPaymentMethod.cashOnDelivery;
    final savedCardLast4 = Prefs.getString(KSavedCardLast4);
    final hasSavedCard = savedCardLast4.isNotEmpty;

    return PaymentItem(
      title: S.of(context)!.checkOutViewPaymentMethodTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<String>(
            segments: [
              ButtonSegment<String>(
                value: 'paypal',
                label: Text(S.of(context)!.checkOutViewPayWithPayPal),
              ),
              ButtonSegment<String>(
                value: 'visa',
                label: Text(S.of(context)!.checkOutViewPayWithVisa),
              ),
            ],
            selected: {order.onlinePaymentMethod},
            onSelectionChanged: isCashOnDelivery
                ? null
                : (selection) {
                    setState(() {
                      order.onlinePaymentMethod = selection.first;
                    });
                    widget.onPaymentMethodChanged();
                  },
          ),
          if (!isCashOnDelivery && order.onlinePaymentMethod == 'visa') ...[
            const SizedBox(height: 8),
            if (hasSavedCard) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context)!.checkOutViewSavedCardTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(widget.cardHolderController.text),
                    Text('**** **** **** $savedCardLast4'),
                    Text(widget.expiryDateController.text),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
                        TextButton(
                          onPressed: () {
                            widget.cardNumberController.text =
                                '**** **** **** $savedCardLast4';
                            widget.onPaymentMethodChanged();
                          },
                          child: Text(S.of(context)!.checkOutViewUseSavedCard),
                        ),
                        TextButton(
                          onPressed: () {
                            Prefs.setString(KSavedCardHolderName, '');
                            Prefs.setString(KSavedCardLast4, '');
                            Prefs.setString(KSavedCardExpiryDate, '');
                            widget.cardHolderController.clear();
                            widget.cardNumberController.clear();
                            widget.expiryDateController.clear();
                            widget.cvvController.clear();
                            setState(() {});
                            widget.onPaymentMethodChanged();
                          },
                          child: Text(S.of(context)!.checkOutViewDeleteCard),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Form(
              key: widget.visaFormKey,
              child: Column(
                children: [
                  _VisaTextField(
                    controller: widget.cardHolderController,
                    hintText: S.of(context)!.checkOutViewCardHolderName,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context)!.checkOutViewEnterCardHolderName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _VisaTextField(
                    controller: widget.cardNumberController,
                    hintText: hasSavedCard
                        ? S.of(context)!.checkOutViewCardNumberOrSaved
                        : S.of(context)!.checkOutViewCardNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9 *]')),
                    ],
                    validator: (value) {
                      final digits = (value ?? '')
                          .replaceAll(' ', '')
                          .replaceAll('*', '');
                      if (digits.length < 13 || digits.length > 19) {
                        if ((value ?? '').contains('****') && hasSavedCard) {
                          return null;
                        }
                        return S.of(context)!.checkOutViewInvalidCardNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _VisaTextField(
                          controller: widget.expiryDateController,
                          hintText: S.of(context)!.visaDetailsExpiry,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9/]'),
                            ),
                            _ExpiryDateTextFormatter(),
                          ],
                          validator: (value) {
                            final expiry = value?.trim() ?? '';
                            if (!RegExp(
                              r'^(0[1-9]|1[0-2])\/\d{2}$',
                            ).hasMatch(expiry)) {
                              return S
                                  .of(context)!
                                  .checkOutViewInvalidExpiryDate;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _VisaTextField(
                          controller: widget.cvvController,
                          hintText: S.of(context)!.visaDetailsCvv,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: (value) {
                            final cvv = value?.trim() ?? '';
                            if (cvv.length < 3 || cvv.length > 4) {
                              return S.of(context)!.checkOutViewInvalidCvv;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      S.of(context)!.checkOutViewOnlySaveLast4,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VisaTextField extends StatelessWidget {
  const _VisaTextField({
    required this.controller,
    required this.hintText,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}

class _ExpiryDateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length > 4) {
      return oldValue;
    }

    var text = digits;
    if (digits.length > 2) {
      text = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

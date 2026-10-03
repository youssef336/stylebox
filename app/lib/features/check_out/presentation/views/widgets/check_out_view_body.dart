// ignore_for_file: avoid_print

// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

import 'package:stylebox/constant.dart';
import 'package:stylebox/core/helper_functions/build_error_bar.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/widgets/custom_buttom.dart';
import 'package:stylebox/core/services/visa_card_prefs_services.dart';
import 'package:stylebox/features/check_out/domains/entities/PaypalPaymentEntity/PaypalPaymentEntity.dart'
    show PaypalPaymentEntity;
import 'package:stylebox/features/check_out/domains/entities/checkout_payment_method.dart';
import 'package:stylebox/features/check_out/domains/entities/order_entity.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/visa_details_view.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/check_out_stage.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_key.dart';
import '../../../../../generated/l10n.dart';
import '../../manager/cubits/order_cubit/order_cubit.dart';
import 'check_out_steps_page_view.dart';

class CheckOutViewBody extends StatefulWidget {
  const CheckOutViewBody({super.key});

  @override
  State<CheckOutViewBody> createState() => _CheckOutViewBodyState();
}

class _CheckOutViewBodyState extends State<CheckOutViewBody> {
  late PageController pageController;
  final GlobalKey<FormState> _visaFormKey = GlobalKey<FormState>();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _addressEmailController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _addressCityController = TextEditingController();
  final TextEditingController _addressFloorController = TextEditingController();
  final TextEditingController _addressPhoneController = TextEditingController();

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    _loadSavedCardData();
    _loadSavedAddressData();

    pageController.addListener(_handlePageChanged);
    currentPageindex = 0;
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _addressNameController.dispose();
    _addressEmailController.dispose();
    _addressLineController.dispose();
    _addressCityController.dispose();
    _addressFloorController.dispose();
    _addressPhoneController.dispose();
    super.dispose();
  }

  int currentPageindex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addressAutoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CheckOutStage(
            onTap: (index) {
              if (index == 0) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                );
              } else if (index == 1) {
                final method = context.read<OrderEntity>().paymentMethod;
                if (method != null) {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.fastOutSlowIn,
                  );
                } else {
                  showErrorBar(
                    context,
                    S.of(context)!.checkOutViewShipingError,
                  );
                }
              } else {
                _handleAddressSectionValidation();
              }
            },
            pageController: pageController,
            currentPageindex: currentPageindex,
          ),

          Expanded(
            child: CheckOutStepsPageView(
              autoValidateMode: _addressAutoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              formKey: _formKey,
              pageController: pageController,
              visaFormKey: _visaFormKey,
              cardHolderController: _cardHolderController,
              cardNumberController: _cardNumberController,
              expiryDateController: _expiryDateController,
              cvvController: _cvvController,
              onPaymentMethodChanged: () {
                if (mounted) {
                  setState(() {});
                }
              },
              onShippingMethodChanged: () {
                if (mounted) {
                  setState(() {});
                }
              },
              addressNameController: _addressNameController,
              addressEmailController: _addressEmailController,
              addressLineController: _addressLineController,
              addressCityController: _addressCityController,
              addressFloorController: _addressFloorController,
              addressPhoneController: _addressPhoneController,
            ),
          ),
          CustomButtom(
            text: getNextButtonText(currentPageindex),
            onPressed: () {
              if (currentPageindex == 0) {
                _handleShipinngSectionValidation(context);
              } else if (currentPageindex == 1) {
                _handleAddressSectionValidation();
              } else {
                _processPayment();
              }
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _handleShipinngSectionValidation(BuildContext context) {
    final order = context.read<OrderEntity>();
    if (order.paymentMethod == null) {
      showErrorBar(context, S.of(context)!.checkOutViewShipingError);
      return;
    }
    if (order.paymentMethod == CheckoutPaymentMethod.visa) {
      if (VisaCardPrefsServices.hasSavedCard()) {
        pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
        return;
      }
      Navigator.of(context)
          .push<bool>(
            MaterialPageRoute(builder: (_) => const VisaDetailsView()),
          )
          .then((saved) {
            if (!mounted || saved != true) return;
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 600),
              curve: Curves.fastOutSlowIn,
            );
          });
      return;
    }
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
    );
  }

  String getNextButtonText(int currentPageindex) {
    final method = context.read<OrderEntity>().paymentMethod;
    switch (currentPageindex) {
      case 0:
      case 1:
        return S.of(context)!.checkOutViewNext;
      case 2:
        if (method == CheckoutPaymentMethod.paypal) {
          return S.of(context)!.checkOutViewPayWithPayPal;
        }
        if (method == CheckoutPaymentMethod.visa) {
          return S.of(context)!.checkOutViewConfirmPaymentVisa;
        }
        return S.of(context)!.checkOutViewConfirmOrderCash;
      default:
        return S.of(context)!.checkOutViewNext;
    }
  }

  void _handlePageChanged() {
    final page = pageController.page;
    if (page == null) return;

    final newPageIndex = page.round();
    if (newPageIndex == currentPageindex || !mounted) return;

    setState(() {
      currentPageindex = newPageIndex;
    });
  }

  Future<void> _handleAddressSectionValidation() async {
    final formState = _formKey.currentState;
    if (formState == null) return;

    if (!formState.validate()) {
      if (!_addressAutoValidate && mounted) {
        setState(() {
          _addressAutoValidate = true;
        });
      }
      return;
    }

    formState.save();
    await _saveAddressLocally();
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _loadSavedCardData() {
    final savedCard = VisaCardPrefsServices.loadCard();
    if (savedCard == null) return;

    _cardHolderController.text = savedCard.cardHolderName;
    _cardNumberController.text = '**** **** **** ${savedCard.last4}';
    _expiryDateController.text = savedCard.expiry;
  }

  void _loadSavedAddressData() {
    _addressNameController.text = Prefs.getString(KSavedAddressName);
    _addressEmailController.text = Prefs.getString(KSavedAddressEmail);
    _addressLineController.text = Prefs.getString(KSavedAddressLine);
    _addressCityController.text = Prefs.getString(KSavedAddressCity);
    _addressFloorController.text = Prefs.getString(KSavedAddressFloor);
    _addressPhoneController.text = Prefs.getString(KSavedAddressPhone);
  }

  Future<void> _saveAddressLocally() async {
    await Prefs.setString(
      KSavedAddressName,
      _addressNameController.text.trim(),
    );
    await Prefs.setString(
      KSavedAddressEmail,
      _addressEmailController.text.trim(),
    );
    await Prefs.setString(
      KSavedAddressLine,
      _addressLineController.text.trim(),
    );
    await Prefs.setString(
      KSavedAddressCity,
      _addressCityController.text.trim(),
    );
    await Prefs.setString(
      KSavedAddressFloor,
      _addressFloorController.text.trim(),
    );
    await Prefs.setString(
      KSavedAddressPhone,
      _addressPhoneController.text.trim(),
    );
  }

  void _processPayment() {
    final orderEntity = context.read<OrderEntity>();
    final addOrder = context.read<OrderCubit>();
    final method = orderEntity.paymentMethod;

    if (method == CheckoutPaymentMethod.cashOnDelivery) {
      addOrder.addOrder(order: orderEntity);
      return;
    }

    if (method == CheckoutPaymentMethod.visa) {
      if (!VisaCardPrefsServices.hasSavedCard()) {
        showErrorBar(context, S.of(context)!.checkOutViewVisaMissing);
        return;
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context)!.checkOutViewConfirmPaymentVisa),
            content: Text(S.of(context)!.checkOutViewConfirmPaymentVisaMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.of(context)!.profileViewLogoutText3,
                ), // "إلغاء" Cancel
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  addOrder.addOrder(order: orderEntity);
                },
                child: Text(
                  S.of(context)!.checkOutViewConfirmPaymentVisa,
                ), // "تأكيد الدفع" Confirm
              ),
            ],
          );
        },
      );
      return;
    }

    if (method == CheckoutPaymentMethod.paypal) {
      final paypalPaymentEntity = PaypalPaymentEntity.fromEntity(orderEntity);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Theme(
            data: ThemeData.light(),
            child: PaypalCheckoutView(
              sandboxMode: true,
              clientId: KPaypalClientId,
              secretKey: KPaypalSecrtKey,
              transactions: [paypalPaymentEntity.toJson()],
              note: "Contact us for any questions on your order.",
              onSuccess: (Map params) async {
                print("onSuccess: $params");
                Navigator.pop(context);
                showErrorBar(context, S.of(context)!.paymentSuccessMessage);
                addOrder.addOrder(order: orderEntity);
              },
              onError: (error) {
                print("onError: $error");
                showErrorBar(context, S.of(context)!.paymentErrorMessage);
                Navigator.pop(context);
              },
              onCancel: () {
                print('cancelled:');
              },
            ),
          ),
        ),
      );
    }
  }
}

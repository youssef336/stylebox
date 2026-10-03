import 'package:flutter/material.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/address_input_section.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/payment_section.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/shipinng_section.dart';

class CheckOutStepsPageView extends StatelessWidget {
  const CheckOutStepsPageView({
    super.key,
    required this.pageController,
    required this.formKey,
    required this.autoValidateMode,
    required this.visaFormKey,
    required this.cardHolderController,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
    required this.onPaymentMethodChanged,
    required this.onShippingMethodChanged,
    required this.addressNameController,
    required this.addressEmailController,
    required this.addressLineController,
    required this.addressCityController,
    required this.addressFloorController,
    required this.addressPhoneController,
  });

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormState> visaFormKey;
  final TextEditingController cardHolderController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;
  final VoidCallback onPaymentMethodChanged;
  final VoidCallback onShippingMethodChanged;
  final TextEditingController addressNameController;
  final TextEditingController addressEmailController;
  final TextEditingController addressLineController;
  final TextEditingController addressCityController;
  final TextEditingController addressFloorController;
  final TextEditingController addressPhoneController;

  final AutovalidateMode autoValidateMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: getPages().length,
        itemBuilder: (context, index) {
          return getPages()[index];
        },
      ),
    );
  }

  List<Widget> getPages() {
    return [
      ShipinngSection(onSelectionChanged: onShippingMethodChanged),
      AddressInputSection(
        autoValidateMode: autoValidateMode,
        formKey: formKey,
        nameController: addressNameController,
        emailController: addressEmailController,
        addressController: addressLineController,
        cityController: addressCityController,
        floorController: addressFloorController,
        phoneController: addressPhoneController,
      ),
      PaymentSection(pageController: pageController),
    ];
  }
}

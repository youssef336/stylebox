// ignore_for_file: must_be_immutable
// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';

import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/widgets/custom_text_feild.dart'
    show CustomTextFormFeild, CustomTextFormFeildforCopon;
import 'package:stylebox/features/check_out/domains/entities/order_entity.dart';

import 'package:provider/provider.dart';

import '../../../../../generated/l10n.dart';

class AddressInputSection extends StatelessWidget {
  AddressInputSection({
    super.key,
    required this.formKey,
    required this.autoValidateMode,
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.cityController,
    required this.floorController,
    required this.phoneController,
  });

  final GlobalKey<FormState> formKey;
  String? code;
  final AutovalidateMode autoValidateMode;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController floorController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          children: [
            const SizedBox(height: 24),
            CustomTextFormFeild(
              controller: nameController,
              onSaved: (value) {
                context.read<OrderEntity>().shipingAddressEntity.name = value!;
              },
              hintText: S.of(context)!.addressInputSectionName,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormFeild(
              controller: emailController,
              onSaved: (value) {
                context.read<OrderEntity>().shipingAddressEntity.email = value!;
              },
              hintText: S.of(context)!.addressInputSectionEmail,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormFeild(
              controller: addressController,
              onSaved: (value) {
                context.read<OrderEntity>().shipingAddressEntity.address =
                    value!;
              },
              hintText: S.of(context)!.addressInputSectionAddress,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormFeild(
              controller: cityController,
              onSaved: (value) {
                context.read<OrderEntity>().shipingAddressEntity.city = value!;
              },
              hintText: S.of(context)!.addressInputSectionCity,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormFeild(
              controller: floorController,
              onSaved: (value) {
                context.read<OrderEntity>().shipingAddressEntity.floor = value!;
              },
              hintText: S.of(context)!.addressInputSectionFloor,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextFormFeild(
              controller: phoneController,
              onSaved: (value) {
                context.read<OrderEntity>().shipingAddressEntity.phone = value!;
              },
              hintText: S.of(context)!.addressInputSectionPhone,
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            MyWidget(),
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
  final TextEditingController _controller = TextEditingController();

  void _applyCouponCode(BuildContext context, OrderEntity order, String code) {
    order.applyCouponCode(code);
    final discount = order.calulateShipingDiscount();

    if (discount > 0) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context)!.couponDiscountApplied(discount.toString())),
          backgroundColor: Colors.green,
        ),
      );

      // Reset points after successful coupon application
      Prefs.setInt(Kpoints, 0);

      // Clear the text field
      _controller.clear();

      // Remove focus from the text field
      FocusScope.of(context).unfocus();
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context)!.invalidCouponError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = context.read<OrderEntity>();
    // final notification = order.notificationEntity;

    // Return empty SizedBox if no notification is available
    // if (notification == null) {
    //   return const SizedBox.shrink();
    // }

    // Only show the coupon input if there's a valid notification
    return Row(
      children: [
        Expanded(
          child: CustomTextFormFeildforCopon(
            controller: _controller,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            hintText: S.of(context)!.couponCodeHint,

            suffixIcon: IconButton(
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              onPressed: () {
                final code = _controller.text.trim();
                if (code.isNotEmpty) {
                  _applyCouponCode(context, order, code);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

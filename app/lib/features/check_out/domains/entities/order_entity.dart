import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/features/check_out/domains/entities/checkout_payment_method.dart';
import 'package:stylebox/features/check_out/domains/entities/shiping_address_entity.dart';
import 'package:stylebox/features/home/domain/entities/cart_entites.dart';

class OrderEntity {
  final String uID;
  final CartEntites cartEntites;
  CheckoutPaymentMethod? paymentMethod;
  String onlinePaymentMethod;
  String? cardHolderName;
  String? cardNumber;
  String? expiryDate;

  // final List<NotificationEntity>? notificationEntity;
  ShipingAddressEntity shipingAddressEntity = ShipingAddressEntity();
  double appliedDiscount = 0; // internal discount state

  OrderEntity({
    // required this.notificationEntity,
    required this.cartEntites,
    this.paymentMethod,
    required this.uID,
    this.onlinePaymentMethod = 'paypal',
    this.cardHolderName = '',
    this.cardNumber = '',
    this.expiryDate = '',
  });

  bool get payWithCash => paymentMethod == CheckoutPaymentMethod.cashOnDelivery;

  void applyCouponCode(String code) {
    // Reset discount at the start
    appliedDiscount = 0;

    // Get the stored coupon code and discount from SharedPreferences
    final storedCoupon = Prefs.getString(KCupon);
    final storedDiscount = Prefs.getInt(KCuponDiscount);

    // Validate the entered code against the stored coupon
    if (storedCoupon.isNotEmpty &&
        storedDiscount > 0 &&
        code.toUpperCase() == storedCoupon.toUpperCase()) {
      // Apply the discount percentage to the total price
      appliedDiscount = calculateTotalPriceforCopon() * (storedDiscount / 100);
    }
  }

  double calculateShipingCost() {
    return paymentMethod == CheckoutPaymentMethod.cashOnDelivery ? 40 : 0;
  }

  double calulateShipingDiscount() {
    return appliedDiscount;
  }

  double calculateTotalPriceforCopon() {
    return cartEntites.calculateTotalPrice() + calculateShipingCost();
  }

  double calculateTotalPriceAfterDiscountAndShiping() {
    return cartEntites.calculateTotalPrice() +
        calculateShipingCost() -
        calulateShipingDiscount();
  }
}

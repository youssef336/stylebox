// Renders the redesigned customer screens to docs/screenshots/app_*.png.
//
//   flutter test --dart-define=SCREENSHOTS=true test/screenshots
//
// Skipped in the default `flutter test` run.
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stylebox/core/entities/demo_products.dart';
import 'package:stylebox/core/helper_functions/restaurant_from_product.dart';
import 'package:stylebox/features/auth/presentation/views/Sign_in_view.dart';
import 'package:stylebox/features/auth/presentation/views/sign_up_view.dart';
import 'package:stylebox/features/check_out/presentation/views/check_out_view.dart';
import 'package:stylebox/features/home/domain/entities/cart_entites.dart';
import 'package:stylebox/features/home/domain/entities/cart_item_entity.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart/cart_cubit.dart';
import 'package:stylebox/features/home/presentation/views/bagel_mystery_bag_screen.dart';
import 'package:stylebox/features/home/presentation/views/main_view.dart';
import 'package:stylebox/features/onBoarding/presentation/views/on_boarding.dart';

import 'screenshot_harness.dart';

CartCubit _filledCart() {
  final cart = CartCubit();
  cart.addProductToCart(demoProducts[0]);
  cart.addProductToCart(demoProducts[2]);
  cart.addProductToCart(demoProducts[2]);
  cart.addProductToCart(demoProducts[3]);
  return cart;
}

Future<void> _tapBottomTab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  setUpAll(loadAppFonts);
  setUp(() async {
    await setUpFakes();
    statusBarOnDark = false;
  });

  group('customer app screenshots', skip: !kCaptureScreenshots, () {
    testWidgets('onboarding', (tester) async {
      usePhoneSurface(tester);
      statusBarOnDark = true;
      await tester.pumpWidget(buildTestApp(home: const OnBoarding()));
      await capture(tester, 'app_onboarding');
    });

    testWidgets('login', (tester) async {
      usePhoneSurface(tester);
      statusBarOnDark = true;
      await tester.pumpWidget(buildTestApp(home: const SigninView()));
      await capture(tester, 'app_login');
    });

    testWidgets('signup', (tester) async {
      usePhoneSurface(tester);
      statusBarOnDark = true;
      await tester.pumpWidget(buildTestApp(home: const SignUpView()));
      await capture(tester, 'app_signup');
    });

    testWidgets('home', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(
        buildTestApp(home: const MainView(), cart: _filledCart()),
      );
      await capture(tester, 'app_home');

      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, -820),
      );
      await tester.pump(const Duration(seconds: 1));
      await capture(tester, 'app_home_grid');
    });

    testWidgets('home (Arabic, RTL)', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(
        buildTestApp(
          home: const MainView(),
          cart: _filledCart(),
          locale: const Locale('ar'),
        ),
      );
      await capture(tester, 'app_home_ar');
    });

    testWidgets('product details', (tester) async {
      usePhoneSurface(tester);
      statusBarOnDark = true;
      await tester.pumpWidget(
        buildTestApp(
          home: Builder(
            builder: (context) => BagelMysteryBagScreen(
              product: demoProducts[0],
              restaurant: restaurantFromProduct(context, demoProducts[0]),
            ),
          ),
        ),
      );
      await capture(tester, 'app_product_details');
    });

    testWidgets('cart', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(
        buildTestApp(home: const MainView(), cart: _filledCart()),
      );
      await _tapBottomTab(tester, 'Cart');
      await capture(tester, 'app_cart');
    });

    testWidgets('checkout', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(
        buildTestApp(
          home: CheckOutView(
            cartItems: CartEntites([
              CartItemEntity(productEntity: demoProducts[0], count: 1),
              CartItemEntity(productEntity: demoProducts[2], count: 2),
            ]),
          ),
        ),
      );
      await settle(tester);
      await tester.tap(find.text('Cash On Delivery'));
      await capture(tester, 'app_checkout');
    });

    testWidgets('profile', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(
        buildTestApp(home: const MainView(), cart: _filledCart()),
      );
      await _tapBottomTab(tester, 'Profile');
      await capture(tester, 'app_profile');
    });
  });
}

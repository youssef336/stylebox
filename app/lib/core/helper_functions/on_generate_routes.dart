import 'package:flutter/material.dart';
import 'package:stylebox/core/entities/demo_products.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'package:stylebox/features/auth/presentation/views/Sign_in_view.dart';
import 'package:stylebox/features/auth/presentation/views/sign_up_view.dart';
import 'package:stylebox/features/check_out/presentation/views/check_out_view.dart';
import 'package:stylebox/features/home/domain/entities/cart_entites.dart';
import 'package:stylebox/features/home/domain/entities/cart_item_entity.dart';
import 'package:stylebox/features/home/presentation/views/main_view.dart';
import 'package:stylebox/features/home/presentation/views/bagel_mystery_bag_screen.dart'; // ✅ added
import 'package:stylebox/features/home/presentation/views/widgets/profile_viewLanguage_page.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_avtar_page.dart';
import 'package:stylebox/features/home/presentation/views/widgets/profile_view_points_page.dart';
import 'package:stylebox/features/onBoarding/presentation/views/on_boarding.dart';
import 'package:stylebox/features/home/presentation/views/widgets/bag_details_view.dart';
import 'package:stylebox/features/ai_chat/presentation/views/ai_chat_view.dart';
import 'package:stylebox/features/food_scan/presentation/views/food_scan_view.dart';
import 'package:stylebox/features/splash/presentation/views/splash_view.dart';
import 'package:stylebox/features/stores_map/presentation/views/stores_map_view.dart';
import 'package:stylebox/generated/l10n.dart';

class _ErrorPage extends StatelessWidget {
  const _ErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(S.of(context)!.errorPageNotFound)),
    );
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AiChatView.routeName:
      final args = settings.arguments;
      String? initialMessage;
      String? initialDisplayMessage;
      if (args is Map) {
        final v = args['initialMessage'];
        if (v is String) initialMessage = v;
        final d = args['initialDisplayMessage'];
        if (d is String) initialDisplayMessage = d;
      }
      return MaterialPageRoute(
        builder: (_) => AiChatView(
          initialMessage: initialMessage,
          initialDisplayMessage: initialDisplayMessage,
        ),
      );
    case FoodScanView.routeName:
      return MaterialPageRoute(builder: (_) => const FoodScanView());
    case StoresMapView.routeName:
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (_) => StoresMapView(
          focusStoreId: args is Map ? args['storeId'] as String? : null,
          showRoute: args is Map && args['showRoute'] == true,
        ),
      );
    case '/bagDetails':
      return MaterialPageRoute(builder: (_) => const BagDetailsView());
    case MainView.routeName:
      return MaterialPageRoute(builder: (_) => const MainView());

    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case SigninView.routeName:
      return MaterialPageRoute(builder: (_) => const SigninView());
    case SignUpView.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpView());
    case OnBoarding.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoarding());
    case ProfileViewLanguagePage.routeName:
      return MaterialPageRoute(builder: (_) => const ProfileViewLanguagePage());
    case ProfileViewAvtarPage.routeName:
      return MaterialPageRoute(builder: (_) => const ProfileViewAvtarPage());
    case CheckOutView.routeName:
      final args = settings.arguments;
      final CartEntites cartItems;
      if (args is Map<String, dynamic> && args['cartItems'] is CartEntites) {
        cartItems = args['cartItems'] as CartEntites;
      } else {
        cartItems = CartEntites([
          CartItemEntity(productEntity: demoProducts.first, count: 1),
        ]);
      }
      return MaterialPageRoute(
        builder: (_) => CheckOutView(cartItems: cartItems),
      );
    case BagDetailsView.routeName:
      return MaterialPageRoute(builder: (_) => const BagDetailsView());
    case ProfileViewPointsPage.routeName:
      return MaterialPageRoute(builder: (_) => const ProfileViewPointsPage());
    case BagelMysteryBagScreen.routeName:
      final arguments = settings.arguments;
      ProductEntity? product;
      RestaurantEntity? restaurant;

      if (arguments is ProductEntity) {
        product = arguments;
      } else if (arguments is Map) {
        final productValue = arguments['product'];
        final restaurantValue = arguments['restaurant'];
        if (productValue is ProductEntity) {
          product = productValue;
        }
        if (restaurantValue is RestaurantEntity) {
          restaurant = restaurantValue;
        }
      }

      return MaterialPageRoute(
        builder: (_) => BagelMysteryBagScreen(
          product:
              product ??
              ProductEntity(
                imageUrl: '',
                documentId: 'default',
                nameEn: 'Style Box',
                nameAr: 'ستايل بوكس',
                code: 'default',
                description: 'A surprise box of clothes',
                price: 0,
                isFeatured: false,
                reviews: const [],
                expirationsMonths: 1,
                isOrganic: false,
                numbersOfCalories: 0,
                avgRating: 0,
                unitAmount: 1,
              ),
          restaurant: restaurant,
        ),
      );

    default:
      return MaterialPageRoute(builder: (_) => const _ErrorPage());
  }
}

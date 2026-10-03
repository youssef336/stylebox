import 'package:flutter/widgets.dart';

import '../cart_view.dart';
import '../products_view.dart';
import '../profile_view.dart';
import 'home_view.dart';
import '../../../../food_scan/presentation/views/food_scan_view.dart';

class MainViewBody extends StatelessWidget {
  const MainViewBody({super.key, required this.currentViewIndex});

  final int currentViewIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IndexedStack(
        index: currentViewIndex,
        children: [
          const HomeView(),
          const FoodScanView(),
          const ProductsView(),
          const CartView(),
          const ProfileView(),
        ],
      ),
    );
  }
}

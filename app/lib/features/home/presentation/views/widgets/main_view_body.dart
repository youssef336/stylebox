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
    // The tab bar is drawn over the body (extendBody), so scrolling tabs let
    // content run underneath it and add the bar height as inner padding.
    final barInset = MediaQuery.paddingOf(context).bottom;
    Widget inset(Widget child) =>
        Padding(padding: EdgeInsets.only(bottom: barInset), child: child);

    return SafeArea(
      bottom: false,
      child: IndexedStack(
        index: currentViewIndex,
        children: [
          const HomeView(),
          inset(const FoodScanView()),
          inset(const ProductsView()),
          const CartView(),
          const ProfileView(),
        ],
      ),
    );
  }
}

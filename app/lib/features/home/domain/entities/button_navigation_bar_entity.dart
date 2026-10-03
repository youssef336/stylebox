import 'package:flutter/widgets.dart';
import 'package:stylebox/core/utils/assets.dart';
import 'package:stylebox/generated/l10n.dart';

class ButtonNavigationBarEntity {
  final String activeImagePath;
  final String inactiveImagePath;
  final String name;

  ButtonNavigationBarEntity({
    required this.activeImagePath,
    required this.inactiveImagePath,
    required this.name,
  });
}

List<ButtonNavigationBarEntity> getButtonNavigationBarItems(
  BuildContext context,
) {
  return [
    ButtonNavigationBarEntity(
      activeImagePath: AssetsData.light().images.bold.home_svg,
      inactiveImagePath: AssetsData.light().images.outline.home_svg,
      name: S.of(context)!.buttonNavigationBarEntityHome,
    ),
    ButtonNavigationBarEntity(
      activeImagePath: 'assets/images/bold/scan.svg',
      inactiveImagePath: 'assets/images/outline/scan.svg',
      name: S.of(context)!.navScan,
    ),
    ButtonNavigationBarEntity(
      activeImagePath: AssetsData.light().images.bold.products_svg,
      inactiveImagePath: AssetsData.light().images.outline.products_svg,
      name: S.of(context)!.buttonNavigationBarEntityProducts,
    ),
    ButtonNavigationBarEntity(
      activeImagePath: AssetsData.light().images.bold.shopping_cart_svg,
      inactiveImagePath: AssetsData.light().images.outline.shopping_cart_svg,
      name: S.of(context)!.buttonNavigationBarEntityCart,
    ),
    ButtonNavigationBarEntity(
      activeImagePath: AssetsData.light().images.bold.user_svg,
      inactiveImagePath: AssetsData.light().images.outline.user_svg,
      name: S.of(context)!.buttonNavigationBarEntityProfile,
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart/cart_cubit.dart';
import '../../../domain/entities/button_navigation_bar_entity.dart';

/// Docked tab bar: four flat tabs with a small Bordeaux dot under the active
/// one, and the style scan as a raised round action in the centre.
///
/// Tab indices are unchanged (0 home, 1 scan, 2 products, 3 cart,
/// 4 profile); only the visual order puts scan in the middle.
class HomeCustomBottomNavigationBar extends StatefulWidget {
  const HomeCustomBottomNavigationBar({super.key, required this.onItemTapped});
  final ValueChanged<int> onItemTapped;
  @override
  State<HomeCustomBottomNavigationBar> createState() =>
      _HomeCustomBottomNavigationBarState();
}

class _HomeCustomBottomNavigationBarState
    extends State<HomeCustomBottomNavigationBar> {
  int selectedIndex = 0;

  static const _scanIndex = 1;
  static const _visualOrder = [0, 2, _scanIndex, 3, 4];

  void _select(int index) {
    setState(() => selectedIndex = index);
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = getButtonNavigationBarItems(context);
    final cartCount = context
        .watch<CartCubit>()
        .cartEntites
        .calculateTotalCount();

    return SizedBox(
      height: 96 + MediaQuery.paddingOf(context).bottom,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70 + MediaQuery.paddingOf(context).bottom,
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: _visualOrder.map((index) {
                  if (index == _scanIndex) {
                    return const Expanded(child: SizedBox());
                  }
                  return Expanded(
                    child: _TabItem(
                      entity: items[index],
                      selected: selectedIndex == index,
                      badge: index == 3 ? cartCount : 0,
                      onTap: () => _select(index),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _ScanAction(
              entity: items[_scanIndex],
              selected: selectedIndex == _scanIndex,
              onTap: () => _select(_scanIndex),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.entity,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  final ButtonNavigationBarEntity entity;
  final bool selected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;

    return InkResponse(
      onTap: onTap,
      radius: 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                selected ? entity.activeImagePath : entity.inactiveImagePath,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              if (badge > 0)
                PositionedDirectional(
                  top: -6,
                  end: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    constraints: const BoxConstraints(minWidth: 17),
                    height: 17,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: KaccentColor,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: scheme.surface, width: 1.5),
                    ),
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            entity.name,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: selected ? 5 : 0,
            height: 5,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanAction extends StatelessWidget {
  const _ScanAction({
    required this.entity,
    required this.selected,
    required this.onTap,
  });

  final ButtonNavigationBarEntity entity;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: KbrandGradient,
              border: Border.all(color: scheme.surface, width: 4),
              boxShadow: [
                BoxShadow(
                  color: KprimaryColorDark.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              selected ? entity.activeImagePath : entity.inactiveImagePath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          entity.name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

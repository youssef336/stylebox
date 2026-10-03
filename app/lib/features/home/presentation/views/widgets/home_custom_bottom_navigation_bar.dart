// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import '../../../domain/entities/button_navigation_bar_entity.dart';
import 'custom_bottom_navigation_bari_tem.dart';

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
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        height: 66,
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : KprimaryColor.withOpacity(0.14),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: getButtonNavigationBarItems(context).asMap().entries.map((
            e,
          ) {
            final index = e.key;
            final entity = e.value;

            return Expanded(
              flex: index == selectedIndex ? 3 : 2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    widget.onItemTapped(index);
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: CustomBottomNavigationBarItem(
                    key: ValueKey(selectedIndex == index),
                    isSelected: selectedIndex == index,
                    buttonNavigationBarEntity: entity,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

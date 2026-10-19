import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/generated/l10n.dart';

/// "Story" style category picker: round swatches with the label underneath.
/// The selected one gets a Bordeaux ring.
class HomeCategoryRail extends StatelessWidget {
  const HomeCategoryRail({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context)!;
    final items = <(String?, String, IconData, List<Color>, Color)>[
      (
        null,
        locale.homeCategoryAll,
        Icons.grid_view_rounded,
        const [Color(0xFFB0506B), KprimaryColorDark],
        Colors.white,
      ),
      (
        'women',
        locale.categoryWomen,
        Icons.checkroom_rounded,
        const [Color(0xFFF6E8EC), Color(0xFFE7C3CF)],
        KprimaryColor,
      ),
      (
        'men',
        locale.categoryMen,
        Icons.dry_cleaning_rounded,
        const [Color(0xFF3A2C29), Color(0xFF1E1816)],
        KaccentColor,
      ),
      (
        'kids',
        locale.categoryKids,
        Icons.child_care_rounded,
        const [Color(0xFFF5ECDD), Color(0xFFE3CBA3)],
        const Color(0xFF8A6631),
      ),
      (
        'unisex',
        locale.categoryUnisex,
        Icons.diversity_3_rounded,
        const [Color(0xFFEDE5E0), Color(0xFFD9CCC4)],
        KlightModeTextColor,
      ),
    ];

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          KhorzontalPadding,
          16,
          KhorzontalPadding,
          0,
        ),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final (value, label, icon, colors, ink) = items[index];
          final isSelected = value == selected;
          final scheme = Theme.of(context).colorScheme;
          return GestureDetector(
            onTap: () => onSelected(value),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? scheme.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(icon, color: ink, size: 24),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

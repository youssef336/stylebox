import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';

/// Checkout progress: "Step 1 of 3" + current step name, then a segmented
/// progress track whose segments (with labels) are tappable.
class CheckOutStage extends StatelessWidget {
  const CheckOutStage({
    super.key,
    required this.currentPageindex,
    required this.pageController,
    required this.onTap,
  });
  final int currentPageindex;
  final PageController pageController;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) {
    final steps = getSteps(context);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S
              .of(context)!
              .checkoutStepOf('${currentPageindex + 1}', '${steps.length}')
              .toUpperCase(),
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          steps[currentPageindex],
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: List.generate(steps.length, (index) {
            final done = index < currentPageindex;
            final active = index == currentPageindex;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: index == steps.length - 1 ? 0 : 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: done || active
                              ? scheme.primary
                              : Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (done) ...[
                            Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            child: Text(
                              steps[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: active
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: done || active
                                    ? scheme.onSurface
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

List<String> getSteps(BuildContext context) => [
  S.of(context)!.checkOutViewTitle,
  S.of(context)!.checkOutViewAddress,
  S.of(context)!.checkOutViewPayment,
];

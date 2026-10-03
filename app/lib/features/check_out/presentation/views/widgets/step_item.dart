import 'package:flutter/material.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/active_step_item.dart';

import 'inactive_step_item.dart';

class StepItem extends StatelessWidget {
  const StepItem({
    super.key,
    required this.text,
    required this.index,
    required this.isActive,
  });
  final String text, index;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: ActiveStepItem(text: text),
      secondChild: InactiveStepItem(index: index, text: text),
      crossFadeState: isActive
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }
}

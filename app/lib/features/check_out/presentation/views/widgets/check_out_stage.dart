// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:stylebox/features/check_out/presentation/views/widgets/step_item.dart';

import '../../../../../generated/l10n.dart';

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
    return Row(
      children: List.generate(getSteps(context).length, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              onTap(index);
            },
            child: StepItem(
              isActive: index <= currentPageindex,
              index: (index + 1).toString(),
              text: getSteps(context)[index],
            ),
          ),
        );
      }),
    );
  }
}

List<String> getSteps(BuildContext context) => [
  S.of(context)!.checkOutViewTitle,
  S.of(context)!.checkOutViewAddress,
  S.of(context)!.checkOutViewPayment,
];

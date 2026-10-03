import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/models/bag_item_model.dart';
import 'package:stylebox/generated/l10n.dart';
import 'bag_card.dart';

class AvailableBagsList extends StatelessWidget {
  final String title;
  final List<BagItemModel> bags;

  const AvailableBagsList({super.key, required this.title, required this.bags});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? KdarkModeTextColor : KlightModeTextColor,
                ),
              ),
              Text(
                S.of(context)!.availableBagsSwipeHint,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth * 0.72).clamp(230.0, 270.0);

            return SizedBox(
              width: constraints.maxWidth,
              height: 222,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: bags.length,
                itemBuilder: (context, index) {
                  final bag = bags[index];
                  return BagCard(
                    width: cardWidth,
                    title: bag.title,
                    price: bag.price,
                    oldPrice: bag.oldPrice,
                    bagsLeft: bag.bagsLeft,
                    rating: bag.rating,
                    bagItemModel: bag,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

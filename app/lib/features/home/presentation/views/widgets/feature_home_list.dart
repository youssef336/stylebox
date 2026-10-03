import 'package:flutter/material.dart';
import 'feature_home_item.dart';

class FeatureHomeList extends StatelessWidget {
  const FeatureHomeList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: FeatureHomeItem(),
          ),
        ),
      ),
    );
  }
}

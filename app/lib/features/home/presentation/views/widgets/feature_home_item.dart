import 'package:flutter/material.dart';
import 'package:stylebox/generated/l10n.dart';
import 'feature_home_item_buttom.dart';

class FeatureHomeItem extends StatelessWidget {
  const FeatureHomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    var itemwidth = MediaQuery.of(context).size.width - 32;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: itemwidth,
        child: AspectRatio(
          aspectRatio: 342 / 158,
          child: Stack(
            children: [
              Container(
                color: Colors.blue,
                width: itemwidth * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        S.of(context)!.homeFeaturedItemTitle,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        S.of(context)!.homeFeaturedItemSubtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FeatureHomeItemButtom(onPressed: () {}),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

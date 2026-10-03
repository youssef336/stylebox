import 'package:flutter/material.dart';
import 'package:stylebox/core/models/restaurant_entity_model.dart';
import 'resturant_card.dart';

class RestaurantsHorizontalList extends StatelessWidget {
  final String title;
  final List<RestaurantEntity> restaurants;

  const RestaurantsHorizontalList({
    super.key,
    required this.title,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == restaurants.length - 1 ? 16 : 8,
                ),
                child: SizedBox(
                  width: 300,
                  child: RestaurantCard(restaurant: restaurants[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

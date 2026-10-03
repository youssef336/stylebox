import 'package:flutter/material.dart';

class FavProductsGridView extends StatelessWidget {
  const FavProductsGridView({super.key, required this.products});
  final List<dynamic> products;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Start adding your favorite items',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

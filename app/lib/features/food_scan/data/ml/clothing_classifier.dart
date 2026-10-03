import 'package:flutter/foundation.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ClothingClassification {
  final String label;
  final double confidence;

  const ClothingClassification({required this.label, required this.confidence});
}

/// On-device clothing recognition with ML Kit's base image-labeling model.
/// ML Kit returns generic labels ("Jeans", "Sleeve", "Shoe"...); only the
/// clothing-related ones are kept and mapped to clean item names.
class ClothingClassifier {
  final ImageLabeler _labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.4),
  );

  // Label word (lowercase, singular) -> display name.
  static const Map<String, String> _clothingNames = {
    'jeans': 'Jeans',
    'denim': 'Jeans',
    'trousers': 'Trousers',
    'pants': 'Pants',
    'shorts': 'Shorts',
    'skirt': 'Skirt',
    'dress': 'Dress',
    'gown': 'Dress',
    'suit': 'Suit',
    'blazer': 'Blazer',
    'jacket': 'Jacket',
    'coat': 'Coat',
    'outerwear': 'Jacket',
    'sweater': 'Sweater',
    'hoodie': 'Hoodie',
    'sweatshirt': 'Sweatshirt',
    'cardigan': 'Cardigan',
    'vest': 'Vest',
    'jersey': 'T-shirt',
    't-shirt': 'T-shirt',
    'shirt': 'Shirt',
    'blouse': 'Blouse',
    'sleeve': 'Top',
    'collar': 'Shirt',
    'tights': 'Leggings',
    'legging': 'Leggings',
    'swimwear': 'Swimwear',
    'bikini': 'Swimwear',
    'pajamas': 'Pajamas',
    'kimono': 'Kimono',
    'uniform': 'Uniform',
    'shoe': 'Shoes',
    'sneaker': 'Sneakers',
    'boot': 'Boots',
    'sandal': 'Sandals',
    'heel': 'Heels',
    'slipper': 'Slippers',
    'hat': 'Hat',
    'cap': 'Cap',
    'beanie': 'Beanie',
    'scarf': 'Scarf',
    'glove': 'Gloves',
    'belt': 'Belt',
    'tie': 'Tie',
    'sock': 'Socks',
    'bag': 'Bag',
    'handbag': 'Handbag',
    'backpack': 'Backpack',
    'purse': 'Purse',
    'wallet': 'Wallet',
    'sunglasses': 'Sunglasses',
    'watch': 'Watch',
    'necklace': 'Necklace',
    'bracelet': 'Bracelet',
    'earring': 'Earrings',
    'jewellery': 'Jewellery',
    'jewelry': 'Jewellery',
  };

  /// Matches whole words so "Landscape" does not match "cap".
  static String? clothingNameFor(String rawLabel) {
    final words = rawLabel
        .toLowerCase()
        .split(RegExp(r'[^a-z\-]+'))
        .where((w) => w.isNotEmpty);
    for (final word in words) {
      final singular = word.endsWith('s') && word.length > 3
          ? word.substring(0, word.length - 1)
          : word;
      final name = _clothingNames[word] ?? _clothingNames[singular];
      if (name != null) return name;
    }
    return null;
  }

  /// Best clothing item in the photo, or null if none was recognised.
  Future<ClothingClassification?> classifyFile(String path) async {
    try {
      final labels = await _labeler.processImage(InputImage.fromFilePath(path));
      ClothingClassification? best;
      for (final label in labels) {
        final name = clothingNameFor(label.label);
        if (name == null) continue;
        if (best == null || label.confidence > best.confidence) {
          best = ClothingClassification(
            label: name,
            confidence: label.confidence,
          );
        }
      }
      return best;
    } catch (e) {
      debugPrint('Clothing classifier error: $e');
      return null;
    }
  }

  void dispose() {
    _labeler.close();
  }
}

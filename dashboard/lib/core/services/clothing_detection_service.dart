import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image/image.dart' as img;

class CustomDetectionResult {
  final String label;
  final double score;
  CustomDetectionResult(this.label, this.score);
}

/// On-device clothing recognition using ML Kit's base image-labeling model.
/// ML Kit returns generic labels ("Jeans", "Sleeve", "Shoe"...); we keep only
/// the clothing-related ones and map them to clean product names.
class ClothingDetectionService {
  final ImageLabeler _labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.45),
  );

  // Label word (lowercase, singular) -> display name for the box item.
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

  /// Maps an ML Kit label to a clothing name, or null if it is not clothing.
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

  /// All clothing items found in the whole picture, best first.
  Future<List<CustomDetectionResult>> detectClothing(File imageFile) async {
    try {
      final labels = await _labeler.processImage(
        InputImage.fromFilePath(imageFile.path),
      );
      return _toClothingResults(labels);
    } catch (e) {
      debugPrint('Clothing labeling error: $e');
      return [];
    }
  }

  /// Best clothing item in a cropped region (e.g. one ML Kit object box).
  Future<CustomDetectionResult?> detectClothingFromImage(
    img.Image image,
  ) async {
    File? tmp;
    try {
      tmp = File(
        '${Directory.systemTemp.path}/scan_crop_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );
      await tmp.writeAsBytes(img.encodeJpg(image, quality: 90));
      final results = await detectClothing(tmp);
      return results.isEmpty ? null : results.first;
    } catch (e) {
      debugPrint('Clothing crop error: $e');
      return null;
    } finally {
      if (tmp != null && await tmp.exists()) {
        await tmp.delete();
      }
    }
  }

  List<CustomDetectionResult> _toClothingResults(List<ImageLabel> labels) {
    final byName = <String, double>{};
    for (final label in labels) {
      final name = clothingNameFor(label.label);
      if (name == null) continue;
      final previous = byName[name] ?? 0;
      if (label.confidence > previous) byName[name] = label.confidence;
    }
    final results = byName.entries
        .map((e) => CustomDetectionResult(e.key, e.value))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  void dispose() {
    _labeler.close();
  }
}

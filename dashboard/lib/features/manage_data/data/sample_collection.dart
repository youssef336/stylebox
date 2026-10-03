import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stylebox_dashboard/core/utils/backend_endpoints.dart';
import 'package:uuid/uuid.dart';

/// A ready-made StyleBox collection: 4 brands, 6 pinned branches around
/// Cairo & Giza and 14 clothing boxes, written exactly like the dashboard
/// writes stores and boxes. Photos are free Unsplash images, copied into the
/// `product_images` bucket on Supabase.
///
/// Doc ids are fixed per owner, so running it again resets these stores
/// instead of duplicating them.
class SampleCollectionSeeder {
  SampleCollectionSeeder({FirebaseFirestore? firestore, SupabaseClient? supabase})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _supabase = supabase ?? Supabase.instance.client;

  final FirebaseFirestore _firestore;
  final SupabaseClient _supabase;
  final Map<String, String> _uploaded = {};

  static const _bucket = 'product_images';

  static int get storeCount => _sampleStores.length;
  static int get boxCount =>
      _sampleStores.fold<int>(0, (int n, store) => n + store.boxes.length);
  static int get _photoCount => {
    for (final s in _sampleStores) ...[s.photo, ...s.boxes.map((b) => b.photo)],
  }.length;

  /// Returns the number of boxes written.
  Future<int> seed({
    required String userEmail,
    required String ownerId,
    void Function(int done, int total)? onProgress,
  }) async {
    final total = _photoCount + _sampleStores.length;
    var done = 0;
    void step() => onProgress?.call(++done, total);

    final owner = ownerId.length > 6 ? ownerId.substring(0, 6) : ownerId;

    for (final store in _sampleStores) {
      final storeId = 'sample-${store.slug}-$owner';
      final storeImage = await _photoUrl(store.photo, step);

      final products = <Map<String, dynamic>>[];
      for (var i = 0; i < store.boxes.length; i++) {
        final box = store.boxes[i];
        final productId = const Uuid().v5(
          Namespace.url.value,
          'stylebox-sample/$storeId/$i',
        );
        products.add({
          'isAvailable': true,
          'title': box.title,
          'price': box.price,
          'oldPrice': box.oldPrice,
          'bagsLeft': box.bagsLeft,
          'reviews': <Map<String, dynamic>>[],
          'detectedItems': box.items,
          'userEmail': userEmail,
          'imageUrl': await _photoUrl(box.photo, step),
          'restaurantId': storeId,
          'restaurantName': store.name,
          'pickupTime': box.pickupTime,
          'productId': productId,
          'docId': productId,
          'avgRating': 0.0,
          'sizes': box.sizes,
          'category': box.category,
        });
      }

      await _firestore
          .collection(BackendEndpoints.resturantCollection)
          .doc(storeId)
          .set({
            'name': store.name,
            'branchLocation': store.address,
            'totalBranches': store.totalBranches,
            'branchIndex': store.branchIndex,
            'isOpend': store.isOpen,
            'isAvailable': true,
            'RestaurantimageUrl': storeImage,
            'userEmail': userEmail,
            'latitude': store.latitude,
            'longitude': store.longitude,
            'createdAt': FieldValue.serverTimestamp(),
            'reviews': <Map<String, dynamic>>[],
            'restaurantId': storeId,
            'docId': storeId,
            'products': products,
          });
      step();
    }

    return boxCount;
  }

  /// Copies an Unsplash photo into Supabase and returns its public URL.
  /// Falls back to the Unsplash URL itself if the copy fails.
  Future<String> _photoUrl(String photoId, VoidCallback step) async {
    final cached = _uploaded[photoId];
    if (cached != null) return cached;

    final source =
        'https://images.unsplash.com/photo-$photoId'
        '?w=1000&q=80&fm=jpg&fit=crop';
    final path = 'images/sample/$photoId.jpg';
    final storage = _supabase.storage.from(_bucket);

    String url;
    try {
      final bytes = await _download(source);
      try {
        await storage.uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
      } on StorageException catch (e) {
        // Already copied by an earlier run: reuse it.
        final exists =
            e.statusCode == '409' ||
            e.message.toLowerCase().contains('exists');
        if (!exists) rethrow;
      }
      url = storage.getPublicUrl(path);
    } catch (e) {
      debugPrint('Sample photo $photoId not copied to Supabase: $e');
      url = source;
    }

    _uploaded[photoId] = url;
    step();
    return url;
  }

  static Future<Uint8List> _download(String url) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
      }
      return await consolidateHttpClientResponseBytes(response);
    } finally {
      client.close();
    }
  }
}

class _SampleBox {
  const _SampleBox({
    required this.title,
    required this.items,
    required this.price,
    required this.oldPrice,
    required this.bagsLeft,
    required this.sizes,
    required this.category,
    required this.photo,
    this.pickupTime = 'Pickup 4:00 PM - 11:00 PM',
  });

  final String title;
  final List<String> items;
  final double price;
  final double oldPrice;
  final int bagsLeft;
  final List<String> sizes;
  final String category; // men | women | kids | unisex
  final String photo; // Unsplash photo id
  final String pickupTime;
}

class _SampleStore {
  const _SampleStore({
    required this.slug,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.photo,
    required this.boxes,
    this.totalBranches = 1,
    this.branchIndex = 1,
    this.isOpen = true,
  });

  final String slug;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String photo;
  final List<_SampleBox> boxes;
  final int totalBranches;
  final int branchIndex;
  final bool isOpen;
}

const _urbanThreadsPhoto = '1718985342149-7178154e0aee';
const _denimLabPhoto = '1567401893414-76b7b1e5a7a5';

const _sampleStores = <_SampleStore>[
  _SampleStore(
    slug: 'urban-threads-1',
    name: 'Urban Threads',
    address: 'Mall of Arabia, 6th of October, Giza',
    latitude: 30.0067,
    longitude: 30.9733,
    totalBranches: 2,
    branchIndex: 1,
    photo: _urbanThreadsPhoto,
    boxes: [
      _SampleBox(
        title: 'Streetwear Box',
        items: ['2x Oversized T-shirt', '1x Cargo pants', '1x Cap'],
        price: 450,
        oldPrice: 1200,
        bagsLeft: 6,
        sizes: ['M', 'L', 'XL'],
        category: 'men',
        photo: '1623596305214-19f21cbf48ee',
      ),
      _SampleBox(
        title: 'Hoodie Season Box',
        items: ['1x Hoodie', '1x Joggers', '1x Beanie'],
        price: 520,
        oldPrice: 1350,
        bagsLeft: 4,
        sizes: ['S', 'M', 'L', 'XL'],
        category: 'unisex',
        photo: '1578768079052-aa76e52ff62e',
      ),
    ],
  ),
  _SampleStore(
    slug: 'urban-threads-2',
    name: 'Urban Threads',
    address: 'Arkan Plaza, Sheikh Zayed, Giza',
    latitude: 30.0214,
    longitude: 30.9867,
    totalBranches: 2,
    branchIndex: 2,
    photo: _urbanThreadsPhoto,
    boxes: [
      _SampleBox(
        title: 'Weekend Layers Box',
        items: ['1x Hoodie', '1x Ripped jeans', '1x Basic tee'],
        price: 480,
        oldPrice: 1250,
        bagsLeft: 5,
        sizes: ['S', 'M', 'L'],
        category: 'unisex',
        photo: '1620799140188-3b2a02fd9a77',
      ),
      _SampleBox(
        title: 'Basics Tee Box',
        items: ['5x Cotton T-shirt (mixed colors)'],
        price: 300,
        oldPrice: 750,
        bagsLeft: 10,
        sizes: ['S', 'M', 'L', 'XL', 'XXL'],
        category: 'men',
        photo: '1562157873-818bc0726f68',
        pickupTime: 'Pickup 12:00 PM - 10:00 PM',
      ),
    ],
  ),
  _SampleStore(
    slug: 'denim-lab-1',
    name: 'Denim Lab',
    address: '26th of July St, Zamalek, Cairo',
    latitude: 30.0617,
    longitude: 31.2194,
    totalBranches: 2,
    branchIndex: 1,
    photo: _denimLabPhoto,
    boxes: [
      _SampleBox(
        title: 'Classic Denim Box',
        items: ['1x Denim jacket', '1x Slim-fit jeans', '1x White shirt'],
        price: 650,
        oldPrice: 1700,
        bagsLeft: 3,
        sizes: ['S', 'M', 'L'],
        category: 'unisex',
        photo: '1543076447-215ad9ba6923',
      ),
      _SampleBox(
        title: 'Denim & Tee Box',
        items: ['1x Oversized denim jacket', '2x White T-shirt'],
        price: 500,
        oldPrice: 1300,
        bagsLeft: 5,
        sizes: ['XS', 'S', 'M'],
        category: 'women',
        photo: '1577660002965-04865592fc60',
      ),
    ],
  ),
  _SampleStore(
    slug: 'denim-lab-2',
    name: 'Denim Lab',
    address: 'Road 9, Maadi, Cairo',
    latitude: 29.9600,
    longitude: 31.2577,
    totalBranches: 2,
    branchIndex: 2,
    isOpen: false,
    photo: _denimLabPhoto,
    boxes: [
      _SampleBox(
        title: 'Jeans Stack Box',
        items: ['3x Jeans (slim, straight, relaxed)'],
        price: 700,
        oldPrice: 1800,
        bagsLeft: 4,
        sizes: ['30', '32', '34', '36'],
        category: 'unisex',
        photo: '1604176354204-9268737828e4',
        pickupTime: 'Pickup 6:00 PM - 11:59 PM',
      ),
      _SampleBox(
        title: 'Street Denim Box',
        items: ['1x Sherpa denim jacket', '1x Graphic hoodie', '1x Cap'],
        price: 750,
        oldPrice: 1950,
        bagsLeft: 2,
        sizes: ['M', 'L', 'XL'],
        category: 'men',
        photo: '1614699745279-2c61bd9d46b5',
        pickupTime: 'Pickup 6:00 PM - 11:59 PM',
      ),
    ],
  ),
  _SampleStore(
    slug: 'layla-boutique',
    name: 'Layla Boutique',
    address: 'City Stars Mall, Nasr City, Cairo',
    latitude: 30.0729,
    longitude: 31.3456,
    photo: '1753029226995-74b05a344bb1',
    boxes: [
      _SampleBox(
        title: 'Summer Dress Box',
        items: ['2x Floral midi dress', '1x Straw bag'],
        price: 550,
        oldPrice: 1500,
        bagsLeft: 6,
        sizes: ['S', 'M', 'L'],
        category: 'women',
        photo: '1496747611176-843222e1e57c',
      ),
      _SampleBox(
        title: 'Office Chic Box',
        items: ['1x Checked blazer', '1x Tailored trousers', '1x Silk blouse'],
        price: 800,
        oldPrice: 2200,
        bagsLeft: 3,
        sizes: ['S', 'M', 'L'],
        category: 'women',
        photo: '1608234808654-2a8875faa7fd',
      ),
      _SampleBox(
        title: 'Cozy Knit Box',
        items: ['2x Knit sweater', '1x Wool scarf'],
        price: 450,
        oldPrice: 1150,
        bagsLeft: 7,
        sizes: ['S', 'M', 'L', 'XL'],
        category: 'women',
        photo: '1760013531865-89ff324f83a6',
      ),
    ],
  ),
  _SampleStore(
    slug: 'mini-me-kids',
    name: 'Mini Me Kids',
    address: 'Cairo Festival City Mall, New Cairo',
    latitude: 30.0287,
    longitude: 31.4086,
    photo: '1741992556912-3b2d62461e75',
    boxes: [
      _SampleBox(
        title: 'Smart Kids Box',
        items: ['1x Cardigan', '1x Shirt with bow tie', '1x Shorts'],
        price: 380,
        oldPrice: 950,
        bagsLeft: 5,
        sizes: ['4-5Y', '6-7Y', '8-9Y'],
        category: 'kids',
        photo: '1519238263530-99bdd11df2ea',
        pickupTime: 'Pickup 12:00 PM - 10:00 PM',
      ),
      _SampleBox(
        title: 'Little Explorer Box',
        items: ['2x Printed shirt', '1x Jeans', '1x Sneakers'],
        price: 420,
        oldPrice: 1050,
        bagsLeft: 4,
        sizes: ['6-7Y', '8-9Y', '10-11Y'],
        category: 'kids',
        photo: '1529776292731-c2246c65df5a',
        pickupTime: 'Pickup 12:00 PM - 10:00 PM',
      ),
      _SampleBox(
        title: 'Baby Basics Box',
        items: ['3x Cotton bodysuit', '2x Socks', '1x Soft toy'],
        price: 280,
        oldPrice: 700,
        bagsLeft: 8,
        sizes: ['0-3M', '3-6M', '6-12M'],
        category: 'kids',
        photo: '1622290319146-7b63df48a635',
        pickupTime: 'Pickup 12:00 PM - 10:00 PM',
      ),
    ],
  ),
];

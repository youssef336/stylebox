import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:stylebox/core/entities/review_analytics_entity.dart';
import 'package:stylebox/core/entities/review_entity.dart';
import 'package:stylebox/core/errors/exception.dart';
import 'package:stylebox/core/errors/failures.dart';
import 'package:stylebox/core/models/review_model.dart';
import 'package:stylebox/features/home/domains/repos/product_reviews_repo.dart';

class ProductReviewsRepoImpl implements ProductReviewsRepo {
  ProductReviewsRepoImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _matchesProductId(Map<String, dynamic> productData, String productId) {
    final candidateIds = <String>{
      productData['docId']?.toString().trim() ?? '',
      productData['productId']?.toString().trim() ?? '',
      productData['documentId']?.toString().trim() ?? '',
      productData['id']?.toString().trim() ?? '',
    }..removeWhere((value) => value.isEmpty);

    return candidateIds.contains(productId.trim());
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?>
  _findRestaurantContainingProduct(String productId) async {
    final restaurantsSnapshot = await _firestore.collection('resturants').get();

    for (final restaurantDoc in restaurantsSnapshot.docs) {
      final productsData = List<dynamic>.from(
        restaurantDoc.data()['products'] as List? ?? [],
      );

      for (final product in productsData) {
        if (product is Map<String, dynamic> &&
            _matchesProductId(product, productId)) {
          return restaurantDoc;
        }

        if (product is Map) {
          final productMap = Map<String, dynamic>.from(product);
          if (_matchesProductId(productMap, productId)) {
            return restaurantDoc;
          }
        }
      }
    }

    return null;
  }

  List<Map<String, dynamic>> _restaurantProducts(
    Map<String, dynamic>? restaurantData,
  ) {
    return List<Map<String, dynamic>>.from(
      (restaurantData?['products'] as List<dynamic>? ?? []).map((product) {
        if (product is Map<String, dynamic>) {
          return Map<String, dynamic>.from(product);
        }
        if (product is Map) {
          return Map<String, dynamic>.from(product);
        }
        return <String, dynamic>{};
      }),
    );
  }

  Map<String, dynamic>? _findEmbeddedProduct(
    Map<String, dynamic>? restaurantData,
    String productId,
  ) {
    if (restaurantData == null) {
      return null;
    }

    for (final product in _restaurantProducts(restaurantData)) {
      if (_matchesProductId(product, productId)) {
        return product;
      }
    }

    return null;
  }

  List<ReviewEntity> _parseReviews(Map<String, dynamic>? productData) {
    if (productData == null) {
      return <ReviewEntity>[];
    }

    final reviewsData = productData['reviews'];
    if (reviewsData == null || reviewsData is! List) {
      return <ReviewEntity>[];
    }

    return reviewsData.map((reviewData) {
      if (reviewData is Map<String, dynamic>) {
        return ReviewModel.fromJson(reviewData).toEntity();
      }

      if (reviewData is Map) {
        return ReviewModel.fromJson(
          Map<String, dynamic>.from(reviewData),
        ).toEntity();
      }

      throw Exception('Invalid review data format');
    }).toList();
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> fetchProductReviews({
    required String productId,
  }) async {
    try {
      final restaurantDoc = await _findRestaurantContainingProduct(productId);
      return Right(
        _parseReviews(_findEmbeddedProduct(restaurantDoc?.data(), productId)),
      );
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch reviews.'));
    } on CustomException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to fetch reviews.'));
    }
  }

  @override
  Stream<List<ReviewEntity>> watchProductReviews({required String productId}) {
    return _firestore
        .collection('resturants')
        .snapshots()
        .transform(
          StreamTransformer<
            QuerySnapshot<Map<String, dynamic>>,
            List<ReviewEntity>
          >.fromHandlers(
            handleData: (snapshot, sink) {
              try {
                for (final restaurantDoc in snapshot.docs) {
                  final product = _findEmbeddedProduct(
                    restaurantDoc.data(),
                    productId,
                  );
                  if (product != null) {
                    sink.add(_parseReviews(product));
                    return;
                  }
                }

                sink.add(<ReviewEntity>[]);
              } catch (e) {
                print('Error processing reviews for productId $productId: $e');
                sink.add(<ReviewEntity>[]);
              }
            },
            handleError: (error, stackTrace, sink) {
              print(
                'Firestore reviews stream error for productId $productId: $error',
              );
              sink.add(<ReviewEntity>[]);
            },
          ),
        );
  }

  @override
  Stream<ReviewAnalyticsEntity> watchProductReviewAnalytics({
    required String productId,
  }) {
    return watchProductReviews(productId: productId).map((reviews) {
      if (reviews.isEmpty) {
        return ReviewAnalyticsEntity.empty(productId: productId);
      }

      final ratingBreakdown = <int, int>{
        for (var rating = 1; rating <= 5; rating++) rating: 0,
      };

      num totalRating = 0;
      for (final review in reviews) {
        final roundedRating = review.rating.round().clamp(1, 5);
        ratingBreakdown[roundedRating] =
            (ratingBreakdown[roundedRating] ?? 0) + 1;
        totalRating += review.rating;
      }

      return ReviewAnalyticsEntity(
        productId: productId,
        reviewCount: reviews.length,
        averageRating: totalRating / reviews.length,
        ratingBreakdown: ratingBreakdown,
      );
    });
  }

  @override
  Future<Either<Failure, void>> addProductReview({
    required String productId,
    required ReviewEntity review,
  }) async {
    try {
      print('Adding review to product: $productId');
      final reviewToSave = ReviewModel.fromEntity(
        review.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
      );

      print('Review data to save: ${reviewToSave.toJson()}');

      final restaurantDoc = await _findRestaurantContainingProduct(productId);
      if (restaurantDoc == null) {
        return const Left(ServerFailure('Product not found.'));
      }

      await _firestore.runTransaction((transaction) async {
        final freshSnapshot = await transaction.get(restaurantDoc.reference);
        final restaurantData = freshSnapshot.data();
        if (restaurantData == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'Store not found',
          );
        }

        final products = _restaurantProducts(restaurantData);
        final index = products.indexWhere(
          (product) => _matchesProductId(product, productId),
        );
        if (index == -1) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'Product not found',
          );
        }

        final product = Map<String, dynamic>.from(products[index]);
        final reviews = List<Map<String, dynamic>>.from(
          (product['reviews'] as List<dynamic>? ?? []).map((reviewData) {
            if (reviewData is Map<String, dynamic>) {
              return Map<String, dynamic>.from(reviewData);
            }
            return Map<String, dynamic>.from(reviewData as Map);
          }),
        );

        reviews.add(reviewToSave.toJson());
        product['reviews'] = reviews;

        num totalRating = 0;
        for (final reviewData in reviews) {
          final rating = reviewData['rating'];
          if (rating is num) {
            totalRating += rating;
          } else {
            totalRating += num.tryParse(rating?.toString() ?? '0') ?? 0;
          }
        }
        product['avgRating'] = reviews.isEmpty
            ? 0
            : totalRating / reviews.length;

        products[index] = product;
        transaction.update(restaurantDoc.reference, {'products': products});
      });

      print('Review successfully added to product: $productId');
      return const Right(null);
    } on FirebaseException catch (e) {
      print('Firebase error adding review: ${e.code} - ${e.message}');
      return Left(ServerFailure(e.message ?? 'Failed to submit review.'));
    } on CustomException catch (e) {
      print('Custom error adding review: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('Unknown error adding review: $e');
      return const Left(ServerFailure('Failed to submit review.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProductReview({
    required String productId,
    required ReviewEntity review,
  }) async {
    try {
      final restaurantDoc = await _findRestaurantContainingProduct(productId);
      if (restaurantDoc == null) {
        return const Left(ServerFailure('Product not found.'));
      }

      await _firestore.runTransaction((transaction) async {
        final freshSnapshot = await transaction.get(restaurantDoc.reference);
        final restaurantData = freshSnapshot.data();
        if (restaurantData == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'Store not found',
          );
        }

        final products = _restaurantProducts(restaurantData);
        final index = products.indexWhere(
          (product) => _matchesProductId(product, productId),
        );
        if (index == -1) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'Product not found',
          );
        }

        final product = Map<String, dynamic>.from(products[index]);
        final reviewsList = List<Map<String, dynamic>>.from(
          (product['reviews'] as List<dynamic>? ?? []).map((reviewData) {
            if (reviewData is Map<String, dynamic>) {
              return Map<String, dynamic>.from(reviewData);
            }
            return Map<String, dynamic>.from(reviewData as Map);
          }),
        );

        final reviewIndex = reviewsList.indexWhere((r) => r['id'] == review.id);

        if (reviewIndex != -1) {
          reviewsList[reviewIndex] = ReviewModel.fromEntity(review).toJson();
          product['reviews'] = reviewsList;

          num totalRating = 0;
          for (final reviewData in reviewsList) {
            final rating = reviewData['rating'];
            if (rating is num) {
              totalRating += rating;
            } else {
              totalRating += num.tryParse(rating?.toString() ?? '0') ?? 0;
            }
          }
          product['avgRating'] = reviewsList.isEmpty
              ? 0
              : totalRating / reviewsList.length;

          products[index] = product;
          transaction.update(restaurantDoc.reference, {'products': products});
        }
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update review.'));
    } on CustomException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to update review.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProductReview({
    required String productId,
    required String reviewId,
  }) async {
    try {
      final restaurantDoc = await _findRestaurantContainingProduct(productId);
      if (restaurantDoc == null) {
        return const Left(ServerFailure('Product not found.'));
      }

      await _firestore.runTransaction((transaction) async {
        final freshSnapshot = await transaction.get(restaurantDoc.reference);
        final restaurantData = freshSnapshot.data();
        if (restaurantData == null) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'Store not found',
          );
        }

        final products = _restaurantProducts(restaurantData);
        final index = products.indexWhere(
          (product) => _matchesProductId(product, productId),
        );
        if (index == -1) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'Product not found',
          );
        }

        final product = Map<String, dynamic>.from(products[index]);
        final reviewsList = List<Map<String, dynamic>>.from(
          (product['reviews'] as List<dynamic>? ?? []).map((reviewData) {
            if (reviewData is Map<String, dynamic>) {
              return Map<String, dynamic>.from(reviewData);
            }
            return Map<String, dynamic>.from(reviewData as Map);
          }),
        );

        reviewsList.removeWhere((r) => r['id'] == reviewId);
        product['reviews'] = reviewsList;

        num totalRating = 0;
        for (final reviewData in reviewsList) {
          final rating = reviewData['rating'];
          if (rating is num) {
            totalRating += rating;
          } else {
            totalRating += num.tryParse(rating?.toString() ?? '0') ?? 0;
          }
        }
        product['avgRating'] = reviewsList.isEmpty
            ? 0
            : totalRating / reviewsList.length;

        products[index] = product;
        transaction.update(restaurantDoc.reference, {'products': products});
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete review.'));
    } on CustomException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to delete review.'));
    }
  }
}

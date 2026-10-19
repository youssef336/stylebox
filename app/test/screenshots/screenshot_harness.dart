// Shared helpers for the screenshot tests: real fonts, real theme, fake
// repositories (no Firebase), phone-sized surface and PNG export.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/cubits/locale/locale_cubit.dart';
import 'package:stylebox/core/cubits/theme/theme_cubit.dart';
import 'package:stylebox/core/entities/demo_products.dart';
import 'package:stylebox/core/entities/product_entity.dart';
import 'package:stylebox/core/entities/review_analytics_entity.dart';
import 'package:stylebox/core/entities/review_entity.dart';
import 'package:stylebox/core/errors/failures.dart';
import 'package:stylebox/core/helper_functions/on_generate_routes.dart';
import 'package:stylebox/core/helper_functions/themes.dart';
import 'package:stylebox/core/repos/ordres_repo/orders_repo.dart';
import 'package:stylebox/core/repos/product_repo/product_repo.dart';
import 'package:stylebox/core/services/get_it_service.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/features/auth/domains/entities/user_entity.dart';
import 'package:stylebox/features/auth/domains/repos/auth_repo.dart';
import 'package:stylebox/features/check_out/domains/entities/order_entity.dart';
import 'package:stylebox/features/home/domains/repos/product_reviews_repo.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/cart/cart_cubit.dart';
import 'package:stylebox/features/home/presentation/manager/cubits/products/products_cubit.dart';
import 'package:stylebox/generated/l10n.dart';

/// Screenshot tests only run with `--dart-define=SCREENSHOTS=true`, so the
/// default `flutter test` (and CI) stays fast and platform independent.
const bool kCaptureScreenshots = bool.fromEnvironment('SCREENSHOTS');

const _outDir = '../docs/screenshots';
final _boundaryKey = GlobalKey();

/// Loads every font in the asset FontManifest (Cairo + Material icons) so
/// text renders as real glyphs instead of the test "Ahem" boxes.
Future<void> loadAppFonts() async {
  final manifest =
      json.decode(await rootBundle.loadString('FontManifest.json')) as List;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font in (entry['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

/// Fresh prefs, a signed-in demo user and fake repositories in GetIt.
Future<void> setUpFakes({Map<String, Object> prefs = const {}}) async {
  SharedPreferences.setMockInitialValues({
    KUserData: jsonEncode({
      'id': 'demo-user',
      'name': 'Salma Adel',
      'email': 'salma@stylebox.app',
    }),
    Kpoints: 120,
    Klocale: 'en',
    ...prefs,
  });
  await Prefs.init();
  await getIt.reset();
  getIt.registerSingleton<ProductRepo>(FakeProductRepo());
  getIt.registerSingleton<ProductReviewsRepo>(FakeReviewsRepo());
  getIt.registerSingleton<AuthRepo>(FakeAuthRepo());
  getIt.registerSingleton<OrdersRepo>(FakeOrdersRepo());
}

void usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  tester.view.padding = const FakeViewPadding(top: 141, bottom: 102);
  tester.view.viewPadding = const FakeViewPadding(top: 141, bottom: 102);
  addTearDown(tester.view.reset);
}

/// The app shell used in production (theme, l10n, routes, global cubits),
/// wrapped in a repaint boundary and a fake iOS status bar.
Widget buildTestApp({
  required Widget home,
  Locale locale = const Locale('en'),
  CartCubit? cart,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LocaleCubit()),
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider(create: (_) => cart ?? CartCubit()),
      BlocProvider(
        create: (_) => ProductsCubit(getIt<ProductRepo>())..loadProducts(),
      ),
    ],
    child: RepaintBoundary(
      key: _boundaryKey,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: LightColorTheme(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.supportedLocales,
        locale: locale,
        onGenerateRoute: onGenerateRoute,
        home: home,
        builder: (context, child) =>
            Stack(children: [child!, const _StatusBar()]),
      ),
    ),
  );
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    final dark = _statusBarDark.value;
    final color = dark ? Colors.white : const Color(0xFF1E1816);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 47,
      child: IgnorePointer(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(34, 14, 26, 0),
            child: Row(
              children: [
                Text(
                  '9:41',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                    height: 1.1,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Spacer(),
                Icon(Icons.signal_cellular_alt_rounded, size: 18, color: color),
                const SizedBox(width: 4),
                Icon(Icons.wifi_rounded, size: 18, color: color),
                const SizedBox(width: 4),
                Icon(Icons.battery_full_rounded, size: 20, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _statusBarDark = ValueNotifier<bool>(false);

/// Whether the fake status bar should be white (for dark hero headers).
set statusBarOnDark(bool value) => _statusBarDark.value = value;

/// Lets images, SVGs and streams settle (real async), then pumps frames.
Future<void> settle(WidgetTester tester, {int rounds = 3}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(() async {
      for (final provider in _imageProviders(tester)) {
        final element = find.byType(MaterialApp).evaluate().first;
        await precacheImage(provider, element, onError: (_, _) {});
      }
      await Future<void>.delayed(const Duration(milliseconds: 120));
    });
    await tester.pump(const Duration(milliseconds: 400));
  }
}

Iterable<ImageProvider> _imageProviders(WidgetTester tester) sync* {
  for (final element in find.byWidgetPredicate((_) => true).evaluate()) {
    final widget = element.widget;
    if (widget is Image) yield widget.image;
    if (widget is CircleAvatar && widget.backgroundImage != null) {
      yield widget.backgroundImage!;
    }
    if (widget is DecoratedBox) {
      final decoration = widget.decoration;
      if (decoration is BoxDecoration && decoration.image != null) {
        yield decoration.image!.image;
      }
    }
  }
}

/// Writes the current frame to `docs/screenshots/<name>.png` (1170x2532).
Future<void> capture(WidgetTester tester, String name) async {
  await settle(tester);
  final boundary =
      _boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$_outDir/$name.png')..createSync(recursive: true);
    file.writeAsBytesSync(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

// ── Fakes ────────────────────────────────────────────────────────────────

class FakeProductRepo implements ProductRepo {
  Either<Failure, List<ProductEntity>> get _all => Right(demoProducts);

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProduct({
    String? restaurantId,
  }) async => _all;

  @override
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProductMoreLimit({
    String? restaurantId,
  }) async => _all;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? restaurantId,
  }) async => _all;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsWithLimit(
    int limit, {
    String? restaurantId,
  }) async => _all;

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query, {
    String? restaurantId,
  }) async => _all;

  @override
  Stream<Either<Failure, List<ProductEntity>>> watchProducts({
    String? restaurantId,
    int? restaurantLimit,
  }) => Stream.value(_all);
}

class FakeReviewsRepo implements ProductReviewsRepo {
  static final reviews = [
    ReviewEntity(
      id: 'r1',
      name: 'Mariam K.',
      image: 'assets/images/Avatar_3.png',
      rating: 5,
      review: 'Two pairs of jeans and a jacket that fit perfectly. Amazing value!',
      date: '2 days ago',
    ),
    ReviewEntity(
      id: 'r2',
      name: 'Omar H.',
      image: '',
      rating: 4,
      review: 'Great quality pieces, pickup was quick and easy.',
      date: '1 week ago',
    ),
  ];

  @override
  Future<Either<Failure, void>> addProductReview({
    required String productId,
    required ReviewEntity review,
  }) async => const Right(null);

  @override
  Future<Either<Failure, void>> deleteProductReview({
    required String productId,
    required String reviewId,
  }) async => const Right(null);

  @override
  Future<Either<Failure, List<ReviewEntity>>> fetchProductReviews({
    required String productId,
  }) async => Right(reviews);

  @override
  Future<Either<Failure, void>> updateProductReview({
    required String productId,
    required ReviewEntity review,
  }) async => const Right(null);

  @override
  Stream<ReviewAnalyticsEntity> watchProductReviewAnalytics({
    required String productId,
  }) => Stream.value(
    ReviewAnalyticsEntity(
      productId: productId,
      reviewCount: 2,
      averageRating: 4.8,
      ratingBreakdown: const {5: 1, 4: 1},
    ),
  );

  @override
  Stream<List<ReviewEntity>> watchProductReviews({required String productId}) =>
      Stream.value(reviews);
}

class FakeAuthRepo implements AuthRepo {
  @override
  Future addUserData({required UserEntity user}) async {}

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async => const Left(ServerFailure('offline'));

  @override
  Future<UserEntity> getUserData({required String uId}) async =>
      UserEntity(id: uId, name: 'Salma Adel', email: 'salma@stylebox.app');

  @override
  Future saveUserData({required UserEntity user}) async {}

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async => const Left(ServerFailure('offline'));

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async =>
      const Left(ServerFailure('offline'));

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async =>
      const Left(ServerFailure('offline'));
}

class FakeOrdersRepo implements OrdersRepo {
  @override
  Future<Either<Failure, void>> addOrder({required OrderEntity order}) async =>
      const Right(null);
}

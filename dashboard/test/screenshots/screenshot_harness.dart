// Shared helpers for the dashboard screenshot tests: real fonts and theme,
// fake repositories (no Firebase / Supabase / ML Kit), phone-sized surface
// and PNG export.
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
import 'package:stylebox_dashboard/core/errors/failures.dart';
import 'package:stylebox_dashboard/core/helper_functions/on_generate_routes.dart';
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';
import 'package:stylebox_dashboard/core/localization/locale_cubit.dart';
import 'package:stylebox_dashboard/core/repos/image_repo/image_repo.dart';
import 'package:stylebox_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:stylebox_dashboard/core/services/app_user.dart';
import 'package:stylebox_dashboard/core/services/get_it_services.dart';
import 'package:stylebox_dashboard/core/services/shared_preferences_singletone.dart';
import 'package:stylebox_dashboard/core/services/user_session.dart';
import 'package:stylebox_dashboard/core/utils/app_theme.dart';
import 'package:stylebox_dashboard/features/add_product/domain/entities/add_product_input_entity.dart';
import 'package:stylebox_dashboard/features/auth/domain/repo/login_repo.dart';
import 'package:stylebox_dashboard/features/manage_data/domain/entities/restaurant_entity.dart';
import 'package:stylebox_dashboard/features/manage_data/domain/repos/restaurant_repository.dart';
import 'package:stylebox_dashboard/features/manage_data/domain/usecases/restaurant_usecases.dart';

/// Screenshot tests only run with `--dart-define=SCREENSHOTS=true`.
const bool kCaptureScreenshots = bool.fromEnvironment('SCREENSHOTS');

const _outDir = '../docs/screenshots';
final _boundaryKey = GlobalKey();

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

/// ML Kit detectors are created by the scanner widget; answer their
/// platform calls so nothing native is needed.
void _mockMlKitChannels() {
  for (final name in const [
    'google_mlkit_object_detector',
    'google_mlkit_image_labeler',
  ]) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel(name), (_) async => null);
  }
}

Future<void> setUpFakes() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();
  _mockMlKitChannels();
  UserSession.instance.setUser('owner@urbanthreads.eg', userId: 'demo');
  await getIt.reset();
  final restaurants = FakeRestaurantRepository();
  getIt
    ..registerSingleton<LoginRepo>(FakeLoginRepo())
    ..registerSingleton<ProductsRepo>(FakeProductsRepo())
    ..registerSingleton<ImageRepo>(FakeImageRepo())
    ..registerSingleton<FetchRestaurantsUseCase>(
      FetchRestaurantsUseCase(restaurants),
    )
    ..registerSingleton<AddRestaurantUseCase>(AddRestaurantUseCase(restaurants))
    ..registerSingleton<UpdateRestaurantUseCase>(
      UpdateRestaurantUseCase(restaurants),
    )
    ..registerSingleton<DeleteRestaurantUseCase>(
      DeleteRestaurantUseCase(restaurants),
    )
    ..registerSingleton<UploadRestaurantImageUseCase>(
      UploadRestaurantImageUseCase(restaurants),
    );
}

void usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  tester.view.padding = const FakeViewPadding(top: 141, bottom: 102);
  tester.view.viewPadding = const FakeViewPadding(top: 141, bottom: 102);
  addTearDown(tester.view.reset);
}

final _statusBarDark = ValueNotifier<bool>(false);
set statusBarOnDark(bool value) => _statusBarDark.value = value;

Widget buildTestApp({required Widget home}) {
  return BlocProvider(
    create: (_) => LocaleCubit(),
    child: RepaintBoundary(
      key: _boundaryKey,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: onGenerateRoutes,
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
    final color = _statusBarDark.value ? Colors.white : const Color(0xFF1E1816);
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

Future<void> settle(WidgetTester tester, {int rounds = 3}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }
}

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

// ── Demo data ────────────────────────────────────────────────────────────

final demoStores = [
  const RestaurantEntity(
    docId: 's1',
    name: 'Urban Threads',
    branchLocation: 'Arkan Plaza, Sheikh Zayed',
    totalBranches: 1,
    branchIndex: 1,
    isOpend: true,
    isAvailable: true,
  ),
  const RestaurantEntity(
    docId: 's2',
    name: 'Cotton Corner',
    branchLocation: '26th of July St, Zamalek',
    totalBranches: 1,
    branchIndex: 1,
    isOpend: false,
    isAvailable: true,
  ),
];

AddProductInputEntity _box(
  String id,
  String store,
  String title,
  double price,
  double old,
  int left,
) => AddProductInputEntity(
  productId: id,
  docId: id,
  isAvailable: true,
  title: title,
  price: price,
  oldPrice: old,
  bagsLeft: left,
  restaurantId: store,
  pickupTime: 'Pickup 6:00 PM - 10:00 PM',
);

final demoBoxes = [
  _box('b1', 's1', 'Denim Box', 450, 1100, 5),
  _box('b2', 's1', 'Casual Box', 350, 850, 3),
  _box('b3', 's1', 'Summer Box', 300, 700, 8),
  _box('b4', 's2', 'Office Box', 600, 1500, 2),
  _box('b5', 's2', 'Kids Box', 250, 600, 6),
];

// ── Fakes ────────────────────────────────────────────────────────────────

class FakeLoginRepo implements LoginRepo {
  @override
  Future<Either<Failure, AppUser?>> checkAuthStatus() async =>
      const Right(null);

  @override
  Future<Either<Failure, AppUser>> login(String email, String password) async =>
      Left(ServerFailure('offline'));

  @override
  Future<Either<Failure, void>> logout() async => const Right(null);
}

class FakeProductsRepo implements ProductsRepo {
  @override
  Future<Either<Failure, void>> addProduct(AddProductInputEntity input) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> deleteProduct(String docId) async =>
      const Right(null);

  @override
  Future<Either<Failure, List<AddProductInputEntity>>> getProducts({
    String? userEmail,
  }) async => Right(demoBoxes);

  @override
  Future<Either<Failure, List<AddProductInputEntity>>> getProductsByRestaurant({
    required String restaurantId,
  }) async => Right(demoBoxes.where((b) => b.restaurantId == restaurantId).toList());

  @override
  Future<Either<Failure, void>> updateProduct(
    String docId,
    AddProductInputEntity input,
  ) async => const Right(null);
}

class FakeImageRepo implements ImageRepo {
  @override
  Future<Either<Failure, String>> uploadImage(File image) async =>
      const Right('');
}

class FakeRestaurantRepository implements RestaurantRepository {
  @override
  Future<Either<Failure, RestaurantEntity>> addRestaurant(
    RestaurantEntity entity,
  ) async => Right(entity);

  @override
  Future<Either<Failure, void>> deleteRestaurant(String docId) async =>
      const Right(null);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> fetchRestaurants(
    String userEmail,
  ) async => Right(demoStores);

  @override
  Future<Either<Failure, RestaurantEntity>> updateRestaurant(
    RestaurantEntity entity,
  ) async => Right(entity);

  @override
  Future<Either<Failure, String>> uploadImage(
    String filePath,
    String fileName,
  ) async => const Right('');
}

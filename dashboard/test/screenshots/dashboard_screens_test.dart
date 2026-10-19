// Renders the redesigned dashboard screens to docs/screenshots/dashboard_*.png.
//
//   flutter test --dart-define=SCREENSHOTS=true test/screenshots
//
// Skipped in the default `flutter test` run.
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:stylebox_dashboard/features/add_product/presentation/views/add_product_view.dart';
import 'package:stylebox_dashboard/features/auth/presentation/views/login_view.dart';
import 'package:stylebox_dashboard/features/dashboard/view/dashboard_view.dart';
import 'package:stylebox_dashboard/features/manage_data/presentation/views/manage_data_view.dart';

import 'screenshot_harness.dart';

void main() {
  setUpAll(loadAppFonts);
  setUp(() async {
    await setUpFakes();
    statusBarOnDark = false;
  });

  group('dashboard screenshots', skip: !kCaptureScreenshots, () {
    testWidgets('login', (tester) async {
      usePhoneSurface(tester);
      statusBarOnDark = true;
      await tester.pumpWidget(buildTestApp(home: const LoginView()));
      await capture(tester, 'dashboard_login');
    });

    testWidgets('home', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(buildTestApp(home: const DashboardView()));
      await capture(tester, 'dashboard_home');
    });

    testWidgets('products list', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(buildTestApp(home: const ManageDataView()));
      await capture(tester, 'dashboard_products');
    });

    testWidgets('add product', (tester) async {
      usePhoneSurface(tester);
      statusBarOnDark = true;
      await tester.pumpWidget(buildTestApp(home: const AddProductView()));
      await capture(tester, 'dashboard_add_product');
    });
  });
}

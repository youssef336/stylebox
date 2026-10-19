import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stylebox_dashboard/constant.dart';
import 'package:stylebox_dashboard/core/utils/app_theme.dart';
import 'package:stylebox_dashboard/core/helper_functions/on_generate_routes.dart';
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';
import 'package:stylebox_dashboard/core/localization/locale_cubit.dart';
import 'package:stylebox_dashboard/core/services/custom_bolc_observer.dart';
import 'package:stylebox_dashboard/core/services/get_it_services.dart';
import 'package:stylebox_dashboard/core/services/shared_preferences_singletone.dart';
import 'package:stylebox_dashboard/core/services/supabase_storage.dart';
import 'package:stylebox_dashboard/core/services/user_session.dart';
import 'package:stylebox_dashboard/features/auth/presentation/views/login_view.dart';
import 'package:stylebox_dashboard/features/dashboard/view/dashboard_view.dart';
import 'package:stylebox_dashboard/firebase_options.dart';
import 'package:stylebox_dashboard/core/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  await SupabaseStorageService.initSupabase();
  try {
    await SupabaseStorageService.createBuckets('product_images');
  } catch (e) {
    debugPrint('Failed to initialize Supabase buckets: $e');
  }
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupGetIt();

  // ── Restore UserSession from SharedPreferences ──────────────────────────
  // If the user was previously logged in, we must restore the session so that
  // UserSession.instance.currentEmail / currentUserId don't assert-crash.
  final isLoggedIn = Prefs.getBool(isloggedin);
  if (isLoggedIn) {
    final savedEmail = Prefs.getSavedEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      final userId = 'manual_${savedEmail.split('@').first}';
      UserSession.instance.setUser(savedEmail, userId: userId);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        Prefs.getBool(isloggedin) && UserSession.instance.isLoggedIn;
    final initialRoute = isLoggedIn
        ? DashboardView.routeName
        : LoginView.routeName;

    return BlocProvider(
      create: (_) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // Use an in-app splash wrapper which navigates to the correct initial route
            home: SplashWrapper(initialRoute: initialRoute),
            onGenerateRoute: onGenerateRoutes,
            theme: AppTheme.light(),
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}

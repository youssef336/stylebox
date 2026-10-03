import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stylebox_dashboard/constant.dart';
import 'package:stylebox_dashboard/core/helper_functions/on_generate_routes.dart';
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';
import 'package:stylebox_dashboard/core/localization/locale_cubit.dart';
import 'package:stylebox_dashboard/core/services/custom_bolc_observer.dart';
import 'package:stylebox_dashboard/core/services/get_it_services.dart';
import 'package:stylebox_dashboard/core/services/shared_preferences_singletone.dart';
import 'package:stylebox_dashboard/core/services/supabase_storage.dart';
import 'package:stylebox_dashboard/core/services/user_session.dart';
import 'package:stylebox_dashboard/features/auth/presentation/views/Login_view.dart';
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
            theme: _buildAppTheme(),
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

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF5B3DF5),
      scaffoldBackgroundColor: const Color(0xFFF7F6FB),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5B3DF5),
        secondary: Color(0xFFFF6B6B),
        surface: Color(0xFFFFFFFF),
        error: Color(0xFFE53935),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF5B3DF5),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFF5B3DF5),
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B3DF5),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF424242),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF424242),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF616161),
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9E9E9E),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B3DF5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          elevation: 4,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5B3DF5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5B3DF5), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF949D9E),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
    );
  }
}

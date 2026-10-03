import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';

const String _themeKey = 'theme_mode';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = Prefs.getString(_themeKey);
    switch (savedTheme) {
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.light);
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    String themeString = themeMode == ThemeMode.dark ? 'dark' : 'light';
    await Prefs.setString(_themeKey, themeString);
    emit(themeMode);
  }

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    Prefs.setString(_themeKey, state == ThemeMode.dark ? 'dark' : 'light');
  }

  String getThemeDisplayName() {
    return state == ThemeMode.dark ? 'Dark' : 'Light';
  }

  IconData getThemeIcon() {
    return state == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization/localization_service.dart';

/// Controller to manage app settings, including theme and localization.
class MyAppController extends GetxController {
  // Theme-related state
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  late SharedPreferences _prefs;

  // Localization-related state
  final LocalizationService localizationService = LocalizationService();
  final Rx<Locale?> currentLocale = Rx(null);

  @override
  void onInit() {
    super.onInit();
    initializeSettings();
  }

  /// Initializes app settings (theme and localization).
  Future<void> initializeSettings() async {
    await _initializeTheme();
    _initializeLocalization();
  }

  /// Loads saved theme preference from SharedPreferences.
  Future<void> _initializeTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
  }

  /// Retrieves and applies the saved theme mode.
  void _loadTheme() {
    final String? savedTheme = _prefs.getString('theme');
    if (savedTheme != null) {
      themeMode.value = ThemeMode.values.firstWhere(
            (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// Changes the theme and saves the preference.
  void changeTheme(ThemeMode mode) async {
    await _prefs.setString('theme', mode.toString());
    themeMode.value = mode;
  }

  /// Initializes localization with saved language preference.
  void _initializeLocalization() {
    String initLang = _prefs.getString('language') ?? 'en';
    localizationService.initialize(initLang);
    currentLocale.value = Locale(initLang);

    localizationService.onTranslatedLanguage = (locale) {
      currentLocale.value = locale;
    };
  }

  /// Changes the app language and saves the preference.
  void changeLanguage(String languageCode) {
    localizationService.translate(languageCode);
    _prefs.setString('language', languageCode);
  }

  // Getters for supported locales and localization delegates.
  List<Locale> get supportedLocales => localizationService.supportedLocales;
  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      localizationService.localizationsDelegates;

  /// Determines text direction based on the current locale.
  TextDirection get textDirection =>
      currentLocale.value?.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr;
}

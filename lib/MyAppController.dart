// my_app_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization/localization_service.dart';

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

  Future<void> initializeSettings() async {
    await _initializeTheme();
    _initializeLocalization();
  }

  Future<void> _initializeTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
  }

  void _loadTheme() {
    final String? savedTheme = _prefs.getString('theme');
    if (savedTheme != null) {
      themeMode.value = ThemeMode.values.firstWhere(
            (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  void changeTheme(ThemeMode mode) async {
    await _prefs.setString('theme', mode.toString());
    themeMode.value = mode;
  }

  void _initializeLocalization() {
    String initLang = _prefs.getString('language') ?? 'en';
    localizationService.initialize(initLang);
    currentLocale.value = Locale(initLang);

    localizationService.onTranslatedLanguage = (locale) {
      currentLocale.value = locale;
    };
  }

  void changeLanguage(String languageCode) {
    localizationService.translate(languageCode);
    _prefs.setString('language', languageCode);

  }

  // Getters for localization
  List<Locale> get supportedLocales => localizationService.supportedLocales;

  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      localizationService.localizationsDelegates;
  // Text direction based on current locale
  TextDirection get textDirection =>
      currentLocale.value?.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr;
}
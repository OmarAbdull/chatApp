import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'app_locale.dart';

/// A service class to manage localization in the Flutter app.
class LocalizationService {

  /// Singleton instance of FlutterLocalization.
  static final FlutterLocalization _instance = FlutterLocalization.instance;

  /// List of supported locales.
  List<Locale> supportedLocales = [const Locale('en'), const Locale('ar')];

  /// Returns the list of localization delegates required for the app.
  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      _instance.localizationsDelegates.toList();

  /// Initializes the localization service with the provided language code.
  void initialize(String initLanguageCode) {
    _instance.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ar', AppLocale.AR),
      ],
      initLanguageCode: initLanguageCode,
    );
  }

  /// Changes the app's language based on the given language code.
  void translate(String languageCode, {bool save = true}) =>
      _instance.translate(languageCode, save: save);

  /// Retrieves the current language name.
  String getLanguageName() => _instance.getLanguageName();

  /// Sets a callback function that triggers when the language is changed.
  set onTranslatedLanguage(void Function(Locale? locale)? callback) {
    _instance.onTranslatedLanguage = callback;
  }
}

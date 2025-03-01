import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'app_locale.dart';

class LocalizationService {

  static final FlutterLocalization _instance = FlutterLocalization.instance;
  List<Locale> supportedLocales = [const Locale('en'), const Locale('ar')];

  // Corrected return type to List<LocalizationsDelegate<dynamic>>
  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      _instance.localizationsDelegates.toList();

  String? get fontFamily => _instance.fontFamily;
  Locale? get currentLocale => _instance.currentLocale;

  void initialize(String initLanguageCode) {
    _instance.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'ar',
          AppLocale.AR,
          countryCode: 'SA',
          fontFamily: 'Font AR',
        ),
      ],
      initLanguageCode: initLanguageCode,
    );
  }

  void translate(String languageCode, {bool save = true}) =>
      _instance.translate(languageCode, save: save);

  String getLanguageName() => _instance.getLanguageName();

  set onTranslatedLanguage(void Function(Locale? locale)? callback) {
    _instance.onTranslatedLanguage = callback;
  }
}
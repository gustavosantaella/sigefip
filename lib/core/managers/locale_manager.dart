import 'package:flutter/material.dart';
import 'package:nexo_finance/shared/services/offline/storage_service.dart';

class LocaleManager extends ValueNotifier<Locale> {
  static final LocaleManager _instance = LocaleManager._internal();
  factory LocaleManager() => _instance;

  LocaleManager._internal() : super(const Locale('es'));

  Future<void> loadLocale() async {
    final String? languageCode = await StorageService.instance.read(
      'language_code',
    );
    if (languageCode != null) {
      value = Locale(languageCode);
    }
  }

  Future<void> setLocale(String languageCode) async {
    value = Locale(languageCode);
    await StorageService.instance.write('language_code', languageCode);
  }
}

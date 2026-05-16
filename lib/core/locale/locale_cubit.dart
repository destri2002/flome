import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale?> {
  static const String localeKey = 'app_locale_code';
  static const String defaultLocaleCode = 'id';
  late SharedPreferences _prefs;

  LocaleCubit() : super(null);

  Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;
    final savedCode = _prefs.getString(localeKey);
    if (savedCode == null || savedCode.isEmpty) {
      await setLocale(defaultLocaleCode);
      return;
    }
    emit(_buildLocale(savedCode));
  }

  Future<void> setLocale(String languageCode) async {
    emit(_buildLocale(languageCode));
    await _prefs.setString(localeKey, languageCode);
  }

  Future<void> clearLocale() async {
    emit(null);
    await _prefs.remove(localeKey);
  }

  Locale _buildLocale(String localeCode) {
    final normalized = localeCode.replaceAll('-', '_');
    final parts = normalized.split('_');
    if (parts.length >= 2) {
      return Locale.fromSubtags(
        languageCode: parts[0],
        countryCode: parts[1],
      );
    }
    return Locale(localeCode);
  }
}

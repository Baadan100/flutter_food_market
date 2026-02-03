import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('ar'));

  void setLocale(Locale locale) => state = locale;

  void toggle() {
    state =
        state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
  }
}

final localeProvider = StateNotifierProvider<LocaleController, Locale>(
    (ref) => LocaleController());

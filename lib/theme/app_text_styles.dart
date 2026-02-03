import 'package:flutter/material.dart';

/// أنماط النصوص الموحدة للمشروع باستخدام خط Cairo
class AppTextStyles {
  // منع إنشاء مثيل من الكلاس
  AppTextStyles._();

  // الخط الرسمي للمشروع: Cairo
  static const String _fontFamily = 'Cairo';

  /// النص العادي - Cairo Regular 400
  static TextStyle get regular => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
      );

  /// النص المتوسط - Cairo Medium 500
  static TextStyle get medium => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
      );

  /// النص الغامق - Cairo Bold 700
  static TextStyle get bold => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
      );

  // أحجام النصوص المختلفة - خط Cairo
  static TextStyle get displayLarge => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 57,
        height: 1.12,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 45,
        height: 1.16,
      );

  static TextStyle get displaySmall => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 36,
        height: 1.22,
      );

  static TextStyle get headlineLarge => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        height: 1.25,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        height: 1.29,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 1.33,
      );

  static TextStyle get titleLarge => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 22,
        height: 1.27,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.50,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.50,
        letterSpacing: 0.15,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.4,
      );

  static TextStyle get labelLarge => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1.45,
        letterSpacing: 0.5,
      );

  // أنماط مخصصة للتطبيق
  static TextStyle get appTitle => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        height: 1.2,
      );

  static TextStyle get buttonText => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.25,
      );

  static TextStyle get cardTitle => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        height: 1.3,
      );

  static TextStyle get priceText => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        height: 1.2,
      );

  static TextStyle get errorText => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.4,
      );

  static TextStyle get hintText => TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.4,
      );
}

# دليل تثبيت Stripe Package 📦

## ⚠️ المشكلة الحالية:

`flutter_stripe` package لم يتم تثبيته بعد، مما يسبب أخطاء في `stripe_service.dart`.

---

## ✅ الحل:

### الخطوة 1: تثبيت Package

قم بتشغيل الأمر التالي في Terminal:

```bash
flutter pub get
```

إذا لم يعمل، جرب:

```bash
flutter clean
flutter pub get
```

### الخطوة 2: التحقق من الإصدار

في `pubspec.yaml`، تأكد من وجود:

```yaml
dependencies:
  flutter_stripe: ^10.1.1
  http: ^1.2.2
```

### الخطوة 3: بعد التثبيت

بعد تثبيت `flutter_stripe` بنجاح:

1. افتح `lib/core/services/stripe_service.dart`
2. أزل التعليق عن السطر:
   ```dart
   // import 'package:flutter_stripe/flutter_stripe.dart';
   ```
   إلى:
   ```dart
   import 'package:flutter_stripe/flutter_stripe.dart';
   ```

3. في دالة `initialize()`، أزل التعليق عن:
   ```dart
   // Stripe.publishableKey = publishableKey;
   // await Stripe.instance.applySettings();
   ```

4. في دالة `confirmPayment()`، أزل التعليق عن الكود المعلق

---

## 🔍 التحقق من التثبيت:

بعد `flutter pub get`، تحقق من:

1. افتح `pubspec.lock`
2. ابحث عن `flutter_stripe:`
3. يجب أن ترى إصدار مثبت

أو شغّل:

```bash
flutter pub deps | findstr stripe
```

---

## 📝 ملاحظات:

- ✅ `stripe_service.dart` الآن يعمل بدون أخطاء (لكن يحتاج package)
- ✅ الكود جاهز - فقط يحتاج إلغاء التعليق بعد التثبيت
- ✅ Publishable Key موجود في الملف
- ⚠️ يحتاج `flutter pub get` لتثبيت package

---

**تاريخ الإنشاء:** 2025-01-11  
**الحالة:** ⚠️ يحتاج تثبيت package

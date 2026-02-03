# تفعيل خط Cairo - دليل سريع

## ✅ المشاكل التي تم حلها:

1. **مشكلة NDK**: تم تحديث `android/app/build.gradle` لاستخدام NDK 27.0.12077973
2. **مشكلة الخطوط**: تم تعطيل إعدادات الخط مؤقتاً حتى يتم تحميل الملفات

## 🚀 التطبيق جاهز للتشغيل الآن:

```bash
flutter run
```

## 📋 لتفعيل خط Cairo لاحقاً:

### 1. تحميل ملفات الخط:
- اذهب إلى [Google Fonts - Cairo](https://fonts.google.com/specimen/Cairo)
- حمل الأوزان: Regular (400), Medium (500), Bold (700)
- ضع الملفات في `assets/fonts/`

### 2. تفعيل الخطوط في pubspec.yaml:
```yaml
assets:
  - assets/translations/
  - assets/images/products/
  - assets/fonts/  # إزالة التعليق

fonts:
  - family: Cairo
    fonts:
      - asset: assets/fonts/Cairo-Regular.ttf
        weight: 400
      - asset: assets/fonts/Cairo-Medium.ttf
        weight: 500
      - asset: assets/fonts/Cairo-Bold.ttf
        weight: 700
```

### 3. تفعيل الخطوط في الكود:
- في `lib/theme/app_text_styles.dart`: إزالة التعليق من `fontFamily: 'Cairo'`
- في `lib/main.dart`: إزالة التعليق من `fontFamily: 'Cairo'`

### 4. إعادة تشغيل التطبيق:
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 التطبيق يعمل الآن بالخط الافتراضي!

جميع الميزات تعمل بشكل طبيعي، والخط سيتم تطبيقه عند إضافة ملفات الخط.

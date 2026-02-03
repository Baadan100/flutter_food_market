# دليل تحديث أيقونات التطبيق - كنوز البحر

## ⚠️ ملاحظة مهمة
`flutter_launcher_icons` لا يدعم SVG مباشرة. نحتاج إلى تحويل SVG إلى PNG أولاً.

## الخطوات المطلوبة:

### 1. تحويل SVG إلى PNG
استخدم أحد الأدوات التالية لتحويل `assets/images/logo.svg` إلى PNG:

#### الخيار 1: استخدام أداة Online
1. افتح https://cloudconvert.com/svg-to-png
2. ارفع `assets/images/logo.svg`
3. قم بتحويله إلى PNG بحجم 1024x1024 pixels
4. احفظ الملف كـ `assets/images/logo.png`

#### الخيار 2: استخدام Inkscape (مجاني)
```bash
# تحميل Inkscape من: https://inkscape.org/
# ثم استخدام الأمر:
inkscape assets/images/logo.svg --export-filename=assets/images/logo.png --export-width=1024 --export-height=1024
```

### 2. تحديث pubspec.yaml
بعد إنشاء `logo.png`، قم بتحديث `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  image_path: "assets/images/logo.png"  # تغيير من .svg إلى .png
  adaptive_icon_background: "#0b1124"
  adaptive_icon_foreground: "assets/images/logo.png"
```

### 3. توليد الأيقونات
```bash
dart run flutter_launcher_icons
```

### 4. التحقق
بعد توليد الأيقونات، تحقق من الملفات التالية:
- `android/app/src/main/res/mipmap-mdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-hdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-xhdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png`

## ✅ ما تم إنجازه:
- ✅ إضافة `flutter_svg` لعرض اللوقو في التطبيق
- ✅ تحديث `splash_page.dart` لاستخدام اللوقو الجديد
- ✅ إضافة `flutter_launcher_icons` للإعدادات

## 📝 الخطوة التالية:
تحويل SVG إلى PNG ثم تشغيل `dart run flutter_launcher_icons`

# تعليمات تحديث أيقونات التطبيق

## الخطوات المطلوبة لتوحيد الأيقونات

نحتاج إلى تحويل `fish-store.svg` إلى أيقونات PNG بأحجام مختلفة للأندرويد.

### الأحجام المطلوبة:
- **mipmap-mdpi**: 48x48 pixels
- **mipmap-hdpi**: 72x72 pixels  
- **mipmap-xhdpi**: 96x96 pixels
- **mipmap-xxhdpi**: 144x144 pixels
- **mipmap-xxxhdpi**: 192x192 pixels

### الطريقة الموصى بها:

#### الخيار 1: استخدام Flutter Launcher Icons (الأسهل)
```bash
flutter pub add --dev flutter_launcher_icons
```

ثم إضافة الإعدادات في `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  image_path: "assets/images/logo.svg"
  adaptive_icon_background: "#0b1124"
  adaptive_icon_foreground: "assets/images/logo.svg"
```

#### الخيار 2: استخدام أداة تحويل SVG إلى PNG
يمكن استخدام:
- Inkscape (مجاني)
- Adobe Illustrator
- Online tools مثل: https://cloudconvert.com/svg-to-png

### الملفات التي يجب تحديثها:
- `android/app/src/main/res/mipmap-mdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-hdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-xhdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png`
- `android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png`

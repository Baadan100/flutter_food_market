# تعليمات إعداد خط Cairo - Cairo Font Setup Instructions

## ✅ تم إعداد الكود

تم تحديث جميع الملفات المطلوبة:
- ✅ `pubspec.yaml` - تم تفعيل إعدادات الخطوط
- ✅ `lib/theme/app_text_styles.dart` - تم تفعيل `_fontFamily = 'Cairo'`
- ✅ `lib/main.dart` - تم تفعيل `fontFamily: 'Cairo'`

## 📋 الخطوات المتبقية

### 1. نسخ ملفات الخطوط

يجب نسخ ملفات الخطوط من مجلد `Cairo/static/` إلى `assets/fonts/`:

**الملفات المطلوبة:**
- `Cairo-Regular.ttf` → `assets/fonts/Cairo-Regular.ttf`
- `Cairo-Medium.ttf` → `assets/fonts/Cairo-Medium.ttf`
- `Cairo-Bold.ttf` → `assets/fonts/Cairo-Bold.ttf`

**طريقة النسخ:**

#### Windows (PowerShell):
```powershell
Copy-Item "Cairo\static\Cairo-Regular.ttf" -Destination "assets\fonts\" -Force
Copy-Item "Cairo\static\Cairo-Medium.ttf" -Destination "assets\fonts\" -Force
Copy-Item "Cairo\static\Cairo-Bold.ttf" -Destination "assets\fonts\" -Force
```

#### Windows (CMD):
```cmd
xcopy "Cairo\static\Cairo-*.ttf" "assets\fonts\" /Y
```

#### يدوياً:
1. افتح مجلد `Cairo/static/`
2. انسخ الملفات الثلاثة:
   - `Cairo-Regular.ttf`
   - `Cairo-Medium.ttf`
   - `Cairo-Bold.ttf`
3. الصقها في مجلد `assets/fonts/`

### 2. التحقق من الملفات

بعد النسخ، يجب أن يحتوي `assets/fonts/` على:
```
assets/fonts/
  ├── Cairo-Regular.ttf
  ├── Cairo-Medium.ttf
  └── Cairo-Bold.ttf
```

### 3. تشغيل التطبيق

بعد نسخ الملفات:
```bash
flutter clean
flutter pub get
flutter run
```

## ✅ الحالة الحالية

- ✅ **الكود جاهز** - جميع الإعدادات تمت
- ⏳ **الملفات** - يجب نسخها يدوياً من `Cairo/static/` إلى `assets/fonts/`

## 📝 ملاحظات

- إذا كان مجلد `Cairo` موجود في workspace آخر، انسخ الملفات من هناك
- تأكد من أن أسماء الملفات مطابقة تماماً (حساسة لحالة الأحرف)
- بعد نسخ الملفات، سيتم تطبيق خط Cairo تلقائياً على جميع النصوص

---

**بعد نسخ الملفات، التطبيق جاهز للعمل مع خط Cairo! 🎉**

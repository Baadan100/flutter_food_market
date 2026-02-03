# إعداد الخط الرسمي للمشروع

## الخط الرسمي: **Cairo**

تم تحديد خط **Cairo** كخط رسمي واحد للمشروع لتوحيد المظهر وتقليل حجم التطبيق.

## الأوزان المستخدمة (3 أوزان فقط)

للتقليل من حجم الخطوط المضافة، نستخدم **3 أوزان فقط**:

1. **Cairo-Regular.ttf** (الوزن 400)
   - للاستخدام في النصوص العادية
   - حجم الملف: ~150KB

2. **Cairo-Medium.ttf** (الوزن 500)
   - للاستخدام في النصوص المتوسطة والعناوين
   - حجم الملف: ~150KB

3. **Cairo-Bold.ttf** (الوزن 700)
   - للاستخدام في النصوص الغامقة والعناوين الرئيسية
   - حجم الملف: ~150KB

**الحجم الإجمالي: ~450KB** (مقبول جداً للتطبيق)

## الأحجام المستخدمة

المشروع يستخدم الأحجام التالية من خط Cairo:

### أحجام العرض الكبيرة (Display)
- **57px** - Display Large (Bold 700)
- **45px** - Display Medium (Bold 700)
- **36px** - Display Small (Bold 700)

### أحجام العناوين (Headline)
- **32px** - Headline Large (Bold 700)
- **28px** - Headline Medium (Bold 700)
- **24px** - Headline Small (Bold 700)

### أحجام العناوين الفرعية (Title)
- **22px** - Title Large (Medium 500)
- **16px** - Title Medium (Medium 500)
- **14px** - Title Small (Medium 500)

### أحجام النصوص الأساسية (Body)
- **16px** - Body Large (Regular 400)
- **14px** - Body Medium (Regular 400)
- **12px** - Body Small (Regular 400)

### أحجام التسميات (Label)
- **14px** - Label Large (Medium 500)
- **12px** - Label Medium (Medium 500)
- **11px** - Label Small (Medium 500)

### أنماط مخصصة للتطبيق
- **28px** - App Title (Bold 700)
- **20px** - Price Text (Bold 700)
- **18px** - Card Title (Medium 500)
- **16px** - Button Text (Medium 500)
- **14px** - Error/Hint Text (Regular 400)

## كيفية الحصول على ملفات الخط

### من Google Fonts (مُوصى به):
1. اذهب إلى [Google Fonts - Cairo](https://fonts.google.com/specimen/Cairo)
2. اختر الأوزان: **Regular (400)**, **Medium (500)**, **Bold (700)**
3. حمل الملفات وضعهما في `assets/fonts/`

### أسماء الملفات المطلوبة:
```
assets/fonts/
  ├── Cairo-Regular.ttf
  ├── Cairo-Medium.ttf
  └── Cairo-Bold.ttf
```

## بعد إضافة الملفات

```bash
flutter clean
flutter pub get
flutter run
```

سيتم تطبيق خط Cairo تلقائياً على جميع النصوص في التطبيق.

## ملاحظات مهمة

✅ **خط واحد فقط**: Cairo هو الخط الرسمي الوحيد للمشروع  
✅ **3 أوزان فقط**: Regular, Medium, Bold لتقليل الحجم  
✅ **دعم كامل**: يدعم العربية والإنجليزية بشكل ممتاز  
✅ **متوافق**: يعمل على جميع منصات Flutter (Android, iOS, Web, Desktop)  
✅ **حجم صغير**: ~450KB فقط لجميع الأوزان

## الملفات المُحدثة

- ✅ `pubspec.yaml` - إضافة إعدادات الخط
- ✅ `lib/theme/app_text_styles.dart` - تفعيل fontFamily في جميع الأنماط
- ✅ `lib/main.dart` - تفعيل fontFamily في Theme

# خطوط Cairo للمشروع

هذا المجلد يحتوي على ملفات خط Cairo بثلاث أوزان مختلفة:

## الملفات المطلوبة:

### 1. Cairo-Regular.ttf (الوزن 400)
- للاستخدام في النصوص العادية
- حجم الملف: ~150KB

### 2. Cairo-Medium.ttf (الوزن 500)  
- للاستخدام في النصوص المتوسطة
- حجم الملف: ~150KB

### 3. Cairo-Bold.ttf (الوزن 700)
- للاستخدام في النصوص الغامقة
- حجم الملف: ~150KB

## كيفية الحصول على الخطوط:

### من Google Fonts:
1. اذهب إلى [Google Fonts - Cairo](https://fonts.google.com/specimen/Cairo)
2. اختر الأوزان: Regular (400), Medium (500), Bold (700)
3. حمل الملفات وضعهما في هذا المجلد

### من المصادر الأخرى:
- [Font Squirrel](https://www.fontsquirrel.com/fonts/cairo)
- [Adobe Fonts](https://fonts.adobe.com/fonts/cairo)

## ملاحظات مهمة:

- تأكد من أن أسماء الملفات مطابقة تماماً لما هو مذكور أعلاه
- حجم الخط الإجمالي: ~450KB (مقبول للتطبيق)
- الخط يدعم العربية والإنجليزية بشكل ممتاز
- متوافق مع جميع منصات Flutter

## بعد إضافة الملفات:

```bash
flutter clean
flutter pub get
flutter run
```

سيتم تطبيق الخط تلقائياً على جميع النصوص في التطبيق.

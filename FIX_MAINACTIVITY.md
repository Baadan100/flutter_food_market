# إصلاح مشكلة MainActivity المكرر

## المشكلة
يوجد ملفان `MainActivity.kt` في مكانين مختلفين:
1. `android/app/src/main/kotlin/com/example/food_market/MainActivity.kt` (قديم - يجب حذفه)
2. `android/app/src/main/kotlin/com/seafoodmarketplace/app/MainActivity.kt` (جديد - صحيح)

## الحل

### الطريقة 1: حذف يدوي (مُوصى به)
1. افتح File Explorer
2. اذهب إلى: `android/app/src/main/kotlin/com/`
3. احذف المجلد `example` بالكامل
4. تأكد من بقاء المجلد `seafoodmarketplace` فقط

### الطريقة 2: من Android Studio
1. افتح Android Studio
2. في Project view، ابحث عن `com/example/food_market/MainActivity.kt`
3. اضغط Delete أو Right-click → Delete
4. احذف المجلد `example` إذا أصبح فارغاً

### الطريقة 3: من Terminal
```powershell
# تأكد من أنك في مجلد المشروع
cd android\app\src\main\kotlin\com
Remove-Item -Recurse -Force example
```

## بعد الحذف
```bash
flutter clean
flutter pub get
flutter run
```

## التحقق
بعد الحذف، يجب أن يكون لديك فقط:
```
android/app/src/main/kotlin/com/
  └── seafoodmarketplace/
      └── app/
          └── MainActivity.kt
```

**لا يجب أن يوجد مجلد `example` بعد الآن!**

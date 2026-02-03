# خطة تطوير iOS 📱

## 🎯 الهدف:
إعداد وتطوير تطبيق iOS بشكل كامل وجاهز للإطلاق على App Store.

---

## 📋 المهام المطلوبة:

### المرحلة 1: فحص وإعداد iOS Project ✅

#### 1. فحص Bundle Identifier:
- [ ] التحقق من `PRODUCT_BUNDLE_IDENTIFIER` في Xcode
- [ ] تحديث إلى `com.seafoodmarketplace.app` (موحد مع Android)
- [ ] التحقق من تطابق Package Name

#### 2. فحص iOS Configuration:
- [ ] فحص `ios/Runner/Info.plist`
- [ ] تحديث Display Name إلى "كنوز البحر"
- [ ] إضافة الأذونات المطلوبة (Camera, Photos للصورة إذا لزم)

#### 3. فحص Podfile:
- [ ] التأكد من وجود جميع Dependencies المطلوبة
- [ ] Firebase iOS SDKs
- [ ] Stripe iOS SDK (إذا لزم)

---

### المرحلة 2: إضافة Firebase iOS Configuration 🔥

#### 1. GoogleService-Info.plist:
- [ ] تحميل `GoogleService-Info.plist` من Firebase Console
- [ ] إضافة الملف إلى `ios/Runner/`
- [ ] التأكد من وجوده في Xcode Project

#### 2. Firebase iOS Setup:
- [ ] فحص `ios/Podfile` لإضافة Firebase Pods
- [ ] تشغيل `pod install`
- [ ] التحقق من أن Firebase يعمل على iOS

---

### المرحلة 3: اختبار التطبيق على iOS Simulator 🧪

#### 1. بناء التطبيق:
```bash
flutter build ios --simulator
flutter run -d ios
```

#### 2. الاختبارات المطلوبة:
- [ ] تسجيل الدخول (Email/Password + Anonymous)
- [ ] عرض المنتجات
- [ ] السلة
- [ ] إتمام الطلب (الدفع عند الاستلام)
- [ ] عرض الطلبات
- [ ] الإعدادات (Theme, Language)

#### 3. اختبار Stripe:
- [ ] الدفع بالبطاقة (Mock Mode أولاً)
- [ ] التحقق من أن Stripe يعمل على iOS

---

### المرحلة 4: إعداد App Store Connect 📦

#### 1. حساب المطور:
- [ ] Apple Developer Account ($99/سنة)
- [ ] تسجيل الدخول إلى App Store Connect

#### 2. إنشاء App:
- [ ] إنشاء App جديد في App Store Connect
- [ ] Bundle ID: `com.seafoodmarketplace.app`
- [ ] معلومات App (اسم، وصف، كلمات مفتاحية)
- [ ] اللقطات الشاشة (Screenshots)
- [ ] الأيقونة (Icon 1024x1024)

#### 3. App Store Listing:
- [ ] الوصف (عربي + إنجليزي)
- [ ] الكلمات المفتاحية
- [ ] اللقطات (Screenshots) - iPhone/iPad
- [ ] الأيقونة

---

### المرحلة 5: بناء IPA للإنتاج 🚀

#### 1. تحديث Version:
```yaml
# pubspec.yaml
version: 1.0.0+1  # version.buildNumber
```

#### 2. بناء IPA:
```bash
flutter build ipa --release
```

#### 3. رفع إلى App Store Connect:
- [ ] فتح Xcode
- [ ] Product → Archive
- [ ] Distribute App → App Store Connect
- [ ] رفع IPA

#### 4. المراجعة والنشر:
- [ ] إرسال للمراجعة (Submit for Review)
- [ ] انتظار الموافقة من Apple (1-3 أيام)
- [ ] النشر عند الموافقة

---

## ⚠️ المتطلبات الأساسية:

### 1. Apple Developer Account:
- **التكلفة:** $99/سنة
- **المطلوب:** حساب Apple ID + بطاقة ائتمانية

### 2. macOS + Xcode:
- **Xcode:** أحدث إصدار (Xcode 15+)
- **iOS Simulator:** للتجربة المحلية
- **CocoaPods:** لـ iOS Dependencies

### 3. Firebase iOS:
- **GoogleService-Info.plist:** تحميل من Firebase Console
- **Firebase iOS SDK:** عبر CocoaPods

---

## 🔧 خطوات سريعة:

### 1. فحص iOS Project:
```bash
cd ios
open Runner.xcworkspace  # أو .xcodeproj
```

### 2. تحديث Bundle Identifier:
- Xcode → Runner → Signing & Capabilities
- Bundle Identifier: `com.seafoodmarketplace.app`

### 3. إضافة Firebase:
```bash
cd ios
pod install
```

### 4. اختبار محلي:
```bash
flutter run -d ios
```

---

## 📝 ملاحظات مهمة:

1. **Bundle Identifier:** يجب أن يكون موحد مع Android (`com.seafoodmarketplace.app`)
2. **Firebase iOS:** يحتاج `GoogleService-Info.plist` منفصل (مختلف عن Android)
3. **Stripe iOS:** قد يحتاج إعدادات إضافية في `Info.plist`
4. **App Store Review:** قد يستغرق 1-3 أيام للموافقة
5. **Shared Package:** يعمل تلقائياً على iOS (لا يحتاج تعديل)

---

## ✅ قائمة التحقق النهائية:

قبل النشر على App Store:
- [ ] Bundle Identifier موحد ✅
- [ ] Firebase يعمل على iOS ✅
- [ ] جميع الميزات تعمل ✅
- [ ] Stripe يعمل (Mock Mode على الأقل) ✅
- [ ] لا توجد أخطاء ✅
- [ ] App Store Connect جاهز ✅
- [ ] IPA مبني للإنتاج ✅
- [ ] تم الرفع للمراجعة ✅

---

**تاريخ الإنشاء:** 2025-01-11  
**الحالة:** 🎯 جاهز للبدء في iOS Development

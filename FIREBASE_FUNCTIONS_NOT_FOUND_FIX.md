# إصلاح خطأ Firebase Functions NOT_FOUND 🔧

## ⚠️ المشكلة:

```
خطأ في الدفع: Exception: خطأ في Firebase Functions: NOT_FOUND
```

**السبب:** 
- Firebase Function `createPaymentIntent` غير موجود أو غير منشور على Firebase
- الخطأ `NOT_FOUND` يعني أن Function لم يتم نشره بعد

---

## ✅ الحل المطبق:

### تحسين معالجة الأخطاء في `StripeService`:

تم تحسين `createPaymentIntent()` لعرض رسالة واضحة للمستخدم عند عدم توفر Firebase Function:

1. **معالجة `FirebaseFunctionsException`:**
   - إذا كان `code == 'not-found'`: رسالة توضيحية أن Function غير متاح
   - إذا كان `code == 'unauthenticated'`: رسالة أن المستخدم غير مسجل دخول
   - إذا كان `code == 'permission-denied'`: رسالة أن المستخدم ليس لديه صلاحية

2. **معالجة الأخطاء العامة:**
   - التحقق من وجود "not-found" في رسالة الخطأ
   - عرض رسالة واضحة مع إرشادات للنشر

---

## 📝 الكود المحدث:

### `lib/core/services/stripe_service.dart`:

```dart
} on functions.FirebaseFunctionsException catch (e) {
  // معالجة أفضل لأخطاء Firebase Functions
  String errorMessage = 'خطأ في Firebase Functions';
  
  if (e.code == 'not-found') {
    errorMessage = 'Firebase Function غير متاح. يرجى التأكد من نشر Functions أولاً.\n'
        'قم بتشغيل: firebase deploy --only functions';
  } else if (e.code == 'unauthenticated') {
    errorMessage = 'يجب تسجيل الدخول أولاً';
  } else if (e.code == 'permission-denied') {
    errorMessage = 'ليس لديك صلاحية للوصول';
  } else if (e.message != null && e.message!.isNotEmpty) {
    errorMessage = 'خطأ في Firebase Functions: ${e.message}';
  }
  
  throw Exception(errorMessage);
} catch (e) {
  // إذا كان الخطأ متعلق بـ NOT_FOUND
  final errorString = e.toString().toLowerCase();
  if (errorString.contains('not-found') || errorString.contains('not found')) {
    throw Exception('Firebase Function غير متاح. يرجى التأكد من نشر Functions أولاً.\n'
        'قم بتشغيل: firebase deploy --only functions');
  }
  throw Exception('خطأ في إنشاء PaymentIntent: $e');
}
```

---

## 🔧 الخطوات لحل المشكلة (نشر Firebase Functions):

### 1. التأكد من تثبيت Firebase CLI:
```bash
npm install -g firebase-tools
```

### 2. تسجيل الدخول إلى Firebase:
```bash
firebase login
```

### 3. التأكد من أنك في مجلد المشروع:
```bash
cd functions
```

### 4. تثبيت Dependencies:
```bash
npm install
```

### 5. نشر Functions:
```bash
# نشر جميع Functions
firebase deploy --only functions

# أو نشر Function محدد
firebase deploy --only functions:createPaymentIntent
```

---

## 📋 التحقق من نشر Functions:

### 1. التحقق من Firebase Console:
- انتقل إلى [Firebase Console](https://console.firebase.google.com/)
- اختر مشروعك
- انتقل إلى **Functions** من القائمة الجانبية
- يجب أن ترى `createPaymentIntent` و `sendOrderInvoice` في القائمة

### 2. التحقق من Logs:
```bash
firebase functions:log
```

---

## ⚠️ ملاحظات مهمة:

### 1. تكوين Stripe Secret Key:
قبل النشر، تأكد من تكوين Stripe Secret Key:
```bash
firebase functions:config:set stripe.secret="sk_test_YOUR_STRIPE_SECRET_KEY"
```

### 2. تكوين SendGrid (للإيميل):
إذا كنت تستخدم SendGrid للإيميل:
```bash
firebase functions:config:set sendgrid.user="YOUR_SENDGRID_USER"
firebase functions:config:set sendgrid.pass="YOUR_SENDGRID_API_KEY"
```

### 3. Spark Plan vs Blaze Plan:
- **Spark Plan (Free):** لا يدعم Firebase Functions (يحتاج ترقية)
- **Blaze Plan (Pay as you go):** يدعم Firebase Functions مع فوترة حسب الاستخدام

إذا كنت على Spark Plan، ستحتاج إلى ترقية إلى Blaze Plan لاستخدام Firebase Functions.

---

## ✅ الحالة بعد الإصلاح:

- ✅ **معالجة الأخطاء:** رسائل واضحة للمستخدم
- ✅ **NOT_FOUND:** رسالة توضيحية مع إرشادات
- ✅ **unauthenticated:** رسالة واضحة
- ✅ **permission-denied:** رسالة واضحة

---

## 🎯 الخطوات التالية:

1. ✅ **تم إصلاح معالجة الأخطاء** ✅
2. ⚠️ **نشر Firebase Functions** (يحتاج منك)
3. ⚠️ **تكوين Stripe Secret Key** (يحتاج منك)
4. ⚠️ **اختبار الدفع بالبطاقة** (بعد النشر)

---

**تاريخ الإصلاح:** 2025-01-11  
**الحالة:** ✅ تم تحسين معالجة الأخطاء - يحتاج نشر Firebase Functions

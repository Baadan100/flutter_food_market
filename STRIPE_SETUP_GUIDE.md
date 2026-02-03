# دليل إعداد Stripe للدفع بالبطاقات المصرفية 💳

## 📋 نظرة عامة

تم إضافة دعم Stripe للدفع بالبطاقات المصرفية في صفحة Checkout. يمكن استبداله لاحقاً ببوابات دفع محلية (مثل Moyasar، PayTabs، Tap Payments).

---

## ✅ ما تم إنجازه:

### 1. إضافة Packages ✅
- ✅ `flutter_stripe: ^11.2.0` - Stripe SDK
- ✅ `http: ^1.2.2` - للاتصال بـ Backend API

### 2. تحديث Checkout Page ✅
- ✅ إضافة خيار اختيار طريقة الدفع (الدفع عند الاستلام / الدفع بالبطاقة)
- ✅ UI لاختيار طريقة الدفع
- ✅ تحديث `_selectedPaymentMethod` بناءً على اختيار المستخدم

### 3. Stripe Service ✅
- ✅ إنشاء `lib/core/services/stripe_service.dart`
- ✅ دعم إنشاء PaymentIntent من Backend
- ✅ دعم تأكيد الدفع

---

## 🔧 الخطوات المطلوبة لإكمال التكامل:

### الخطوة 1: الحصول على Stripe Keys

1. سجّل الدخول إلى [Stripe Dashboard](https://dashboard.stripe.com/)
2. اذهب إلى **Developers** → **API keys**
3. انسخ **Publishable key** (يبدأ بـ `pk_test_` أو `pk_live_`)
4. انسخ **Secret key** (يبدأ بـ `sk_test_` أو `sk_live_`) - **لا تضع هذا في التطبيق!**

### الخطوة 2: إعداد Stripe Service

افتح `lib/core/services/stripe_service.dart` وحدّث:

```dart
static const String _publishableKey = 'pk_test_YOUR_KEY_HERE'; // الصق المفتاح هنا
```

### الخطوة 3: إنشاء Backend API (مطلوب)

Stripe يتطلب Backend API لإنشاء PaymentIntent بشكل آمن.

**مثال Backend (Node.js/Express):**

```javascript
const express = require('express');
const stripe = require('stripe')('sk_test_YOUR_SECRET_KEY');

app.post('/api/create-payment-intent', async (req, res) => {
  const { amount, currency = 'sar' } = req.body;
  
  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount, // بالملي (مثلاً: 10000 = 100.00 SAR)
    currency: currency,
  });
  
  res.json({ clientSecret: paymentIntent.client_secret });
});
```

**أو استخدام Firebase Functions (مقترح):**

```javascript
const functions = require('firebase-functions');
const stripe = require('stripe')(functions.config().stripe.secret_key);

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  const { amount, currency = 'sar' } = data;
  
  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount,
    currency: currency,
  });
  
  return { clientSecret: paymentIntent.client_secret };
});
```

### الخطوة 4: تحديث Stripe Service

حدّث `stripe_service.dart` بإضافة URL للـ Backend:

```dart
static Future<String> createPaymentIntent({
  required int amountCents,
  required String currency,
  String? backendUrl, // ضع URL الـ Backend هنا
}) async {
  // ...
}
```

### الخطوة 5: تهيئة Stripe في main.dart

في `lib/main.dart`:

```dart
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/services/stripe_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // تهيئة Stripe
  await StripeService.initialize();
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### الخطوة 6: إنشاء Stripe Payment Page

أنشئ صفحة `stripe_payment_page.dart` لمعالجة الدفع:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../core/services/stripe_service.dart';

class StripePaymentPage extends StatefulWidget {
  final int amountCents;
  final String currency;
  final String backendUrl;
  
  const StripePaymentPage({
    required this.amountCents,
    required this.currency,
    required this.backendUrl,
  });
  
  // ... implementation
}
```

---

## 🔄 استبدال Stripe ببوابة محلية (لاحقاً):

### الخيارات المحلية المقترحة:

1. **Moyasar** - سعودية، تدعم MADA
2. **PayTabs** - تدعم MADA وVisa/Mastercard
3. **Tap Payments** - خليجية، تدعم طرق دفع محلية

### خطوات الاستبدال:

1. استبدل `StripeService` بـ `LocalPaymentService` (Moyasar/PayTabs/etc)
2. استبدل `stripe_payment_page.dart` بـ `local_payment_page.dart`
3. حدّث `checkout_page.dart` لاستخدام الخدمة الجديدة
4. أزل `flutter_stripe` من `pubspec.yaml` وأضف مكتبة البوابة الجديدة

**الهيكل سيبقى نفسه:**
```
Checkout Page → Payment Service → Backend API → Payment Gateway
```

---

## 📝 الملفات المعدلة:

- ✅ `pubspec.yaml` - إضافة flutter_stripe و http
- ✅ `lib/core/services/stripe_service.dart` - خدمة Stripe (جديد)
- ✅ `lib/features/checkout/checkout_page.dart` - إضافة خيار Stripe
- ⚠️ `lib/main.dart` - يحتاج تهيئة Stripe (TODO)

---

## ⚠️ ملاحظات مهمة:

1. **Publishable Key** آمن للاستخدام في التطبيق (Frontend)
2. **Secret Key** يجب أن يكون في Backend فقط (لا تضعه في التطبيق!)
3. **PaymentIntent** يجب إنشاؤه من Backend (للاستخدام السرية)
4. **Webhook** - استخدم Webhook لتأكيد الدفع من Stripe

---

## 🚀 الحالة الحالية:

- ✅ UI لاختيار طريقة الدفع جاهز
- ✅ Stripe Service مبدئي جاهز
- ⚠️ يحتاج Backend API لإنشاء PaymentIntent
- ⚠️ يحتاج Stripe Payment Page لمعالجة الدفع
- ⚠️ يحتاج Stripe Publishable Key

---

**تاريخ الإنشاء:** 2025-01-11  
**الحالة:** ✅ UI جاهز | ⚠️ يحتاج Backend API

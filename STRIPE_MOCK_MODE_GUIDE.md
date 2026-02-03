# وضع Mock/Test للدفع عبر Stripe (Spark Plan) 🧪

## ⚠️ المشكلة:

**Firebase Functions غير متاحة في Spark Plan (Free)**
- لا يمكن نشر Firebase Functions على Spark Plan
- يحتاج ترقية إلى Blaze Plan (Pay as you go) لاستخدام Firebase Functions

---

## ✅ الحل: وضع Mock/Test

تم إضافة **وضع Mock** للاختبار بدون Firebase Functions:

### 1. تفعيل/تعطيل Mock Mode:

في `lib/core/services/stripe_service.dart`:

```dart
/// وضع Mock/Test للاختبار بدون Firebase Functions
/// قم بتعيينه إلى true للاختبار على Spark Plan (Free)
static const bool useMockMode = true; // تغيير إلى false عند نشر Firebase Functions
```

### 2. كيف يعمل Mock Mode:

#### عند `useMockMode = true`:
- ✅ **`createPaymentIntent()`**: ينشئ Mock Client Secret (لن يعمل فعلياً مع Stripe)
- ✅ **`confirmPayment()`**: يحاكي تأكيد الدفع بدون استدعاء Stripe فعلياً
- ✅ **الطلب**: سيتم إنشاؤه بنجاح في Firestore
- ⚠️ **الدفع**: لن يتم الدفع الفعلي - للاختبار فقط

#### عند `useMockMode = false`:
- ✅ يستخدم Firebase Functions الحقيقي
- ✅ يستدعي Stripe فعلياً
- ✅ يتم الدفع الفعلي

---

## 📝 كيفية الاستخدام:

### للاختبار على Spark Plan (Free):

1. **افتح `lib/core/services/stripe_service.dart`**
2. **تأكد من:**
   ```dart
   static const bool useMockMode = true;
   ```
3. **شغّل التطبيق واختبر الدفع بالبطاقة**
4. **النتيجة:**
   - ✅ سيتم إنشاء الطلب بنجاح
   - ✅ سيتم حفظه في Firestore
   - ⚠️ لن يتم الدفع الفعلي (Mock فقط)

### للإنتاج (بعد الترقية إلى Blaze Plan):

1. **افتح `lib/core/services/stripe_service.dart`**
2. **غيّر إلى:**
   ```dart
   static const bool useMockMode = false;
   ```
3. **نشر Firebase Functions:**
   ```bash
   cd functions
   npm install
   firebase deploy --only functions
   ```
4. **تكوين Stripe Secret Key:**
   ```bash
   firebase functions:config:set stripe.secret="sk_test_YOUR_STRIPE_SECRET_KEY"
   ```

---

## 🔍 ما يحدث في Mock Mode:

### 1. `createPaymentIntent()`:
```dart
// ينشئ Mock Client Secret
final mockClientSecret = 'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret_'
    '${amountCents}_$currency';

print('⚠️ [MOCK MODE] تم إنشاء Mock PaymentIntent');
```

### 2. `confirmPayment()`:
```dart
// يحاكي تأكيد الدفع بدون Stripe فعلي
await Future.delayed(const Duration(seconds: 2));
print('⚠️ [MOCK MODE] تم تأكيد Mock Payment');
```

### 3. إنشاء الطلب:
- ✅ يتم إنشاء الطلب بنجاح في Firestore
- ✅ `paymentMethod: 'stripe'`
- ✅ `status: 'pending'`

---

## ⚠️ ملاحظات مهمة:

### 1. Mock Mode للاختبار فقط:
- ⚠️ **لا يتم الدفع الفعلي**
- ⚠️ **لن يتم خصم أي أموال**
- ⚠️ **لن يعمل مع Stripe فعلياً**

### 2. عند الترقية إلى Blaze Plan:
- ✅ غيّر `useMockMode = false`
- ✅ انشر Firebase Functions
- ✅ اختبر الدفع الفعلي

### 3. في الإنتاج:
- ❌ **لا تستخدم Mock Mode في الإنتاج**
- ✅ استخدم Firebase Functions الحقيقي
- ✅ تأكد من نشر Functions قبل الإطلاق

---

## 📋 قائمة التحقق:

### للاختبار (Spark Plan):
- [x] ✅ `useMockMode = true`
- [x] ✅ اختبر إنشاء الطلب
- [x] ✅ تحقق من حفظ الطلب في Firestore
- [x] ✅ تحقق من Console Logs (MOCK MODE)

### للإنتاج (Blaze Plan):
- [ ] ⚠️ `useMockMode = false`
- [ ] ⚠️ نشر Firebase Functions
- [ ] ⚠️ تكوين Stripe Secret Key
- [ ] ⚠️ اختبار الدفع الفعلي
- [ ] ⚠️ التحقق من Webhooks

---

## 🎯 الخطوات التالية:

### الآن (Spark Plan):
1. ✅ **تم تفعيل Mock Mode** ✅
2. ✅ **يمكنك اختبار التدفق الكامل** ✅
3. ✅ **الطلبات ستُحفظ في Firestore** ✅

### لاحقاً (عند الترقية):
1. ⚠️ **ترقية إلى Blaze Plan**
2. ⚠️ **تعطيل Mock Mode**
3. ⚠️ **نشر Firebase Functions**
4. ⚠️ **اختبار الدفع الفعلي**

---

## ✅ الحالة:

- ✅ **Mock Mode:** مفعّل للاختبار
- ✅ **الطلبات:** تُحفظ في Firestore
- ⚠️ **الدفع:** Mock فقط (لن يتم الدفع الفعلي)
- ⚠️ **Firebase Functions:** غير متاح في Spark Plan

---

**تاريخ الإضافة:** 2025-01-11  
**الحالة:** ✅ Mock Mode جاهز للاختبار على Spark Plan

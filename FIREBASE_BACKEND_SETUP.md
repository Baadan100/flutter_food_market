# دليل إعداد Firebase Backend API للدفع بالبطاقة 💳

## 📋 نظرة عامة

تم إنشاء Firebase Functions كاملة لدعم:
1. ✅ إنشاء PaymentIntent من Stripe
2. ✅ إرسال بريد إلكتروني مع الفاتورة
3. ✅ Webhook لمعالجة أحداث Stripe

---

## ✅ ما تم إنجازه:

### 1. Firebase Functions ✅
- ✅ `createPaymentIntent` - إنشاء PaymentIntent
- ✅ `sendOrderInvoice` - إرسال بريد إلكتروني مع الفاتورة
- ✅ `stripeWebhook` - معالجة أحداث Stripe تلقائياً

### 2. تحديث Stripe Service ✅
- ✅ استخدام Firebase Functions بدلاً من HTTP REST API
- ✅ تحديث `createPaymentIntent` لاستخدام `cloud_functions`

### 3. تحديث Checkout Page ✅
- ✅ ربط الدفع بـ Stripe مع إنشاء الطلب
- ✅ إرسال الفاتورة بالبريد بعد نجاح الطلب

---

## 🔧 الخطوات المطلوبة لإكمال الإعداد:

### الخطوة 1: تثبيت Packages

```bash
cd functions
npm install
cd ..
flutter pub get
```

### الخطوة 2: إعداد Stripe Keys في Firebase

```bash
# من Terminal في مجلد المشروع الرئيسي
firebase functions:config:set stripe.secret="sk_test_YOUR_SECRET_KEY"
firebase functions:config:set stripe.webhook_secret="whsec_YOUR_WEBHOOK_SECRET"
```

**ملاحظة:** 
- احصل على `Secret Key` من [Stripe Dashboard](https://dashboard.stripe.com/apikeys)
- احصل على `Webhook Secret` من Stripe Dashboard → Developers → Webhooks

### الخطوة 3: إعداد SendGrid لإرسال البريد (اختياري)

يمكنك استخدام SendGrid لإرسال البريد الإلكتروني:

```bash
npm install --save @sendgrid/mail
```

أو استخدام Firebase Extensions:
- اذهب إلى Firebase Console → Extensions
- ابحث عن "Send Emails with SendGrid" أو "Trigger Email"

### الخطوة 4: Build و Deploy Functions

```bash
cd functions
npm run build
cd ..
firebase deploy --only functions
```

### الخطوة 5: إعداد Stripe Webhook

1. اذهب إلى [Stripe Dashboard](https://dashboard.stripe.com/webhooks)
2. اضغط "Add endpoint"
3. URL: `https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/stripeWebhook`
4. Events: اختر `payment_intent.succeeded` و `payment_intent.payment_failed`
5. انسخ Webhook Secret
6. قم بتحديث `stripe.webhook_secret` في Firebase

---

## 📧 إرسال البريد الإلكتروني

### الخيار 1: استخدام SendGrid (مقترح)

```typescript
// في functions/src/index.ts
import sgMail from '@sendgrid/mail';

sgMail.setApiKey(functions.config().sendgrid?.api_key || '');

// في sendOrderInvoice function:
await sgMail.send({
  to: userEmail,
  from: 'noreply@yourdomain.com',
  subject: 'فاتورة الطلب - كنوز البحر',
  html: emailContent,
});
```

### الخيار 2: استخدام Firebase Extensions (أسهل)

- اذهب إلى Firebase Console → Extensions
- ابحث عن "Trigger Email"
- فعّل Extension واربطه بـ Firestore collection `orders`
- سيتم إرسال البريد تلقائياً عند إنشاء طلب جديد

---

## 🔄 تدفق العملية:

1. **العميل يختار الدفع بالبطاقة** في Checkout Page
2. **التطبيق يستدعي `createPaymentIntent`** من Firebase Functions
3. **Stripe يرجع `clientSecret`**
4. **العميل يكمل الدفع** في Stripe Payment Sheet
5. **بعد نجاح الدفع:**
   - يتم إنشاء الطلب في Firestore
   - يتم إرسال البريد الإلكتروني مع الفاتورة
   - يتم تحديث حالة الطلب تلقائياً عبر Webhook

---

## 📝 تحديث Admin Dashboard:

تم تحديث Order Model لعرض `paymentMethod`:
- `cash_on_delivery` - الدفع عند الاستلام
- `stripe` - الدفع بالبطاقة المصرفية

في Admin Dashboard، يمكن عرض نوع الدفع في:
- قائمة الطلبات
- صفحة تفاصيل الطلب

---

## ⚠️ ملاحظات مهمة:

1. **Secret Key** يجب أن يكون في Firebase Functions Config (لا تضعه في التطبيق!)
2. **Webhook Secret** ضروري لتأكيد الأحداث من Stripe
3. **SendGrid** أو **Firebase Extensions** مطلوبة لإرسال البريد
4. تأكد من نشر Functions قبل استخدامها

---

## 🚀 الحالة الحالية:

- ✅ Firebase Functions جاهزة
- ✅ Stripe Service محدث
- ✅ Checkout Page مرتبط
- ⚠️ يحتاج Deploy Functions
- ⚠️ يحتاج إعداد SendGrid (اختياري)

---

**تاريخ الإنشاء:** 2025-01-11  
**الحالة:** ✅ الكود جاهز | ⚠️ يحتاج Deploy و إعداد

# متطلبات ربط Firebase - Migration Requirements

## 📋 معلومات مطلوبة منك قبل البدء

### 1. ✅ **Firebase Configuration (جاهز)**
   - ✅ `google-services.json` موجود في `android/app/`
   - ✅ `GoogleService-Info.plist` موجود في `ios/Runner/`
   - ✅ Firebase Web SDK مُضاف في `web/index.html`
   - ✅ Firebase config موجود في `web/index.html`

### 2. ⚠️ **Firebase Dependencies (مطلوب إضافة)**
   يجب إضافة هذه الحزم إلى `pubspec.yaml`:
   ```yaml
   dependencies:
     firebase_core: ^3.6.0
     firebase_auth: ^5.3.1
     cloud_firestore: ^5.4.4
     firebase_storage: ^12.3.4
   ```

### 3. 📊 **Firestore Collections Structure (مطلوب تأكيد)**

   **أ) مجموعة `products`:**
   ```
   products/
     {productId}/
       - id: string
       - nameAr: string
       - nameEn: string (optional)
       - imageUrl: string (URL من Firebase Storage)
       - priceCents: number
       - descriptionAr: string (optional)
       - descriptionEn: string (optional)
       - category: string ('fish', 'seafood', 'shrimp', 'grilled', 'family_meals')
       - createdAt: timestamp
       - updatedAt: timestamp
   ```

   **ب) مجموعة `orders`:**
   ```
   orders/
     {orderId}/
       - id: string
       - userId: string
       - userName: string
       - userPhone: string
       - deliveryAddress: string
       - notes: string (optional)
       - items: array of maps
         - productId: string
         - nameAr: string
         - nameEn: string
         - imageUrl: string
         - priceCents: number
         - quantity: number
       - totalCents: number
       - paymentMethod: string
       - status: string ('pending', 'confirmed', 'preparing', 'delivering', 'delivered', 'cancelled')
       - createdAt: timestamp
       - updatedAt: timestamp
   ```

   **ج) مجموعة `users` (اختياري - لتخزين بيانات إضافية):**
   ```
   users/
     {userId}/
       - id: string
       - email: string
       - name: string (optional)
       - phone: string (optional)
       - createdAt: timestamp
   ```

### 4. 🔐 **Firebase Authentication Methods (مطلوب تأكيد)**
   - ✅ Email/Password Authentication
   - ✅ Anonymous Sign-in (هل تريده؟)
   - ❓ Google Sign-in (هل تريده؟)
   - ❓ Phone Authentication (هل تريده؟)

### 5. 🖼️ **Firebase Storage Structure (مطلوب تأكيد)**
   **هيكل المجلدات:**
   ```
   storage/
     products/
       {productId}/
         - main.jpg (الصورة الرئيسية)
         - thumbnail.jpg (اختياري - صورة مصغرة)
   ```

   **أو:**
   ```
   storage/
     products/
       - {productId}.jpg
   ```

### 6. 📝 **Firestore Security Rules (مطلوب إعداد)**
   يجب إعداد قواعد الأمان في Firebase Console:
   
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Products: قراءة عامة، كتابة للمسؤولين فقط
       match /products/{productId} {
         allow read: if true;
         allow write: if request.auth != null && 
                       get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
       }
       
       // Orders: المستخدم يقرأ/يكتب طلباته فقط
       match /orders/{orderId} {
         allow read, write: if request.auth != null && 
                             resource.data.userId == request.auth.uid;
         allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
       }
       
       // Users: المستخدم يقرأ/يكتب بياناته فقط
       match /users/{userId} {
         allow read, write: if request.auth != null && 
                            request.auth.uid == userId;
       }
     }
   }
   ```

### 7. 🔄 **Migration Strategy (اختيار واحد)**
   
   **الخيار 1: Migration تدريجي (مُوصى به)**
   - الاحتفاظ بـ Mock Data كـ fallback
   - إضافة Firebase كـ primary source
   - إمكانية التبديل بين Mock/Firebase عبر feature flag
   
   **الخيار 2: Migration كامل**
   - إزالة Mock Data تماماً
   - الاعتماد الكامل على Firebase
   - أسرع لكن أقل مرونة

### 8. ⚠️ **Error Handling Strategy (مطلوب تأكيد)**
   كيف تريد التعامل مع الأخطاء؟
   - عرض رسائل خطأ بالعربية؟
   - إعادة المحاولة التلقائية؟
   - حفظ محلي مؤقت عند فشل الاتصال؟
   - Offline support (Firestore offline persistence)؟

### 9. 📱 **Image Loading Strategy (مطلوب تأكيد)**
   - استخدام `cached_network_image` فقط؟
   - إضافة placeholder أثناء التحميل؟
   - إضافة error widget عند فشل التحميل؟
   - استخدام Firebase Storage URLs مباشرة؟

### 10. 🧪 **Testing Data (مطلوب)**
   هل تريد:
   - بيانات تجريبية في Firestore للاختبار؟
   - أو سأضيف بيانات تجريبية تلقائياً عند أول تشغيل؟

---

## ✅ ما سأقوم به بعد تأكيد المتطلبات

1. **إضافة Firebase Dependencies** إلى `pubspec.yaml`
2. **إنشاء Repository Layer:**
   - `FirebaseAuthRepository` (بدلاً من Mock)
   - `FirestoreProductRepository`
   - `FirestoreOrderRepository`
3. **تحديث Domain Models:**
   - إضافة `fromFirestore()` و `toFirestore()` لجميع الـ Models
4. **تحديث Providers:**
   - `AuthController` → استخدام `authStateChanges()`
   - `ProductsProvider` → `StreamProvider` من Firestore
   - `OrderController` → حفظ في Firestore
5. **تحديث UI:**
   - استخدام `CachedNetworkImage` للصور
   - إضافة Error Handling و Loading States
6. **إضافة Error Handling:**
   - معالجة أخطاء الشبكة
   - معالجة أخطاء المصادقة
   - معالجة أخطاء Firestore

---

## 📝 ملاحظات مهمة

- ⚠️ **لا توجد بيانات في Firestore حالياً** - سأحتاج إما:
  - بيانات تجريبية منك
  - أو سأضيف وظيفة لإنشاء بيانات تجريبية تلقائياً
  
- ⚠️ **Security Rules** يجب إعدادها في Firebase Console قبل الإطلاق

- ⚠️ **Storage Rules** يجب إعدادها في Firebase Console

- ✅ **Clean Architecture** سأحافظ على النمط الحالي

---

## 🚀 الخطوات التالية

**يرجى الإجابة على:**
1. ✅ هل تريد Anonymous Sign-in؟
2. ❓ هل تريد Google/Phone Sign-in؟
3. ❓ هيكل Firebase Storage للصور (أي خيار تفضل؟)
4. ❓ Migration Strategy (تدريجي أم كامل؟)
5. ❓ Error Handling (كيف تريد التعامل مع الأخطاء؟)
6. ❓ هل لديك بيانات تجريبية في Firestore أم أضيفها تلقائياً؟

**بعد الإجابة، سأبدأ التنفيذ فوراً! 🎯**

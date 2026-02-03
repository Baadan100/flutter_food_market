# تحديث Firebase Security Rules 🔒

## ⚠️ المشكلة:

```
[cloud_firestore/permission-denied] Missing or insufficient permissions.
```

**السبب:** دالة `isAdmin()` كانت تستخدم `request.auth.token.admin == true` بدلاً من التحقق من Firestore.

---

## ✅ الحل المطبق:

### تحديث دالة `isAdmin()`:

**قبل (خطأ):**
```javascript
function isAdmin() {
  return isSignedIn() && request.auth.token.admin == true;
}
```

**بعد (صحيح):**
```javascript
function isAdmin() {
  return isSignedIn() && 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
}
```

### تحديث Orders Rules:

تم تبسيط قواعد Orders:

```javascript
// Orders
match /orders/{orderId} {
  // القراءة: المستخدم يقرأ طلباته، أو Admin يقرأ الكل
  allow read: if request.auth != null && 
    (resource.data.userId == request.auth.uid || isAdmin());

  // الإنشاء: المستخدم يمكنه إنشاء طلب له فقط
  allow create: if request.auth != null && 
    request.resource.data.userId == request.auth.uid;

  // التحديث: المستخدم يحدث طلبه، أو Admin يحدث أي طلب
  allow update: if request.auth != null && 
    (resource.data.userId == request.auth.uid || isAdmin());

  // الحذف: Admin فقط
  allow delete: if isAdmin();
}
```

---

## 📋 القواعد الكاملة المحدثة:

تم حفظ القواعد الصحيحة في `FIRESTORE_RULES_FIXED.rules`

يمكنك نسخها واستخدامها في Firebase Console.

---

## 🔧 الخطوات:

### 1. تحديث القواعد في Firebase Console:

1. افتح [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك `seafood-marketplace-c98ae`
3. انتقل إلى **Firestore Database** > **Rules**
4. استبدل القواعد بالكود الجديد من `firestore.rules` أو `FIRESTORE_RULES_FIXED.rules`
5. اضغط **Publish**

### 2. التحقق من بيانات المستخدم Admin:

تأكد من أن المستخدم Admin لديه وثيقة في Firestore:

```
Collection: users
Document ID: {user_uid}
Fields:
  - email: "admin@example.com"
  - role: "admin"  ← يجب أن يكون lowercase 'admin'
  - name: "Admin Name" (optional)
```

**⚠️ مهم:** يجب أن يكون `role: 'admin'` وليس `role: 'Admin'` أو `admin: true`

---

## ✅ النتيجة:

بعد تحديث القواعد:
- ✅ Admin Dashboard سيعمل بشكل صحيح
- ✅ Admin يمكنه قراءة جميع الطلبات
- ✅ المستخدمون العاديون يمكنهم قراءة/كتابة طلباتهم فقط
- ✅ المنتجات قابلة للقراءة للجميع، الكتابة للـ Admin فقط

---

## ⚠️ ملاحظات:

### 1. استخدام `get()` في Security Rules:
- `get()` يزيد من عدد القراءات في Firestore
- هذا مقبول للإنتاج، ولكن احسب التكلفة

### 2. الأداء:
- كل مرة يتم استدعاء `isAdmin()`، يتم قراءة وثيقة `users/{uid}`
- Firebase يخزن هذه القراءة في cache لفترة قصيرة

### 3. الأمان:
- ✅ `role` محمي من التعديل من قبل المستخدمين العاديين
- ✅ Admin فقط يمكنه تغيير `role` في وثيقة المستخدم

---

**تاريخ التحديث:** 2025-01-11  
**الحالة:** ✅ جاهز للتطبيق في Firebase Console

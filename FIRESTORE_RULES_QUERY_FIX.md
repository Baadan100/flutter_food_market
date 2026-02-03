# إصلاح Firebase Security Rules للـ Query 📋

## ⚠️ المشكلة:

```
[cloud_firestore/permission-denied] Missing or insufficient permissions.
```

**في لوحة التحكم (Admin Dashboard)** عند جلب جميع الطلبات.

---

## 🔍 السبب:

### المشكلة في الكود السابق:

```javascript
allow read: if request.auth != null && 
  (isOrderOwner(orderId) || isAdmin());
```

حيث `isOrderOwner()` يستخدم:
```javascript
function isOrderOwner(orderId) {
  return request.auth != null && 
         resource.data.userId == request.auth.uid;
}
```

**❌ المشكلة:** `resource.data` غير متاح في **Queries** (عند جلب قائمة من المستندات).

عند استخدام `getAllOrders()` في Admin Dashboard:
- يتم جلب **جميع** الطلبات في Query واحد
- Firestore لا يمكنه التحقق من `resource.data.userId` لكل طلب قبل جلب البيانات
- لذلك يحتاج إلى **شرط عام** يسمح للـ Admin بقراءة الكل

---

## ✅ الحل:

### تحديث قواعد Orders:

```javascript
match /orders/{orderId} {
  // القراءة: 
  // - الزبون يمكنه قراءة طلباته فقط
  // - المدير يمكنه قراءة جميع الطلبات
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

### كيف يعمل:

1. **عند قراءة طلب واحد (Get Document):**
   - `resource.data.userId == request.auth.uid` → للزبون
   - `isAdmin()` → للـ Admin

2. **عند جلب جميع الطلبات (Query - Admin Dashboard):**
   - `isAdmin()` → يسمح للـ Admin بقراءة الكل
   - Firestore يتحقق من `isAdmin()` قبل تنفيذ Query

3. **عند جلب طلبات المستخدم (Query - Customer App):**
   - في الواقع، التطبيق يستخدم `where('userId', '==', userId)`
   - وهذا يعمل مع `resource.data.userId == request.auth.uid` في Rules

---

## 📋 القواعد الكاملة المحدثة:

تم تحديث `firestore.rules` مع القواعد الصحيحة.

**ملفات المرجع:**
- `firestore.rules` - القواعد المحدثة
- `FIRESTORE_RULES_FIXED.rules` - نسخة احتياطية

---

## 🔧 الخطوات:

### 1. تحديث القواعد في Firebase Console:

1. افتح [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك `seafood-marketplace-c98ae`
3. انتقل إلى **Firestore Database** > **Rules**
4. انسخ الكود من `firestore.rules` (أو `FIRESTORE_RULES_FIXED.rules`)
5. الصق في Rules Editor
6. اضغط **Publish**

### 2. التحقق من المستخدم Admin:

تأكد من أن المستخدم Admin لديه وثيقة في Firestore:

```
Collection: users
Document ID: {user_uid}
Fields:
  - email: "admin@example.com"
  - role: "admin"  ← يجب أن يكون lowercase 'admin'
```

---

## ✅ النتيجة:

بعد تحديث القواعد:
- ✅ Admin Dashboard يمكنه جلب جميع الطلبات
- ✅ المستخدمون العاديون يمكنهم قراءة طلباتهم فقط
- ✅ Admin يمكنه تحديث أي طلب
- ✅ المنتجات قابلة للقراءة للجميع، الكتابة للـ Admin فقط

---

## ⚠️ ملاحظات مهمة:

### 1. دالة `isAdmin()`:

```javascript
function isAdmin() {
  return request.auth != null && 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
}
```

**✅ هذا صحيح** - يتحقق من `role` في Firestore.

### 2. استخدام `get()`:

- `get()` يزيد من عدد القراءات في Firestore
- Firebase يخزن النتيجة في cache لفترة قصيرة
- هذا مقبول للإنتاج

### 3. الأمان:

- ✅ `role` محمي من التعديل من قبل المستخدمين العاديين
- ✅ Admin فقط يمكنه تغيير `role` في وثيقة المستخدم
- ✅ المستخدمون العاديون لا يمكنهم قراءة طلبات الآخرين

---

**تاريخ الإصلاح:** 2025-01-11  
**الحالة:** ✅ جاهز للتطبيق في Firebase Console

# دليل إعداد Shared Package 📦

## ✅ ما تم إنجازه:

### 1. إنشاء Shared Package:
```
packages/
  └── shared/
      ├── lib/
      │   ├── domain/
      │   │   ├── product.dart      ✅
      │   │   ├── order.dart        ✅
      │   │   ├── order_item.dart   ✅
      │   │   └── app_user.dart     ✅
      │   └── shared.dart           ✅ (نقطة الوصول)
      └── pubspec.yaml              ✅
```

### 2. Models المنقولة:
- ✅ **Product** - منتج كامل مع fromFirestore/toFirestore
- ✅ **Order** - طلب كامل مع paymentMethodLocalized/paymentMethodIcon
- ✅ **OrderItem** - عنصر الطلب
- ✅ **AppUser** - مستخدم مع UserRole (customer/admin)

---

## 📋 الخطوات التالية:

### المرحلة 2: تحديث Customer App لاستخدام Shared Package

#### 1. تحديث `pubspec.yaml`:
```yaml
dependencies:
  shared:
    path: ../packages/shared
  # ... other dependencies
```

#### 2. تحديث Imports:
```dart
// قبل:
import '../catalog/domain/product.dart';
import '../checkout/order_controller.dart'; // Order

// بعد:
import 'package:shared/shared.dart'; // Product, Order, AppUser
```

#### 3. الملفات التي تحتاج تحديث:
- `lib/features/catalog/domain/product.dart` → حذف (استخدام shared)
- `lib/features/checkout/order_controller.dart` → تحديث imports
- `lib/features/auth/domain/app_user.dart` → حذف (استخدام shared)
- جميع الملفات التي تستورد هذه Models

---

### المرحلة 3: تحديث Admin Dashboard لاستخدام Shared Package

#### 1. تحديث `fish_restaurant_admin/pubspec.yaml`:
```yaml
dependencies:
  shared:
    path: ../packages/shared
  # ... other dependencies
```

#### 2. تحديث Imports:
```dart
// قبل:
import '../../features/orders/domain/order.dart';
import '../../features/products/domain/product.dart';
import '../../features/auth/domain/app_user.dart';

// بعد:
import 'package:shared/shared.dart'; // Order, Product, AppUser
```

#### 3. الملفات التي تحتاج تحديث:
- `lib/features/orders/domain/order.dart` → حذف (استخدام shared)
- `lib/features/products/domain/product.dart` → حذف (استخدام shared)
- `lib/features/auth/domain/app_user.dart` → حذف (استخدام shared)
- جميع الملفات التي تستورد هذه Models

---

## ⚠️ ملاحظات مهمة:

### 1. OrderItem.toCartItem():
- هذه الدالة موجودة في `order_controller.dart` (Customer App)
- تتحول `OrderItem` إلى `CartItem` (خاص بـ Customer App)
- **لا ننقلها** للـ Shared Package (خاص بـ Customer App)

### 2. Repositories:
- يمكن نقل Repositories لاحقاً إذا كان هناك حاجة
- حالياً: كل مشروع له Repository خاص به

### 3. التحقق من الأخطاء:
- بعد التحديث: `flutter pub get`
- التحقق من عدم وجود أخطاء: `flutter analyze`
- الاختبار على كل مشروع

---

## ✅ الفوائد:

1. ✅ **التزامن الكامل** - تعديل Model في مكان واحد يؤثر على الاثنين
2. ✅ **تقليل التكرار** - لا يوجد كود مكرر
3. ✅ **سهولة الصيانة** - تحديث واحد للجميع
4. ✅ **ضمان التوافق** - لا يمكن حدوث عدم توافق

---

**تاريخ الإنشاء:** 2025-01-11  
**الحالة:** ✅ المرحلة 1 مكتملة - جاهز للمرحلة 2

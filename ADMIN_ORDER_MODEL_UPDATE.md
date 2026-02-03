# تحديث Order Model في لوحة التحكم 💳

## 📝 الكود المطلوب إضافته:

بعد دالة `statusLocalized` في Order Model، أضف هذا الكود:

```dart
String get statusLocalized {
  switch (status) {
    case 'pending':
      return 'قيد الانتظار';
    case 'confirmed':
      return 'تم التأكيد';
    case 'preparing':
      return 'قيد التحضير';
    case 'delivering':
      return 'قيد التوصيل';
    case 'delivered':
      return 'تم التسليم';
    case 'cancelled':
      return 'ملغي';
    default:
      return status;
  }
}

// ⬇️ أضف هذا الكود بعد statusLocalized ⬇️

/// الحصول على نص طريقة الدفع بالعربية
String get paymentMethodLocalized {
  switch (paymentMethod) {
    case 'cash_on_delivery':
      return 'الدفع عند الاستلام';
    case 'stripe':
      return 'الدفع بالبطاقة المصرفية';
    default:
      return paymentMethod;
  }
}

/// الحصول على أيقونة طريقة الدفع
IconData get paymentMethodIcon {
  switch (paymentMethod) {
    case 'cash_on_delivery':
      return Icons.payments;
    case 'stripe':
      return Icons.credit_card;
    default:
      return Icons.payment;
  }
}
```

---

## ⚠️ ملاحظات مهمة:

### 1. تأكد من إضافة Import:

في أعلى الملف (`order.dart`)، تأكد من وجود:

```dart
import 'package:flutter/material.dart';
```

إذا لم يكن موجوداً، أضفه في بداية الملف.

---

## 📋 الخطوات الكاملة:

### 1. افتح الملف:
```
fish_restaurant_admin/lib/features/orders/domain/order.dart
```

### 2. ابحث عن:
```dart
String get statusLocalized {
  // ... الكود الحالي ...
}
```

### 3. أضف بعد `statusLocalized`:
```dart
/// الحصول على نص طريقة الدفع بالعربية
String get paymentMethodLocalized {
  switch (paymentMethod) {
    case 'cash_on_delivery':
      return 'الدفع عند الاستلام';
    case 'stripe':
      return 'الدفع بالبطاقة المصرفية';
    default:
      return paymentMethod;
  }
}

/// الحصول على أيقونة طريقة الدفع
IconData get paymentMethodIcon {
  switch (paymentMethod) {
    case 'cash_on_delivery':
      return Icons.payments;
    case 'stripe':
      return Icons.credit_card;
    default:
      return Icons.payment;
  }
}
```

### 4. تأكد من Import:
```dart
import 'package:flutter/material.dart';
```

---

## ✅ النتيجة النهائية:

بعد التحديث، سيكون لديك:

```dart
class Order {
  // ... الحقول الأخرى ...
  
  String get statusLocalized {
    // ... الكود الحالي ...
  }

  /// الحصول على نص طريقة الدفع بالعربية
  String get paymentMethodLocalized {
    switch (paymentMethod) {
      case 'cash_on_delivery':
        return 'الدفع عند الاستلام';
      case 'stripe':
        return 'الدفع بالبطاقة المصرفية';
      default:
        return paymentMethod;
    }
  }

  /// الحصول على أيقونة طريقة الدفع
  IconData get paymentMethodIcon {
    switch (paymentMethod) {
      case 'cash_on_delivery':
        return Icons.payments;
      case 'stripe':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }
}
```

---

## 🎯 الاستخدام:

بعد إضافة هذه الدوال، يمكنك استخدامها في:

1. **Orders Page:**
   ```dart
   Text(order.paymentMethodLocalized)
   Icon(order.paymentMethodIcon)
   ```

2. **Order Details Page:**
   ```dart
   Text(order.paymentMethodLocalized)
   Icon(order.paymentMethodIcon)
   ```

---

**تاريخ الإنشاء:** 2025-01-11  
**الحالة:** ✅ جاهز للتطبيق

# دليل عرض طريقة الدفع في الطلبات 💳

## ✅ ما تم إضافته:

### 1. في Order Model (`lib/features/checkout/order_controller.dart`):

تم إضافة:
- `paymentMethodLocalized`: دالة للحصول على نص طريقة الدفع بالعربية
- `paymentMethodIcon`: دالة للحصول على أيقونة طريقة الدفع

```dart
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

### 2. في صفحة الطلبات (`lib/features/orders/orders_page.dart`):

#### في `_OrderCard`:
- ✅ إضافة عرض طريقة الدفع تحت عدد العناصر
- ✅ أيقونة + نص طريقة الدفع

#### في `OrderDetailsPage`:
- ✅ تحديث قسم Payment Information لعرض طريقة الدفع بشكل واضح
- ✅ Badge ملون حسب نوع الدفع:
  - 🟢 أخضر للدفع عند الاستلام
  - 🔵 أزرق للدفع بالبطاقة

---

## 📋 كيفية التحديث في Admin Dashboard:

### 1. تحديث Order Model في Admin Dashboard:

في `fish_restaurant_admin/lib/features/orders/domain/order.dart`:

أضف نفس الدوال:

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

**ملاحظة:** تأكد من إضافة `import 'package:flutter/material.dart';` في أعلى الملف.

### 2. تحديث Orders Page في Admin Dashboard:

في `fish_restaurant_admin/lib/features/orders/presentation/orders_page.dart`:

#### في ListTile (قائمة الطلبات):

```dart
ListTile(
  title: Text('طلب #${order.id.substring(0, 8)}'),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${order.userName} - ${order.totalCents / 100} ر.س'),
      const SizedBox(height: 4),
      Row(
        children: [
          Icon(order.paymentMethodIcon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            order.paymentMethodLocalized,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ],
  ),
  trailing: Chip(
    label: Text(order.statusLocalized),
    backgroundColor: _getStatusColor(order.status),
  ),
  onTap: () => context.go('/orders/${order.id}'),
),
```

### 3. تحديث Order Details Page في Admin Dashboard:

في `fish_restaurant_admin/lib/features/orders/presentation/order_details_page.dart`:

#### في قسم Payment Information:

```dart
// Payment Information Card
Card(
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات الدفع',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  order.paymentMethodIcon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text('طريقة الدفع'),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: order.paymentMethod == 'stripe'
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: order.paymentMethod == 'stripe'
                      ? Colors.blue
                      : Colors.green,
                  width: 1,
                ),
              ),
              child: Text(
                order.paymentMethodLocalized,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: order.paymentMethod == 'stripe'
                      ? Colors.blue
                      : Colors.green,
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الإجمالي'),
            Text(
              '${(order.totalCents / 100).toStringAsFixed(2)} ر.س',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),
```

---

## ✅ الحالة الحالية:

### في التطبيق الرئيسي (Customer App):
- ✅ `Order Model`: يحتوي على `paymentMethodLocalized` و `paymentMethodIcon`
- ✅ `Orders Page`: يعرض طريقة الدفع في `_OrderCard`
- ✅ `Order Details Page`: يعرض طريقة الدفع بشكل واضح مع Badge ملون

### في Admin Dashboard:
- ⚠️ يحتاج تحديث Order Model
- ⚠️ يحتاج تحديث Orders Page
- ⚠️ يحتاج تحديث Order Details Page

---

## 🎯 الخطوات التالية:

### للتطبيق الرئيسي:
- ✅ **مكتمل** ✅

### لـ Admin Dashboard:
1. ⚠️ تحديث `fish_restaurant_admin/lib/features/orders/domain/order.dart`
2. ⚠️ تحديث `fish_restaurant_admin/lib/features/orders/presentation/orders_page.dart`
3. ⚠️ تحديث `fish_restaurant_admin/lib/features/orders/presentation/order_details_page.dart`

---

## 📝 ملاحظات:

### أنواع الدفع المدعومة:
- `cash_on_delivery`: الدفع عند الاستلام
- `stripe`: الدفع بالبطاقة المصرفية

### الألوان المستخدمة:
- 🟢 **أخضر** للدفع عند الاستلام (`cash_on_delivery`)
- 🔵 **أزرق** للدفع بالبطاقة (`stripe`)

---

**تاريخ الإضافة:** 2025-01-11  
**الحالة:** ✅ مكتمل في التطبيق الرئيسي - ⚠️ يحتاج تحديث في Admin Dashboard

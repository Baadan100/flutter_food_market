# تحديث لوحة التحكم لعرض طريقة الدفع 💳

## 📋 الملفات المطلوب تحديثها:

### 1. Order Model في Admin Dashboard

**الملف:** `fish_restaurant_admin/lib/features/orders/domain/order.dart`

**أضف هذه الدوال:**

```dart
import 'package:flutter/material.dart'; // تأكد من إضافة هذا

// ... داخل class Order ...

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

### 2. Orders Page (قائمة الطلبات)

**الملف:** `fish_restaurant_admin/lib/features/orders/presentation/orders_page.dart`

**تحديث ListTile:**

```dart
ListView.builder(
  itemCount: orders.length,
  itemBuilder: (context, index) {
    final order = orders[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('طلب #${order.id.substring(0, 8)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${order.userName} - ${(order.totalCents / 100).toStringAsFixed(2)} ر.س'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  order.paymentMethodIcon,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  order.paymentMethodLocalized,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
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
    );
  },
)
```

---

### 3. Order Details Page (تفاصيل الطلب)

**الملف:** `fish_restaurant_admin/lib/features/orders/presentation/order_details_page.dart`

**أضف قسم Payment Information:**

```dart
// بعد قسم Customer Information، أضف:

const SizedBox(height: 16),

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
            Text(
              'الإجمالي',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${(order.totalCents / 100).toStringAsFixed(2)} ر.س',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
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

## ✅ الخطوات:

1. **افتح مشروع Admin Dashboard:**
   ```bash
   cd fish_restaurant_admin
   ```

2. **حدّث Order Model:**
   - افتح `lib/features/orders/domain/order.dart`
   - أضف `import 'package:flutter/material.dart';`
   - أضف `paymentMethodLocalized` و `paymentMethodIcon`

3. **حدّث Orders Page:**
   - افتح `lib/features/orders/presentation/orders_page.dart`
   - حدّث `ListTile` لعرض طريقة الدفع

4. **حدّث Order Details Page:**
   - افتح `lib/features/orders/presentation/order_details_page.dart`
   - أضف قسم Payment Information

5. **اختبر التحديثات:**
   ```bash
   flutter run -d chrome
   ```

---

## 🎨 الألوان المستخدمة:

- 🟢 **أخضر** للدفع عند الاستلام (`cash_on_delivery`)
- 🔵 **أزرق** للدفع بالبطاقة (`stripe`)

---

## ✅ الحالة:

- ✅ **Order Model:** يحتاج إضافة الدوال
- ✅ **Orders Page:** يحتاج تحديث ListTile
- ✅ **Order Details Page:** يحتاج إضافة قسم Payment Information

---

**تاريخ الإنشاء:** 2025-01-11  
**الحالة:** ⚠️ يحتاج تطبيق في Admin Dashboard

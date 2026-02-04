import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_core/firebase_core.dart';
import 'package:shared/shared.dart';
import '../../cart/domain/cart_item.dart';

/// Repository للتعامل مع طلبات Firestore
class FirestoreOrderRepository {
  FirebaseFirestore get _firestore {
    if (Firebase.apps.isEmpty) {
      throw StateError(
        'Firebase غير مهيأ. على iOS أضف GoogleService-Info.plist في ios/Runner.',
      );
    }
    return FirebaseFirestore.instance;
  }

  final String _collection = 'orders';

  /// إنشاء طلب جديد
  Future<Order> createOrder({
    required String userId,
    required String userName,
    required String userPhone,
    required String deliveryAddress,
    String? notes,
    required List<CartItem> items,
    required int totalCents,
    required String paymentMethod,
  }) async {
    try {
      // تحويل CartItem إلى Map
      final orderItems = items
          .map((item) => {
                'productId': item.product.id,
                'nameAr': item.product.nameAr,
                'nameEn': item.product.nameEn ?? item.product.nameAr,
                'imageUrl': item.product.imageAssetPath,
                'priceCents': item.product.priceCents,
                'quantity': item.quantity,
              })
          .toList();

      final orderData = {
        'userId': userId,
        'userName': userName,
        'userPhone': userPhone,
        'deliveryAddress': deliveryAddress,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        'items': orderItems,
        'totalCents': totalCents,
        'paymentMethod': paymentMethod,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(_collection).add(orderData);

      // جلب الطلب المُنشأ
      final doc = await docRef.get();
      return Order.fromFirestore(doc);
    } catch (e) {
      throw Exception('فشل إنشاء الطلب: $e');
    }
  }

  /// جلب جميع طلبات المستخدم
  Stream<List<Order>> getUserOrders(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // ترتيب الطلبات حسب createdAt (الأحدث أولاً) في Dart
      final orders =
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();

      // ترتيب حسب createdAt (الأحدث أولاً)
      orders.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt); // ترتيب تنازلي
      });

      return orders;
    });
  }

  /// جلب طلب واحد بالـ ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(orderId).get();
      if (!doc.exists) return null;
      return Order.fromFirestore(doc);
    } catch (e) {
      throw Exception('فشل جلب الطلب: $e');
    }
  }

  /// تحديث حالة الطلب
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('فشل تحديث حالة الطلب: $e');
    }
  }
}

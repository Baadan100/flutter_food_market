import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../cart/domain/cart_item.dart';
import 'data/firestore_order_repository.dart';

/// تحويل OrderItem إلى CartItem (للعرض)
/// ملاحظة: هذه الدالة خاصة بـ Customer App فقط
extension OrderItemToCartItem on OrderItem {
  CartItem toCartItem() {
    return CartItem(
      product: Product(
        id: productId,
        nameAr: nameAr,
        nameEn: nameEn,
        imageAssetPath: imageUrl,
        priceCents: priceCents,
      ),
      quantity: quantity,
    );
  }
}

class OrderState {
  final List<Order> orders;
  final bool isLoading;
  final String? errorMessage;

  OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OrderState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderController extends StateNotifier<OrderState> {
  final FirestoreOrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(OrderState());

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
      state = state.copyWith(isLoading: true, errorMessage: null);

      final order = await _orderRepository.createOrder(
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        deliveryAddress: deliveryAddress,
        notes: notes,
        items: items,
        totalCents: totalCents,
        paymentMethod: paymentMethod,
      );

      // إضافة الطلب إلى القائمة المحلية
      state = state.copyWith(
        orders: [order, ...state.orders],
        isLoading: false,
      );

      return order;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> loadOrders(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // جلب الطلبات من Firestore
      final ordersStream = _orderRepository.getUserOrders(userId);

      // الاستماع للـ stream وتحديث الحالة
      ordersStream.listen((orders) {
        state = state.copyWith(
          orders: orders,
          isLoading: false,
        );
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _orderRepository.updateOrderStatus(orderId, newStatus);

      // تحديث الحالة المحلية
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: newStatus);
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  List<Order> getOrdersByUser(String userId) {
    return state.orders.where((order) => order.userId == userId).toList();
  }
}

// Provider للـ OrderRepository
final orderRepositoryProvider = Provider<FirestoreOrderRepository>((ref) {
  return FirestoreOrderRepository();
});

// Provider للـ OrderController
final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderState>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return OrderController(repository);
});

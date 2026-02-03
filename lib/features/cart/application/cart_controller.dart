import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../domain/cart_item.dart';

class CartState {
  final List<CartItem> items;
  const CartState({this.items = const []});

  int get totalCents => items.fold(0, (sum, it) => sum + it.lineTotalCents);
  int get totalQuantity => items.fold(0, (sum, it) => sum + it.quantity);
}

class CartController extends StateNotifier<CartState> {
  CartController() : super(const CartState());

  void add(Product product, {int quantity = 1}) {
    final index = state.items.indexWhere((it) => it.product.id == product.id);
    if (index == -1) {
      state = CartState(items: [
        ...state.items,
        CartItem(product: product, quantity: quantity)
      ]);
    } else {
      final updated = state.items[index]
          .copyWith(quantity: state.items[index].quantity + quantity);
      final newItems = [...state.items];
      newItems[index] = updated;
      state = CartState(items: newItems);
    }
  }

  void decrement(Product product) {
    final index = state.items.indexWhere((it) => it.product.id == product.id);
    if (index == -1) return;
    final current = state.items[index];
    if (current.quantity <= 1) {
      remove(product);
    } else {
      final updated = current.copyWith(quantity: current.quantity - 1);
      final newItems = [...state.items];
      newItems[index] = updated;
      state = CartState(items: newItems);
    }
  }

  void remove(Product product) {
    state = CartState(
        items: state.items.where((it) => it.product.id != product.id).toList());
  }

  void clear() {
    state = const CartState();
  }
}

final cartProvider =
    StateNotifierProvider<CartController, CartState>((ref) => CartController());

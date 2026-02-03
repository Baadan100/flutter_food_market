import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';

@immutable
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  CartItem copyWith({Product? product, int? quantity}) => CartItem(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );

  int get lineTotalCents => product.priceCents * quantity;
}

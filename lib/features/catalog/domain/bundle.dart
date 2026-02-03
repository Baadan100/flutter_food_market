import 'package:flutter/foundation.dart';

@immutable
class Bundle {
  final String id;
  final String imageAssetPath;
  final int priceCents;
  final int peopleCount;
  final List<String> includedProductIds;

  const Bundle({
    required this.id,
    required this.imageAssetPath,
    required this.priceCents,
    required this.peopleCount,
    this.includedProductIds = const [],
  });
}

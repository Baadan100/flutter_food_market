import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../data/firestore_product_repository.dart';
import '../data/sample_products.dart';

/// Provider للـ ProductRepository
final productRepositoryProvider = Provider<FirestoreProductRepository>((ref) {
  return FirestoreProductRepository();
});

/// Provider لجلب جميع المنتجات من Firestore
/// يستخدم Mock Data كـ fallback إذا فشل الاتصال أو كانت القائمة فارغة
final productsProvider = StreamProvider<List<Product>>((ref) async* {
  final repository = ref.read(productRepositoryProvider);
  
  try {
    // محاولة جلب البيانات من Firestore
    await for (final products in repository.getAllProducts()) {
      // إذا كانت القائمة فارغة، استخدم Mock Data
      if (products.isEmpty) {
        yield kSampleProducts;
      } else {
        yield products;
      }
    }
  } catch (e) {
    // في حالة الفشل، استخدم Mock Data
    print('Firestore error: $e, using mock data');
    yield kSampleProducts;
  }
});

/// Provider لجلب المنتجات حسب الفئة
final productsByCategoryProvider = StreamProvider.family<List<Product>, String>(
  (ref, category) async* {
    final repository = ref.read(productRepositoryProvider);
    
    try {
      yield* repository.getProductsByCategory(category);
    } catch (e) {
      // Fallback إلى Mock Data
      print('Firestore error: $e, using mock data');
      yield kSampleProducts.where((p) => p.category == category).toList();
    }
  },
);

/// Provider لجلب فئة واحدة بالـ ID
final productByIdProvider = FutureProvider.family<Product?, String>(
  (ref, productId) async {
    final repository = ref.read(productRepositoryProvider);
    
    try {
      return await repository.getProductById(productId);
    } catch (e) {
      // Fallback إلى Mock Data
      print('Firestore error: $e, using mock data');
      return kSampleProducts.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception('Product not found'),
      );
    }
  },
);

/// Provider لجلب جميع الفئات
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  
  try {
    return await repository.getCategories();
  } catch (e) {
    // Fallback إلى Mock Data
    print('Firestore error: $e, using mock data');
    return kSampleProducts
        .map((p) => p.category)
        .toSet()
        .toList()
      ..sort();
  }
});

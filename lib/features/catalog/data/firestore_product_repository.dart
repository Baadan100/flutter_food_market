import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared/shared.dart';

/// Repository للتعامل مع منتجات Firestore
class FirestoreProductRepository {
  FirebaseFirestore get _firestore {
    if (Firebase.apps.isEmpty) {
      throw StateError(
        'Firebase غير مهيأ. على iOS أضف GoogleService-Info.plist في ios/Runner.',
      );
    }
    return FirebaseFirestore.instance;
  }

  final String _collection = 'products';

  /// جلب جميع المنتجات
  Stream<List<Product>> getAllProducts() {
    // جلب بدون orderBy لتجنب مشاكل Index
    // يمكن إضافة orderBy لاحقاً بعد إنشاء Index في Firestore
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return <Product>[];
      }
      try {
        final products =
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        // ترتيب حسب createdAt إذا كان موجوداً
        products.sort((a, b) {
          // يمكن إضافة ترتيب حسب createdAt هنا إذا كان موجوداً في Model
          return 0;
        });
        return products;
      } catch (e) {
        print('Error parsing products: $e');
        return <Product>[];
      }
    }).handleError((error) {
      print('Firestore getAllProducts error: $error');
      return <Product>[];
    });
  }

  /// جلب منتج واحد بالـ ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(productId).get();
      if (!doc.exists) return null;
      return Product.fromFirestore(doc);
    } catch (e) {
      throw Exception('فشل جلب المنتج: $e');
    }
  }

  /// جلب المنتجات حسب الفئة
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  /// جلب جميع الفئات المتاحة
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final categories = <String>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['category'] as String?;
        if (category != null && category.isNotEmpty) {
          categories.add(category);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      throw Exception('فشل جلب الفئات: $e');
    }
  }

  /// البحث في المنتجات
  Stream<List<Product>> searchProducts(String query) {
    if (query.isEmpty) {
      return getAllProducts();
    }

    // البحث في nameAr و nameEn
    return _firestore
        .collection(_collection)
        .where('nameAr', isGreaterThanOrEqualTo: query)
        .where('nameAr', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }
}

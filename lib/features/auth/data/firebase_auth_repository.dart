import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared/shared.dart';

/// Repository للتعامل مع Firebase Authentication
class FirebaseAuthRepository {
  FirebaseAuth get _auth {
    if (Firebase.apps.isEmpty) {
      throw Exception(
        'Firebase غير مهيأ على هذا الجهاز. على iOS: أضف ملف GoogleService-Info.plist من Firebase Console إلى مجلد ios/Runner.',
      );
    }
    return FirebaseAuth.instance;
  }

  /// الحصول على المستخدم الحالي
  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  }

  /// Stream للمستخدم الحالي (للاستماع للتغييرات)
  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
      );
    });
  }

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('فشل تسجيل الدخول');
      }

      return AppUser(
        id: credential.user!.uid,
        email: credential.user!.email ?? email,
        name: credential.user!.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الدخول: $e');
    }
  }

  /// إنشاء حساب جديد بالبريد الإلكتروني وكلمة المرور
  Future<AppUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('فشل إنشاء الحساب');
      }

      // تحديث اسم المستخدم إذا تم توفيره
      if (name != null && name.isNotEmpty) {
        await credential.user!.updateDisplayName(name);
        await credential.user!.reload();
      }

      return AppUser(
        id: credential.user!.uid,
        email: credential.user!.email ?? email,
        name: credential.user!.displayName ?? name,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('حدث خطأ أثناء إنشاء الحساب: $e');
    }
  }

  /// تسجيل الدخول كضيف (Anonymous)
  Future<AppUser> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();

      if (credential.user == null) {
        throw Exception('فشل تسجيل الدخول كضيف');
      }

      return AppUser(
        id: credential.user!.uid,
        email: 'guest@anonymous.com',
        name: 'ضيف',
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الدخول كضيف: $e');
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الخروج: $e');
    }
  }

  /// إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('حدث خطأ أثناء إعادة تعيين كلمة المرور: $e');
    }
  }

  /// معالجة أخطاء Firebase Auth وتحويلها لرسائل عربية
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('كلمة المرور ضعيفة جداً');
      case 'email-already-in-use':
        return Exception('البريد الإلكتروني مستخدم بالفعل');
      case 'user-not-found':
        return Exception('المستخدم غير موجود');
      case 'wrong-password':
        return Exception('كلمة المرور غير صحيحة');
      case 'invalid-email':
        return Exception('البريد الإلكتروني غير صالح');
      case 'user-disabled':
        return Exception('تم تعطيل هذا الحساب');
      case 'too-many-requests':
        return Exception('عدد كبير جداً من المحاولات. حاول لاحقاً');
      case 'operation-not-allowed':
        return Exception('هذه العملية غير مسموحة');
      case 'network-request-failed':
        return Exception('فشل الاتصال بالشبكة. تحقق من اتصالك بالإنترنت');
      default:
        return Exception('حدث خطأ: ${e.message ?? e.code}');
    }
  }
}

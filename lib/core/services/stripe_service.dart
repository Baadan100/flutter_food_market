import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart' as functions;

/// خدمة Stripe للدفع بالبطاقات المصرفية
class StripeService {
  // Stripe Publishable Key (يجب الحصول عليه من Stripe Dashboard)
  static const String publishableKey =
      'pk_test_51RuBzC2KHu14t0t9gZSYhzOe2CXYmqJVfM90oLPXdGT0w58EkXwZ9F7OmCf4LRi5czcYc35otPux84R2LHPCbekx00IhtCua2S';

  // Stripe Secret Key (يستخدم في Backend فقط - لا تضعه هنا!)
  // للحصول على PaymentIntent من Backend

  /// وضع Mock/Test للاختبار بدون Firebase Functions
  /// قم بتعيينه إلى true للاختبار على Spark Plan (Free)
  static const bool useMockMode =
      true; // تغيير إلى false عند نشر Firebase Functions

  /// تهيئة Stripe
  ///
  /// ملاحظة: يتم تهيئة Stripe بشكل آمن مع معالجة الأخطاء
  static Future<void> initialize() async {
    try {
      Stripe.publishableKey = publishableKey;
      // تأجيل applySettings حتى تكون MainActivity جاهزة
      // سيتم استدعاؤها عند الحاجة الفعلية (في confirmPayment)
      // await Stripe.instance.applySettings();
    } catch (e) {
      // إذا فشلت التهيئة، لن نوقف التطبيق
      // سيتم محاولة التهيئة مرة أخرى عند استخدام Stripe فعلياً
      print('تحذير: فشل تهيئة Stripe في البداية: $e');
      print('سيتم تهيئة Stripe عند الاستخدام الفعلي');
    }
  }

  /// إنشاء PaymentIntent من Firebase Functions
  /// يستخدم Firebase Functions (createPaymentIntent) لإنشاء PaymentIntent
  ///
  /// ملاحظة: يحتاج cloud_functions package - قم بتشغيل: flutter pub get
  static Future<String> createPaymentIntent({
    required int amountCents,
    required String currency,
  }) async {
    // وضع Mock للاختبار بدون Firebase Functions (Spark Plan)
    if (useMockMode) {
      return _createMockPaymentIntent(
          amountCents: amountCents, currency: currency);
    }

    try {
      final firebaseFunctions = functions.FirebaseFunctions.instance;
      final callable = firebaseFunctions.httpsCallable('createPaymentIntent');

      final result = await callable.call({
        'amount': amountCents,
        'currency': currency,
      });

      final clientSecret = result.data['clientSecret'] as String;

      if (clientSecret.isEmpty) {
        throw Exception('فشل إنشاء PaymentIntent: clientSecret فارغ');
      }

      return clientSecret;
    } on functions.FirebaseFunctionsException catch (e) {
      // معالجة أفضل لأخطاء Firebase Functions
      String errorMessage = 'خطأ في Firebase Functions';

      if (e.code == 'not-found') {
        errorMessage =
            'Firebase Function غير متاح. يرجى التأكد من نشر Functions أولاً.\n'
            'قم بتشغيل: firebase deploy --only functions';
      } else if (e.code == 'unauthenticated') {
        errorMessage = 'يجب تسجيل الدخول أولاً';
      } else if (e.code == 'permission-denied') {
        errorMessage = 'ليس لديك صلاحية للوصول';
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = 'خطأ في Firebase Functions: ${e.message}';
      }

      throw Exception(errorMessage);
    } catch (e) {
      // إذا كان الخطأ متعلق بـ NOT_FOUND
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('not-found') ||
          errorString.contains('not found')) {
        throw Exception(
            'Firebase Function غير متاح. يرجى التأكد من نشر Functions أولاً.\n'
            'قم بتشغيل: firebase deploy --only functions');
      }
      throw Exception('خطأ في إنشاء PaymentIntent: $e');
    }
  }

  /// إتمام الدفع باستخدام Stripe
  ///
  /// ملاحظة: يمكن استخدام Payment Sheet لتوفير واجهة جاهزة
  /// أو استخدام هذا الدالة للدفع المباشر
  static Future<void> confirmPayment({
    required String clientSecret,
  }) async {
    // وضع Mock للاختبار بدون Firebase Functions (Spark Plan)
    if (useMockMode) {
      return _confirmMockPayment(clientSecret: clientSecret);
    }

    try {
      // التأكد من تهيئة Stripe قبل الاستخدام (إذا لم تتم بعد)
      try {
        await Stripe.instance.applySettings();
      } catch (_) {
        // إذا فشلت التهيئة، حاول مرة أخرى
        Stripe.publishableKey = publishableKey;
        await Stripe.instance.applySettings();
      }

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
      );
    } on StripeException catch (e) {
      throw Exception('خطأ في الدفع: ${e.error.message}');
    } catch (e) {
      throw Exception('خطأ في الدفع: $e');
    }
  }

  /// تأكيد Mock Payment للاختبار (بدون Stripe فعلي)
  /// يستخدم فقط للاختبار على Spark Plan (Free)
  static Future<void> _confirmMockPayment({
    required String clientSecret,
  }) async {
    // محاكاة تأخير الدفع
    await Future.delayed(const Duration(seconds: 2));

    print('⚠️ [MOCK MODE] تم تأكيد Mock Payment: $clientSecret');
    print('⚠️ [MOCK MODE] هذا للاختبار فقط - لم يتم الدفع الفعلي');
    print('⚠️ [MOCK MODE] سيتم إنشاء الطلب بنجاح للاختبار');

    // في وضع Mock، نعتبر الدفع ناجحاً دائماً
    // لن نستدعي Stripe فعلياً
  }

  /// التحقق من حالة الدفع
  ///
  /// ملاحظة: يجب جلب هذه المعلومات من Backend (لا تضع Secret Key في App!)
  static Future<String> getPaymentStatus(String paymentIntentId) async {
    // لا يمكن الحصول على PaymentIntentStatus مباشرة من App بدون Secret Key
    // يجب استخدام Backend API للتحقق من الحالة
    throw UnimplementedError('يجب جلب حالة الدفع من Backend API');
  }

  /// إنشاء Mock PaymentIntent للاختبار (بدون Firebase Functions)
  /// يستخدم فقط للاختبار على Spark Plan (Free)
  static Future<String> _createMockPaymentIntent({
    required int amountCents,
    required String currency,
  }) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 1));

    // إنشاء Mock Client Secret (لن يعمل فعلياً مع Stripe)
    // هذا فقط للاختبار والتحقق من التدفق
    final mockClientSecret =
        'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret_'
        '${amountCents}_$currency';

    print('⚠️ [MOCK MODE] تم إنشاء Mock PaymentIntent: $mockClientSecret');
    print('⚠️ [MOCK MODE] المبلغ: ${amountCents / 100} $currency');
    print('⚠️ [MOCK MODE] هذا للاختبار فقط - لن يتم الدفع الفعلي');

    return mockClientSecret;
  }
}

/// Enum لطرق الدفع
enum PaymentMethod {
  cashOnDelivery('cash_on_delivery', 'الدفع عند الاستلام'),
  stripe('stripe', 'الدفع بالبطاقة المصرفية');

  final String value;
  final String labelAr;

  const PaymentMethod(this.value, this.labelAr);
}

// مؤقتاً دون اعتماد على Firebase Functions/Stripe

class PaymentService {
  Future<void> checkout(
      {required int amountCents, String currency = 'sar'}) async {
    // الدفع مُعطّل مؤقتاً أثناء التطوير المبسّط.
    // أعد الدمج لاحقاً مع backend.
    return;
  }
}

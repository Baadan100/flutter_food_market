import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/application/auth_controller.dart';
import '../auth/presentation/auth_pages.dart';
import '../cart/application/cart_controller.dart';
import '../shell/shell_scaffold.dart';
import '../../l10n/app_localizations.dart';
import 'order_controller.dart';
import '../../core/services/stripe_service.dart';
import 'package:cloud_functions/cloud_functions.dart' as functions;

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;
  String _selectedPaymentMethod = 'cash_on_delivery'; // Default payment method

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// معالجة الدفع بـ Stripe
  Future<void> _handleStripePayment(
    dynamic cartState,
    dynamic authState,
  ) async {
    setState(() => _isSubmitting = true);

    try {
      // ملاحظة: Stripe يحتاج إلى Backend API لإنشاء PaymentIntent
      // حالياً، هذا الكود يعرض رسالة توضيحية
      
      // إنشاء PaymentIntent من Firebase Functions
      final clientSecret = await StripeService.createPaymentIntent(
        amountCents: cartState.totalCents,
        currency: 'sar',
      );
      
      // تأكيد الدفع باستخدام Stripe
      await StripeService.confirmPayment(clientSecret: clientSecret);
      
      // بعد نجاح الدفع، قم بإنشاء الطلب
      final order = await ref.read(orderControllerProvider.notifier).createOrder(
        userId: authState.user!.id,
        userName: _nameController.text,
        userPhone: _phoneController.text,
        deliveryAddress: _addressController.text,
        notes: _notesController.text,
        items: cartState.items,
        totalCents: cartState.totalCents,
        paymentMethod: 'stripe',
      );
      
      // إرسال الفاتورة بالبريد الإلكتروني
      try {
        final firebaseFunctions = functions.FirebaseFunctions.instance;
        final callable = firebaseFunctions.httpsCallable('sendOrderInvoice');
        await callable.call({
          'orderId': order.id,
          'userEmail': authState.user!.email,
          'userName': _nameController.text,
        });
      } catch (e) {
        // إذا فشل إرسال البريد، لا نوقف العملية
        print('خطأ في إرسال البريد الإلكتروني: $e');
      }
      
      if (!mounted) return;
      ref.read(cartProvider.notifier).clear();
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationPage(orderId: order.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الدفع: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartState = ref.read(cartProvider);
    final authState = ref.read(authProvider);

    if (!authState.isSignedIn) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).tr('please_sign_in')),
          action: SnackBarAction(
            label: AppLocalizations.of(context).tr('sign_in'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SignInPage()),
              );
            },
          ),
        ),
      );
      return;
    }

    // إذا كانت طريقة الدفع Stripe، معالجة الدفع بالبطاقة
    if (_selectedPaymentMethod == 'stripe') {
      await _handleStripePayment(cartState, authState);
      return;
    }

    // طريقة الدفع عند الاستلام
    setState(() => _isSubmitting = true);

    try {
      final order =
          await ref.read(orderControllerProvider.notifier).createOrder(
                userId: authState.user!.id,
                userName: _nameController.text,
                userPhone: _phoneController.text,
                deliveryAddress: _addressController.text,
                notes: _notesController.text,
                items: cartState.items,
                totalCents: cartState.totalCents,
                paymentMethod: _selectedPaymentMethod,
              );

      if (!mounted) return;

      // Clear cart after successful order
      ref.read(cartProvider.notifier).clear();

      // Navigate to order confirmation
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationPage(orderId: order.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إتمام الطلب: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authProvider);
    final t = AppLocalizations.of(context);
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Check if user is signed in
    if (!authState.isSignedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(t.tr('checkout'))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 24),
                Text(
                  t.tr('sign_in_required'),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  t.tr('sign_in_to_checkout'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: Text(t.tr('sign_in')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tr('checkout')),
      ),
      body: cartState.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.tr('empty_cart'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Summary Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.tr('order_summary'),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            ...cartState.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.product.localizedName(Localizations.localeOf(context))} × ${item.quantity}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                      Text(
                                        '${((item.product.priceCents * item.quantity) / 100).toStringAsFixed(2)} ر.س',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                )),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t.tr('total'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '${(cartState.totalCents / 100).toStringAsFixed(2)} ر.س',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Customer Information
                    Text(
                      t.tr('customer_info'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: t.tr('full_name'),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.tr('name_required');
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: t.tr('phone_number'),
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.tr('phone_required');
                        }
                        if (value.length < 10) {
                          return t.tr('phone_invalid');
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Delivery Information
                    Text(
                      t.tr('delivery_info'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: t.tr('delivery_address'),
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.tr('address_required');
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: t.tr('notes_optional'),
                        prefixIcon: const Icon(Icons.note),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 24),

                    // Payment Method
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.money,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  t.tr('payment_method'),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Cash on Delivery Option
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethod = 'cash_on_delivery';
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _selectedPaymentMethod == 'cash_on_delivery'
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedPaymentMethod == 'cash_on_delivery'
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.withOpacity(0.3),
                                    width: _selectedPaymentMethod == 'cash_on_delivery' ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.payments,
                                      color: _selectedPaymentMethod == 'cash_on_delivery'
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        t.tr('cash_on_delivery'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: _selectedPaymentMethod == 'cash_on_delivery'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                      ),
                                    ),
                                    if (_selectedPaymentMethod == 'cash_on_delivery')
                                      Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Stripe Payment Option
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethod = 'stripe';
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _selectedPaymentMethod == 'stripe'
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedPaymentMethod == 'stripe'
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.withOpacity(0.3),
                                    width: _selectedPaymentMethod == 'stripe' ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      color: _selectedPaymentMethod == 'stripe'
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'الدفع بالبطاقة المصرفية',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: _selectedPaymentMethod == 'stripe'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                      ),
                                    ),
                                    if (_selectedPaymentMethod == 'stripe')
                                      Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              t.tr('place_order'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  const OrderConfirmationPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tr('order_confirmed')),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                t.tr('order_confirmed'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                t.tr('order_confirmed_message'),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${t.tr('order_number')}: $orderId',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const ShellScaffold(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: Text(t.tr('back_to_home')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

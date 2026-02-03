import 'package:flutter/material.dart';
// duplicate removed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/application/cart_controller.dart';
import '../../checkout/checkout_page.dart';
import '../data/sample_products.dart';
import 'package:shared/shared.dart';
import '../data/sample_bundles.dart';
import '../domain/bundle.dart';
import '../application/products_provider.dart';
import '../../../widgets/product_image.dart';
import '../../../l10n/app_localizations.dart';

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});
  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr('products')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context).tr('tab_products')),
            Tab(text: AppLocalizations.of(context).tr('tab_bundles')),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    child: Text(
                      ref.watch(cartProvider).totalQuantity.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CartPage())),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProductsGrid(),
          _BundlesList(),
        ],
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(
                    imagePath: product.imageAssetPath,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          product
                              .localizedName(Localizations.localeOf(context)),
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.localizedName(Localizations.localeOf(context)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${(product.priceCents / 100).toStringAsFixed(2)} ر.س',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          ref.read(cartProvider.notifier).add(product),
                      icon: const Icon(Icons.add_shopping_cart),
                      label:
                          Text(AppLocalizations.of(context).tr('add_to_cart')),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProductsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 2;
        if (width >= 1200) {
          crossAxisCount = 6;
        } else if (width >= 900) {
          crossAxisCount = 4;
        } else if (width >= 600) {
          crossAxisCount = 3;
        }
        
        return productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context).tr('no_products')),
              );
            }
            
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .72,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Product product = products[index];
                return _ProductCard(product: product);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'خطأ في تحميل المنتجات: $error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(productsProvider);
                  },
                  child: Text(AppLocalizations.of(context).tr('retry')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BundlesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: kSampleBundles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final Bundle b = kSampleBundles[i];
        final title = i == 0
            ? AppLocalizations.of(context).tr('bundle_title_family')
            : AppLocalizations.of(context).tr('bundle_title_party');
        return InkWell(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                ProductImage(
                    imagePath: b.imageAssetPath,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover),
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14)),
                        ),
                        Text('${(b.priceCents / 100).toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart,
                              color: Colors.white),
                          onPressed: () {
                            final String name = (i == 0)
                                ? AppLocalizations.of(context)
                                    .tr('bundle_title_family')
                                : AppLocalizations.of(context)
                                    .tr('bundle_title_party');
                            final Product bundleAsProduct = Product(
                              id: 'bundle_${b.id}',
                              nameAr: name,
                              nameEn: name,
                              imageAssetPath: b.imageAssetPath,
                              priceCents: b.priceCents,
                              descriptionAr: '',
                              descriptionEn: '',
                              category: 'family_meals',
                            );
                            ref
                                .read(cartProvider.notifier)
                                .add(bundleAsProduct);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const CartPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: Text(product.localizedName(Localizations.localeOf(context)))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: ProductImage(
                  imagePath: product.imageAssetPath, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.localizedName(Localizations.localeOf(context)),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                    product
                        .localizedDescription(Localizations.localeOf(context)),
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text('${(product.priceCents / 100).toStringAsFixed(2)} ر.س',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        ref.read(cartProvider.notifier).add(product),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(AppLocalizations.of(context).tr('add_to_cart')),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CartPage extends ConsumerWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).tr('cart'))),
      body: state.items.isEmpty
          ? Center(child: Text(AppLocalizations.of(context).tr('empty_cart')))
          : ListView.separated(
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  leading: ProductImage(
                      imagePath: item.product.imageAssetPath,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover),
                  title: Text(item.product.nameAr),
                  subtitle: Text(
                      '${(item.product.priceCents / 100).toStringAsFixed(2)} ر.س × ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => ref
                            .read(cartProvider.notifier)
                            .decrement(item.product),
                      ),
                      Text(item.quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () =>
                            ref.read(cartProvider.notifier).add(item.product),
                      ),
                    ],
                  ),
                  onLongPress: () =>
                      ref.read(cartProvider.notifier).remove(item.product),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                  '${AppLocalizations.of(context).tr('total')}: ${(state.totalCents / 100).toStringAsFixed(2)} ر.س',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            ElevatedButton(
              onPressed: state.items.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CheckoutPage(),
                        ),
                      );
                    },
              child: Text(AppLocalizations.of(context).tr('checkout')),
            )
          ],
        ),
      ),
    );
  }
}

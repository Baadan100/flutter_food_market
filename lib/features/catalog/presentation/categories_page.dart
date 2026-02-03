import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/application/cart_controller.dart';
import '../data/sample_products.dart';
import 'package:shared/shared.dart';
import '../../../l10n/app_localizations.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  String? _selectedCategory;

  final Map<String, Map<String, String>> _categories = {
    'all': {'ar': 'الكل', 'en': 'All'},
    'fish': {'ar': 'أسماك', 'en': 'Fish'},
    'shrimp': {'ar': 'جمبري', 'en': 'Shrimp'},
    'seafood': {'ar': 'مأكولات بحرية', 'en': 'Seafood'},
    'grilled': {'ar': 'مشويات', 'en': 'Grilled'},
  };

  final Map<String, IconData> _categoryIcons = {
    'all': Icons.restaurant_menu,
    'fish': Icons.set_meal,
    'shrimp': Icons.emoji_food_beverage,
    'seafood': Icons.water_drop,
    'grilled': Icons.local_fire_department,
  };

  List<Product> _getFilteredProducts() {
    if (_selectedCategory == null || _selectedCategory == 'all') {
      return kSampleProducts;
    }
    return kSampleProducts
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  String _getCategoryName(String categoryKey, Locale locale) {
    return _categories[categoryKey]?[locale.languageCode] ?? categoryKey;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = AppLocalizations.of(context);
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tr('categories')),
      ),
      body: Column(
        children: [
          // Categories Filter Bar
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final categoryKey = _categories.keys.elementAt(index);
                final isSelected = _selectedCategory == categoryKey ||
                    (_selectedCategory == null && categoryKey == 'all');
                final categoryName = _getCategoryName(categoryKey, locale);
                final icon = _categoryIcons[categoryKey] ?? Icons.category;

                return Padding(
                  padding: EdgeInsets.only(
                    right: isRTL ? (index == 0 ? 0 : 12) : 0,
                    left: isRTL ? 0 : (index == 0 ? 0 : 12),
                  ),
                  child: _CategoryChip(
                    label: categoryName,
                    icon: icon,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategory = categoryKey == 'all' ? null : categoryKey;
                      });
                    },
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),

          // Products Grid
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isRTL ? 'لا توجد منتجات في هذا التصنيف' : 'No products in this category',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
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
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: .72,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _CategoryProductCard(product: product);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : (isDark
                  ? Colors.grey[800]
                  : Colors.grey[200]),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.grey[800]),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey[800]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryProductCard extends ConsumerWidget {
  const _CategoryProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context);

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailsPage(product: product),
        ),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    product.imageAssetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          product.localizedName(locale),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
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
                  Text(
                    product.localizedName(locale),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(product.priceCents / 100).toStringAsFixed(2)} ر.س',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(cartProvider.notifier).add(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${t.tr('add_to_cart')}: ${product.localizedName(locale)}',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: Text(
                        t.tr('add_to_cart'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reuse ProductDetailsPage from catalog_page.dart
class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.localizedName(locale)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              product.imageAssetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 64),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.localizedName(locale),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  product.localizedDescription(locale),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  '${(product.priceCents / 100).toStringAsFixed(2)} ر.س',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(cartProvider.notifier).add(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${t.tr('add_to_cart')}: ${product.localizedName(locale)}'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(t.tr('add_to_cart')),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

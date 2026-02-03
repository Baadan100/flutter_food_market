import 'package:flutter/material.dart';
import '../catalog/presentation/catalog_page.dart';
import '../catalog/presentation/categories_page.dart';
import '../cart/application/cart_controller.dart';
import '../orders/orders_page.dart';
import '../settings/theme_controller.dart';
import '../settings/locale_controller.dart';
import '../settings/settings_page.dart';
import '../profile/profile_page.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_drawer.dart';
import '../home/home_page.dart';
import '../auth/presentation/auth_pages.dart';
import '../auth/application/auth_controller.dart';

class ShellScaffold extends ConsumerStatefulWidget {
  const ShellScaffold({super.key});

  @override
  ConsumerState<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<ShellScaffold> {
  int _index = 0; // 0 Home, 1 Catalog, 2 Cart, 3 Orders, 4 Profile

  void _onSelect(String route) {
    if (route == '/toggle-theme') {
      ref.read(themeModeProvider.notifier).toggle();
      Navigator.of(context).maybePop();
      return;
    }
    if (route == '/toggle-locale') {
      ref.read(localeProvider.notifier).toggle();
      Navigator.of(context).maybePop();
      return;
    }
    if (route == '/catalog') {
      setState(() => _index = 1);
      Navigator.of(context).maybePop();
      return;
    }
    if (route == '/cart') {
      setState(() => _index = 2);
      Navigator.of(context).maybePop();
      return;
    }
    if (route == '/orders') {
      setState(() => _index = 3);
      Navigator.of(context).maybePop();
      return;
    }
    if (route == '/categories') {
      Navigator.of(context).maybePop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CategoriesPage()),
      );
      return;
    }
    if (route == '/settings') {
      Navigator.of(context).maybePop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
      return;
    }
    if (route == '/profile') {
      setState(() => _index = 4);
      Navigator.of(context).maybePop();
      return;
    }
    Navigator.of(context).maybePop();
  }

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return const HomePage();
      case 1:
        return const CatalogPage();
      case 2:
        return const CartPage();
      case 3:
        return const OrdersPage();
      case 4:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartQty = ref.watch(cartProvider).totalQuantity;
    final showAppBar = _index != 0; // Hide AppBar on HomePage

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(AppLocalizations.of(context).tr('app_title')),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () => _onSelect('/cart'),
                    ),
                    if (cartQty > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          child: Text('$cartQty',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white)),
                        ),
                      ),
                  ],
                )
              ],
            )
          : null,
      drawer: AppDrawer(onSelect: _onSelect),
      body: _buildBody(),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              );
            }
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: AppLocalizations.of(context).tr('home')),
            NavigationDestination(
                icon: const Icon(Icons.storefront_outlined),
                selectedIcon: const Icon(Icons.storefront),
                label: AppLocalizations.of(context).tr('products')),
            NavigationDestination(
                icon: const Icon(Icons.shopping_cart_outlined),
                selectedIcon: const Icon(Icons.shopping_cart),
                label: AppLocalizations.of(context).tr('cart')),
            NavigationDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: const Icon(Icons.receipt_long),
                label: AppLocalizations.of(context).tr('orders')),
            NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: AppLocalizations.of(context).tr('profile')),
          ],
        ),
      ),
    );
  }
}

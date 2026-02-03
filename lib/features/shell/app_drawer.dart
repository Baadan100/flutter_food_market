import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onSelect});
  final void Function(String route) onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.restaurant,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context).tr('app_title'),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.storefront),
              title: Text(AppLocalizations.of(context).tr('products')),
              onTap: () => onSelect('/catalog'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: Text(AppLocalizations.of(context).tr('categories')),
              onTap: () => onSelect('/categories'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(AppLocalizations.of(context).tr('cart')),
              onTap: () => onSelect('/cart'),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(AppLocalizations.of(context).tr('orders')),
              onTap: () => onSelect('/orders'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(AppLocalizations.of(context).tr('profile')),
              onTap: () => onSelect('/profile'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text(AppLocalizations.of(context).tr('theme_toggle')),
              onTap: () => onSelect('/toggle-theme'),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context).tr('lang_toggle')),
              onTap: () => onSelect('/toggle-locale'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context).tr('settings')),
              onTap: () => onSelect('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

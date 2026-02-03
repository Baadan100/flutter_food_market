import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme_controller.dart';
import 'locale_controller.dart';
import '../../l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tr('settings')),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _SettingsSection(
            title: t.tr('appearance'),
            children: [
              SwitchListTile(
                title: Text(t.tr('theme_toggle')),
                subtitle: Text(
                  themeMode == ThemeMode.dark
                      ? t.tr('dark_mode')
                      : t.tr('light_mode'),
                ),
                secondary: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  ref
                      .read(themeModeProvider.notifier)
                      .set(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ],
          ),

          // Language Section
          _SettingsSection(
            title: t.tr('language'),
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(t.tr('lang_toggle')),
                subtitle: Text(
                  locale.languageCode == 'ar'
                      ? t.tr('arabic')
                      : t.tr('english'),
                ),
                trailing: DropdownButton<Locale>(
                  value: locale,
                  items: const [
                    DropdownMenuItem(
                      value: Locale('ar'),
                      child: Text('العربية'),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                  ],
                  onChanged: (newLocale) {
                    if (newLocale != null) {
                      ref.read(localeProvider.notifier).setLocale(newLocale);
                    }
                  },
                ),
              ),
            ],
          ),

          // App Information Section
          _SettingsSection(
            title: t.tr('app_info'),
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(t.tr('app_version')),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(t.tr('about')),
                subtitle: Text(t.tr('about_description')),
              ),
              ListTile(
                leading: const Icon(Icons.copyright),
                title: Text(t.tr('copyright')),
                subtitle: Text(t.tr('copyright_text')),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () async {
                  final url = Uri.parse('https://lorienx.com/');
                  try {
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.tr('cannot_open_url')),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${t.tr('cannot_open_url')}: $e'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),

          // Support Section
          _SettingsSection(
            title: t.tr('support'),
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(t.tr('help_center')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final email = Uri(
                    scheme: 'mailto',
                    path: 'contact@lorienx.com',
                    query:
                        'subject=${Uri.encodeComponent(t.tr('help_center'))}',
                  );
                  try {
                    if (await canLaunchUrl(email)) {
                      await launchUrl(email);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.tr('cannot_open_email')),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${t.tr('cannot_open_email')}: $e'),
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_support),
                title: Text(t.tr('contact_us')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final email = Uri(
                    scheme: 'mailto',
                    path: 'contact@lorienx.com',
                    query: 'subject=${Uri.encodeComponent(t.tr('contact_us'))}',
                  );
                  try {
                    if (await canLaunchUrl(email)) {
                      await launchUrl(email);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.tr('cannot_open_email')),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${t.tr('cannot_open_email')}: $e'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

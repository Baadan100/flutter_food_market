import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/auth_controller.dart';
import '../../shell/shell_scaffold.dart';
import '../../../l10n/app_localizations.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});
  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.tr('sign_in_title'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _email,
                decoration: InputDecoration(labelText: t.tr('email'))),
            const SizedBox(height: 12),
            TextField(
                controller: _pass,
                decoration: InputDecoration(labelText: t.tr('password')),
                obscureText: true),
            const SizedBox(height: 16),
            if (state.errorMessage != null)
              Text(state.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await ref
                    .read(authProvider.notifier)
                    .signIn(_email.text, _pass.text);
                if (!mounted) return;
                if (ref.read(authProvider).isSignedIn) {
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const ShellScaffold()),
                    (r) => false,
                  );
                }
              },
              child: Text(t.tr('sign_in_button')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SignUpPage())),
              child: Text(t.tr('create_account')),
            )
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});
  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.tr('sign_up_title'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _email,
                decoration: InputDecoration(labelText: t.tr('email'))),
            const SizedBox(height: 12),
            TextField(
                controller: _pass,
                decoration: InputDecoration(labelText: t.tr('password')),
                obscureText: true),
            const SizedBox(height: 16),
            if (state.errorMessage != null)
              Text(state.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await ref
                    .read(authProvider.notifier)
                    .signUp(_email.text, _pass.text);
                if (!mounted) return;
                if (ref.read(authProvider).isSignedIn) {
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const ShellScaffold()),
                    (r) => false,
                  );
                }
              },
              child: Text(t.tr('sign_up_button')),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app/common_lib.dart';
import 'package:app/data/providers/settings_provider.dart';
import 'package:app/theme/theme_mode.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _switchThemeMode() {
    ref.read(settingsProvider.notifier).toggleThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(context.l10n.appName),
            Text(
              settings.themeMode.localize(context),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton.icon(
              onPressed: () => Future.sync(() => ref
                  .read(settingsProvider.notifier)
                  .setLocale(settings.locale?.languageCode == 'en'
                      ? const Locale('ar')
                      : const Locale('en'))),
              icon: const Icon(Icons.language),
              label: Text(context.l10n.localeName),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Features',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => const DepartmentsRoute().go(context),
              icon: const Icon(Icons.business_outlined),
              label: const Text('Departments'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchThemeMode,
        tooltip: context.l10n.switchTheme,
        child: Icon(
          settings.themeMode.isDark ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }
}

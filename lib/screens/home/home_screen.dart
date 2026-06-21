import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import 'species_list_tab.dart';
import 'stats_tab.dart';
import '../species/add_species_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tab = 0;

  Future<void> _signOut() async {
    await ref.read(supabaseProvider).auth.signOut();
  }

  void _cycleLocale() {
    final current = ref.read(localeProvider);
    final locales = supportedLocales;
    final idx = locales.indexWhere((l) => l.languageCode == current.languageCode);
    final next = locales[(idx + 1) % locales.length];
    ref.read(localeProvider.notifier).state = next;
  }

  String _localeLabel(String code) {
    switch (code) {
      case 'zh': return '中文';
      case 'fr': return 'FR';
      default: return 'EN';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final s = ref.watch(appStringsProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🦅 ', style: TextStyle(fontSize: 22)),
            Text('RaptorLog',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          if (_tab == 0)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: s.addSpecies,
              onPressed: () => showAddSpeciesSheet(context),
            ),
          TextButton(
            onPressed: _cycleLocale,
            child: Text(_localeLabel(locale.languageCode),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(user?.email ?? 'Account'),
                enabled: false,
              ),
              PopupMenuItem(
                value: 'signout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 18),
                    const SizedBox(width: 8),
                    Text(s.signOut),
                  ],
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 'signout') _signOut();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: const [
          SpeciesListTab(),
          StatsTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view),
            label: s.fieldJournal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: s.achievementsTab,
          ),
        ],
      ),
    );
  }
}

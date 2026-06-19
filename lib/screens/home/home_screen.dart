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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;

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
              tooltip: 'Add species',
              onPressed: () => showAddSpeciesSheet(context),
            ),
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(user?.email ?? 'Account'),
                enabled: false,
              ),
              const PopupMenuItem(
                value: 'signout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Sign Out'),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Field Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Achievements',
          ),
        ],
      ),
    );
  }
}

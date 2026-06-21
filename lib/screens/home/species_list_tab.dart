import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_strings.dart';
import '../../core/constants.dart';
import '../../models/species.dart';
import '../../providers/app_providers.dart';
import '../../widgets/species_card.dart';
import '../../widgets/achievement_drawer.dart';
import '../species/add_species_sheet.dart';

class SpeciesListTab extends ConsumerStatefulWidget {
  const SpeciesListTab({super.key});

  @override
  ConsumerState<SpeciesListTab> createState() => _SpeciesListTabState();
}

class _SpeciesListTabState extends ConsumerState<SpeciesListTab> {
  String _search = '';
  String? _filterFamily;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appStringsProvider);
    final speciesAsync = ref.watch(speciesListProvider);
    final achievements = ref.watch(achievementsProvider).value ?? {};

    return speciesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (allSpecies) {
        if (allSpecies.isEmpty) {
          return _EmptyState(
            s: s,
            onImport: () async {
              await ref.read(speciesListProvider.notifier).importStarter();
            },
          );
        }

        var filtered = allSpecies.where((sp) {
          final matchSearch = _search.isEmpty ||
              sp.commonName.toLowerCase().contains(_search.toLowerCase()) ||
              (sp.chineseName?.contains(_search) ?? false) ||
              (sp.scientificName
                      ?.toLowerCase()
                      .contains(_search.toLowerCase()) ??
                  false);
          final matchFamily =
              _filterFamily == null || sp.familyGroup == _filterFamily;
          return matchSearch && matchFamily;
        }).toList();

        final families = <String, List<Species>>{};
        for (final sp in filtered) {
          final f = sp.familyGroup ?? 'Other';
          families.putIfAbsent(f, () => []).add(sp);
        }

        final orderedFamilies = [
          ...kFamilyOrder.where((f) => families.containsKey(f)),
          ...families.keys.where((f) => !kFamilyOrder.contains(f)),
        ];

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: s.searchSpecies,
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FamilyFilterButton(
                      s: s,
                      families: orderedFamilies,
                      selected: _filterFamily,
                      onSelect: (f) => setState(() => _filterFamily = f),
                    ),
                  ],
                ),
              ),
            ),
            for (final family in orderedFamilies) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        kFamilyChineseNames[family] ?? family,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(family,
                          style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      const SizedBox(width: 6),
                      Text('(${families[family]!.length})',
                          style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final sp = families[family]![i];
                      return SpeciesCard(
                        species: sp,
                        achievement: achievements[sp.id],
                        onTap: () => showAchievementDrawer(context, sp),
                      );
                    },
                    childCount: families[family]!.length,
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }
}

class _FamilyFilterButton extends StatelessWidget {
  final AppStrings s;
  final List<String> families;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const _FamilyFilterButton({
    required this.s,
    required this.families,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String?>(
      initialValue: selected,
      onSelected: onSelect,
      itemBuilder: (_) => [
        PopupMenuItem(value: null, child: Text(s.allFamilies)),
        ...families.map((f) => PopupMenuItem(
              value: f,
              child: Text('${kFamilyChineseNames[f] ?? f}  $f'),
            )),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected != null
              ? const Color(0xFF2E7D32).withOpacity(0.12)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected != null
                  ? const Color(0xFF2E7D32)
                  : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list,
                size: 18,
                color: selected != null
                    ? const Color(0xFF2E7D32)
                    : Colors.grey[600]),
            if (selected != null) ...[
              const SizedBox(width: 4),
              Text(selected!,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF2E7D32))),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppStrings s;
  final VoidCallback onImport;
  const _EmptyState({required this.s, required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🦅', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(
              s.emptyTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              s.emptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.download),
              label: Text(s.importStarter),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => showAddSpeciesSheet(context),
              icon: const Icon(Icons.add),
              label: Text(s.addCustomSpecies),
            ),
          ],
        ),
      ),
    );
  }
}

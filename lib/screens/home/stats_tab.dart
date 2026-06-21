import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../models/achievement.dart';
import '../../models/species.dart';
import '../../providers/app_providers.dart';
import '../../widgets/achievement_drawer.dart';

class StatsTab extends ConsumerWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
    final stats = ref.watch(statsProvider);
    final achievements = ref.watch(achievementsProvider).value ?? {};
    final species = ref.watch(speciesListProvider).value ?? [];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.dashboardTitle,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32)),
                ),
                const SizedBox(height: 16),
                // 4 stat cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard(
                      info: kLevels[0],
                      count: stats.green,
                      total: stats.total,
                    ),
                    _StatCard(
                      info: kLevels[1],
                      count: stats.blue,
                      total: stats.total,
                    ),
                    _StatCard(
                      info: kLevels[2],
                      count: stats.yellow,
                      total: stats.total,
                    ),
                    _StatCard(
                      info: kLevels[3],
                      count: stats.red,
                      total: stats.total,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(s.overallProgress,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                _OverallProgressBar(stats: stats),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        // Red-level highlights (Master Shots)
        if (achievements.values.any(
            (a) => a.levels[AchievementLevel.red]?.unlocked == true)) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC62828),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer(builder: (ctx, r, _) => Text(
                      r.watch(appStringsProvider).masterShots,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final masterSpecies = species
                      .where((s) =>
                          achievements[s.id]
                              ?.levels[AchievementLevel.red]
                              ?.unlocked ==
                          true)
                      .toList();
                  if (i >= masterSpecies.length) return null;
                  final s = masterSpecies[i];
                  final a = achievements[s.id]!;
                  return _HighlightTile(
                      species: s, achievement: a, level: AchievementLevel.red);
                },
                childCount: achievements.values
                    .where((a) =>
                        a.levels[AchievementLevel.red]?.unlocked == true)
                    .length,
              ),
            ),
          ),
        ],
        // Yellow-level highlights
        if (achievements.values.any(
            (a) => a.levels[AchievementLevel.yellow]?.unlocked == true)) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF57F17),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer(builder: (ctx, r, _) => Text(
                      r.watch(appStringsProvider).actionShots,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final actionSpecies = species
                      .where((s) =>
                          achievements[s.id]
                              ?.levels[AchievementLevel.yellow]
                              ?.unlocked ==
                          true)
                      .toList();
                  if (i >= actionSpecies.length) return null;
                  final s = actionSpecies[i];
                  final a = achievements[s.id]!;
                  return _HighlightTile(
                      species: s,
                      achievement: a,
                      level: AchievementLevel.yellow);
                },
                childCount: achievements.values
                    .where((a) =>
                        a.levels[AchievementLevel.yellow]?.unlocked == true)
                    .length,
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _StatCard extends ConsumerWidget {
  final LevelInfo info;
  final int count;
  final int total;

  const _StatCard(
      {required this.info, required this.count, required this.total});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStringsProvider);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: info.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: info.borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(info.icon, color: info.color, size: 18),
              const SizedBox(width: 6),
              Text(info.labelZh,
                  style: TextStyle(
                      color: info.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
          Text(
            '$count',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: info.color,
                height: 1.1),
          ),
          Text(
            s.ofSpecies(count, total),
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _OverallProgressBar extends StatelessWidget {
  final AchievementStats stats;
  const _OverallProgressBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.total == 0) return const SizedBox();
    return Column(
      children: kLevels.map((info) {
        final count = switch (info.level) {
          AchievementLevel.green => stats.green,
          AchievementLevel.blue => stats.blue,
          AchievementLevel.yellow => stats.yellow,
          AchievementLevel.red => stats.red,
        };
        final pct = stats.total > 0 ? count / stats.total : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Text(info.labelZh,
                    style: TextStyle(
                        fontSize: 12,
                        color: info.color,
                        fontWeight: FontWeight.w600)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(info.color),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                child: Text('$count/${stats.total}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    textAlign: TextAlign.right),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HighlightTile extends ConsumerWidget {
  final Species species;
  final Achievement achievement;
  final AchievementLevel level;

  const _HighlightTile({
    required this.species,
    required this.achievement,
    required this.level,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = levelInfo(level);
    final data = achievement.levels[level]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => showAchievementDrawer(context, species),
        leading: data.photoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(data.photoUrl!,
                    width: 48, height: 48, fit: BoxFit.cover),
              )
            : Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: info.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(info.icon, color: info.color),
              ),
        title: Text(species.chineseName ?? species.commonName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          species.chineseName != null ? species.commonName : '',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: info.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(info.labelZh,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

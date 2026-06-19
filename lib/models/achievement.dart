import '../core/constants.dart';

class LevelData {
  final bool unlocked;
  final String? photoUrl;
  final DateTime? unlockedAt;

  const LevelData({
    this.unlocked = false,
    this.photoUrl,
    this.unlockedAt,
  });

  LevelData copyWith({bool? unlocked, String? photoUrl, DateTime? unlockedAt}) =>
      LevelData(
        unlocked: unlocked ?? this.unlocked,
        photoUrl: photoUrl ?? this.photoUrl,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
}

class Achievement {
  final String id;
  final String userId;
  final String speciesId;
  final Map<AchievementLevel, LevelData> levels;

  const Achievement({
    required this.id,
    required this.userId,
    required this.speciesId,
    required this.levels,
  });

  factory Achievement.empty(String speciesId, String userId) => Achievement(
        id: '',
        userId: userId,
        speciesId: speciesId,
        levels: {
          for (final l in AchievementLevel.values) l: const LevelData(),
        },
      );

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      speciesId: json['species_id'] as String,
      levels: {
        AchievementLevel.green: LevelData(
          unlocked: json['green_unlocked'] as bool? ?? false,
          photoUrl: json['green_photo_url'] as String?,
          unlockedAt: json['green_unlocked_at'] != null
              ? DateTime.parse(json['green_unlocked_at'] as String)
              : null,
        ),
        AchievementLevel.blue: LevelData(
          unlocked: json['blue_unlocked'] as bool? ?? false,
          photoUrl: json['blue_photo_url'] as String?,
          unlockedAt: json['blue_unlocked_at'] != null
              ? DateTime.parse(json['blue_unlocked_at'] as String)
              : null,
        ),
        AchievementLevel.yellow: LevelData(
          unlocked: json['yellow_unlocked'] as bool? ?? false,
          photoUrl: json['yellow_photo_url'] as String?,
          unlockedAt: json['yellow_unlocked_at'] != null
              ? DateTime.parse(json['yellow_unlocked_at'] as String)
              : null,
        ),
        AchievementLevel.red: LevelData(
          unlocked: json['red_unlocked'] as bool? ?? false,
          photoUrl: json['red_photo_url'] as String?,
          unlockedAt: json['red_unlocked_at'] != null
              ? DateTime.parse(json['red_unlocked_at'] as String)
              : null,
        ),
      },
    );
  }

  AchievementLevel? get highestLevel {
    for (final level in AchievementLevel.values.reversed) {
      if (levels[level]?.unlocked == true) return level;
    }
    return null;
  }

  int get unlockedCount =>
      levels.values.where((d) => d.unlocked).length;

  bool get hasAny => unlockedCount > 0;

  Achievement withLevelUnlocked(AchievementLevel target, {String? photoUrl}) {
    final now = DateTime.now();
    final updated = Map<AchievementLevel, LevelData>.from(levels);
    // Non-linear: auto-unlock all levels below target
    for (final l in AchievementLevel.values) {
      if (l.index <= target.index && !(updated[l]?.unlocked ?? false)) {
        updated[l] = LevelData(
          unlocked: true,
          photoUrl: l == target ? photoUrl : updated[l]?.photoUrl,
          unlockedAt: now,
        );
      }
    }
    return Achievement(id: id, userId: userId, speciesId: speciesId, levels: updated);
  }

  Achievement withLevelRevoked(AchievementLevel target) {
    final updated = Map<AchievementLevel, LevelData>.from(levels);
    updated[target] = LevelData(
      unlocked: false,
      photoUrl: updated[target]?.photoUrl,
      unlockedAt: null,
    );
    return Achievement(id: id, userId: userId, speciesId: speciesId, levels: updated);
  }

  Map<String, dynamic> toUpsertJson(String userId, String speciesId) => {
        'user_id': userId,
        'species_id': speciesId,
        'green_unlocked': levels[AchievementLevel.green]?.unlocked ?? false,
        'green_photo_url': levels[AchievementLevel.green]?.photoUrl,
        'green_unlocked_at': levels[AchievementLevel.green]?.unlockedAt?.toIso8601String(),
        'blue_unlocked': levels[AchievementLevel.blue]?.unlocked ?? false,
        'blue_photo_url': levels[AchievementLevel.blue]?.photoUrl,
        'blue_unlocked_at': levels[AchievementLevel.blue]?.unlockedAt?.toIso8601String(),
        'yellow_unlocked': levels[AchievementLevel.yellow]?.unlocked ?? false,
        'yellow_photo_url': levels[AchievementLevel.yellow]?.photoUrl,
        'yellow_unlocked_at': levels[AchievementLevel.yellow]?.unlockedAt?.toIso8601String(),
        'red_unlocked': levels[AchievementLevel.red]?.unlocked ?? false,
        'red_photo_url': levels[AchievementLevel.red]?.photoUrl,
        'red_unlocked_at': levels[AchievementLevel.red]?.unlockedAt?.toIso8601String(),
      };
}

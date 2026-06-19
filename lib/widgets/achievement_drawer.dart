import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';
import '../models/species.dart';
import '../models/achievement.dart';
import '../providers/app_providers.dart';
import '../services/storage_service.dart';

void showAchievementDrawer(BuildContext context, Species species) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _AchievementDrawer(species: species),
  );
}

class _AchievementDrawer extends ConsumerStatefulWidget {
  final Species species;
  const _AchievementDrawer({required this.species});

  @override
  ConsumerState<_AchievementDrawer> createState() =>
      _AchievementDrawerState();
}

class _AchievementDrawerState extends ConsumerState<_AchievementDrawer> {
  AchievementLevel? _uploading;

  Achievement _getAchievement() {
    final map = ref.watch(achievementsProvider).value ?? {};
    return map[widget.species.id] ??
        Achievement.empty(widget.species.id, '');
  }

  Future<void> _onLevelTap(AchievementLevel level, Achievement current) async {
    final levelData = current.levels[level]!;

    if (levelData.unlocked) {
      // Long-press is handled separately; tap on unlocked = view photo
      if (levelData.photoUrl != null) {
        _showPhotoViewer(levelData.photoUrl!);
      }
      return;
    }

    // Confirm unlock
    final confirmed = await _confirmUnlock(level);
    if (!confirmed) return;

    // Pick photo (optional)
    String? photoUrl;
    final pick = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (pick != null && mounted) {
      setState(() => _uploading = level);
      try {
        final user = ref.read(currentUserProvider).value;
        if (user != null) {
          photoUrl = await ref.read(storageServiceProvider).uploadPhoto(
                userId: user.id,
                speciesId: widget.species.id,
                levelKey: levelInfo(level).key,
                file: File(pick.path),
              );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Photo upload failed: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _uploading = null);
      }
    }

    if (mounted) {
      await ref
          .read(achievementsProvider.notifier)
          .unlock(widget.species.id, level, photoUrl: photoUrl);
    }
  }

  Future<void> _onLevelLongPress(
      AchievementLevel level, Achievement current) async {
    final levelData = current.levels[level]!;
    if (!levelData.unlocked) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Achievement?'),
        content: Text(
          'Remove the "${levelInfo(level).labelEn}" badge for ${widget.species.commonName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref
          .read(achievementsProvider.notifier)
          .revoke(widget.species.id, level);
    }
  }

  Future<bool> _confirmUnlock(AchievementLevel level) async {
    final info = levelInfo(level);
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: info.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(info.icon, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text('Unlock ${info.labelEn}?'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.descriptionEn),
                const SizedBox(height: 8),
                Text(info.descriptionZh,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 12),
                const Text(
                  'You can optionally upload a proof photo next.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(backgroundColor: info.color),
                child: const Text('Unlock!'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showPhotoViewer(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final achievement = _getAchievement();
    final highest = achievement.highestLevel;
    final highestInfo = highest != null ? levelInfo(highest) : null;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.species.chineseName != null)
                        Text(
                          widget.species.chineseName!,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      Text(
                        widget.species.commonName,
                        style: TextStyle(
                          fontSize: widget.species.chineseName != null ? 14 : 22,
                          color: widget.species.chineseName != null
                              ? Colors.grey[600]
                              : null,
                          fontWeight: widget.species.chineseName != null
                              ? FontWeight.w500
                              : FontWeight.bold,
                        ),
                      ),
                      if (widget.species.scientificName != null)
                        Text(
                          widget.species.scientificName!,
                          style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[500]),
                        ),
                    ],
                  ),
                ),
                if (highestInfo != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: highestInfo.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      highestInfo.labelZh,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 24),
          // Level tiles
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: kLevels.map((info) {
                final data = achievement.levels[info.level]!;
                final isUploading = _uploading == info.level;
                return _LevelTile(
                  info: info,
                  data: data,
                  isUploading: isUploading,
                  onTap: () => _onLevelTap(info.level, achievement),
                  onLongPress: () =>
                      _onLevelLongPress(info.level, achievement),
                );
              }).toList(),
            ),
          ),
          // Description
          if (widget.species.descriptionEn != null ||
              widget.species.descriptionZh != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.species.descriptionZh != null)
                    Text(widget.species.descriptionZh!,
                        style: const TextStyle(fontSize: 13)),
                  if (widget.species.descriptionEn != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      widget.species.descriptionEn!,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final LevelInfo info;
  final LevelData data;
  final bool isUploading;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _LevelTile({
    required this.info,
    required this.data,
    required this.isUploading,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: data.unlocked ? info.bgColor : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: data.unlocked ? info.borderColor : Colors.grey[200]!,
              width: data.unlocked ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Badge circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.unlocked ? info.color : Colors.grey[200],
                    boxShadow: data.unlocked
                        ? [
                            BoxShadow(
                              color: info.color.withOpacity(0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                  child: isUploading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(
                          data.unlocked ? info.icon : Icons.lock_outline,
                          color: data.unlocked
                              ? Colors.white
                              : Colors.grey[400],
                          size: 22,
                        ),
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            info.labelZh,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: data.unlocked
                                  ? info.color
                                  : Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            info.labelEn,
                            style: TextStyle(
                              fontSize: 12,
                              color: data.unlocked
                                  ? info.color.withOpacity(0.8)
                                  : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        info.descriptionZh,
                        style: TextStyle(
                          fontSize: 12,
                          color: data.unlocked
                              ? Colors.grey[700]
                              : Colors.grey[400],
                        ),
                      ),
                      if (data.unlockedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Unlocked ${_formatDate(data.unlockedAt!)}',
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey[500]),
                        ),
                      ],
                    ],
                  ),
                ),
                // Photo thumbnail or action hint
                if (data.photoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: data.photoUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 20),
                      ),
                    ),
                  )
                else if (!data.unlocked)
                  Icon(Icons.add_circle_outline,
                      color: Colors.grey[300], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

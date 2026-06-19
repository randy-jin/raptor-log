import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/species.dart';
import '../models/achievement.dart';
import 'achievement_progress_dots.dart';

class SpeciesCard extends StatelessWidget {
  final Species species;
  final Achievement? achievement;
  final VoidCallback onTap;

  const SpeciesCard({
    super.key,
    required this.species,
    this.achievement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highest = achievement?.highestLevel;
    final info = highest != null ? levelInfo(highest) : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: info != null ? info.bgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: info != null ? info.borderColor : const Color(0xFFE0E0E0),
            width: info != null ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (info?.color ?? Colors.black).withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: highest badge chip + dots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (info != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: info.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(info.icon, size: 11, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            info.labelZh,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(),
                  AchievementProgressDots(
                    achievement: achievement,
                    size: 8,
                    gap: 3,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Chinese name
              if (species.chineseName != null)
                Text(
                  species.chineseName!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 2),
              // English name
              Text(
                species.commonName,
                style: TextStyle(
                  fontSize: species.chineseName != null ? 12 : 15,
                  fontWeight: species.chineseName != null
                      ? FontWeight.w500
                      : FontWeight.bold,
                  color: species.chineseName != null
                      ? Colors.grey[600]
                      : const Color(0xFF1A1A1A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Scientific name
              if (species.scientificName != null) ...[
                const SizedBox(height: 2),
                Text(
                  species.scientificName!,
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[500],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

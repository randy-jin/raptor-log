import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/achievement.dart';

class AchievementProgressDots extends StatelessWidget {
  final Achievement? achievement;
  final double size;
  final double gap;

  const AchievementProgressDots({
    super.key,
    this.achievement,
    this.size = 10,
    this.gap = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: kLevels.map((info) {
        final unlocked = achievement?.levels[info.level]?.unlocked ?? false;
        return Padding(
          padding: EdgeInsets.only(right: gap),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked ? info.color : const Color(0xFFE0E0E0),
              boxShadow: unlocked
                  ? [BoxShadow(color: info.color.withOpacity(0.4), blurRadius: 4)]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

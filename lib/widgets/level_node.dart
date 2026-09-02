import 'package:flutter/material.dart';
import '../models/heart_level.dart';
import '../theme/app_theme.dart';

class LevelNode extends StatelessWidget {
  final HeartLevel level;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const LevelNode({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;
    Color glowColor;

    if (!isUnlocked) {
      borderColor = Colors.white.withValues(alpha: 0.15);
      bgColor = const Color(0xFF101B15).withValues(alpha: 0.7);
      glowColor = Colors.transparent;
    } else if (level.isBoss) {
      borderColor = const Color(0xFFFF0054);
      bgColor = const Color(0xFF380014).withValues(alpha: 0.95);
      glowColor = const Color(0xFFFF0054);
    } else if (isCompleted) {
      borderColor = const Color(0xFF52B788);
      bgColor = const Color(0xFF0D3322).withValues(alpha: 0.95);
      glowColor = const Color(0xFF52B788);
    } else {
      // Unlocked & Next to play
      borderColor = AppTheme.mintGlow;
      bgColor = const Color(0xFF0F3625).withValues(alpha: 0.95);
      glowColor = AppTheme.mintGlow;
    }

    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: isUnlocked ? (level.isBoss ? 2.8 : 2.0) : 1.2,
          ),
          boxShadow: [
            if (isUnlocked) ...[
              BoxShadow(
                color: glowColor.withValues(alpha: 0.4),
                blurRadius: level.isBoss ? 24 : 14,
                spreadRadius: level.isBoss ? 2 : 1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUnlocked) ...[
                  const Icon(
                    Icons.lock_rounded,
                    color: Color(0xFF758A80),
                    size: 26,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.id,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF758A80),
                    ),
                  ),
                ] else ...[
                  Text(
                    level.iconEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.id,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      color: level.isBoss ? const Color(0xFFFF8FA3) : const Color(0xFFE8F5E9),
                    ),
                  ),
                ],
              ],
            ),

            // Completion badge checkmark
            if (isCompleted)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF52B788),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 11,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

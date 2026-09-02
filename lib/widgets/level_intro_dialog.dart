import 'package:flutter/material.dart';
import '../models/heart_level.dart';
import '../theme/app_theme.dart';

class LevelIntroDialog extends StatelessWidget {
  final HeartLevel level;
  final VoidCallback onEnterBattle;

  const LevelIntroDialog({
    super.key,
    required this.level,
    required this.onEnterBattle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF091E16).withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: level.isBoss ? const Color(0xFFFF0054) : AppTheme.mintGlow,
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: (level.isBoss ? const Color(0xFFFF0054) : AppTheme.mintGlow)
                  .withValues(alpha: 0.3),
              blurRadius: 28,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Badge & Boss Marker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (level.isBoss ? const Color(0xFFFF0054) : AppTheme.leafGreen)
                        .withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: level.isBoss ? const Color(0xFFFF0054) : AppTheme.leafGreen,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    'LEVEL ${level.id}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      color: level.isBoss ? const Color(0xFFFF8FA3) : AppTheme.mintGlow,
                    ),
                  ),
                ),
                if (level.isBoss)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0054).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'BOSS ENCOUNTER',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFFFF0054),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Level Title
            Text(
              level.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Color(0xFFFFF0F3),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              level.subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.mintGlow.withValues(alpha: 0.8),
              ),
            ),

            const SizedBox(height: 16),

            // Scenario Briefing
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF04140E).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.glassBorder,
                  width: 1,
                ),
              ),
              child: Text(
                level.scenario,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: Color(0xFFD8F3DC),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Threat & Objective
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E0A10).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: level.enemy.threatColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THREAT',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                            color: level.enemy.threatColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          level.enemy.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C2B1F).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.leafGreen.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OBJECTIVE',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                            color: AppTheme.mintGlow,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Protect Heart-Rose',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB7E4C7),
                      side: BorderSide(color: AppTheme.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onEnterBattle();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: level.isBoss ? const Color(0xFFFF0054) : AppTheme.rosePetal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 6,
                      shadowColor: (level.isBoss ? const Color(0xFFFF0054) : AppTheme.rosePetal)
                          .withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ENTER BATTLE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

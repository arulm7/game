import 'package:flutter/material.dart';
import '../game/game_logic.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';

class ResultDialog extends StatelessWidget {
  final DefenseResolution resolution;
  final VoidCallback onReplay;
  final VoidCallback onReturnToAtrium;

  const ResultDialog({
    super.key,
    required this.resolution,
    required this.onReplay,
    required this.onReturnToAtrium,
  });

  @override
  Widget build(BuildContext context) {
    final isVictory = resolution.outcome == PuzzleOutcome.success;
    final titleColor = isVictory ? AppTheme.leafGreen : AppTheme.amberSeed;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF091E16),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isVictory ? AppTheme.leafGreen : AppTheme.amberSeed,
            width: 2.2,
          ),
          boxShadow: [
            BoxShadow(
              color: (isVictory ? AppTheme.leafGreen : AppTheme.amberSeed)
                  .withValues(alpha: 0.4),
              blurRadius: 32,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result Emblem Badge
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isVictory
                        ? [
                            AppTheme.leafGreen,
                            const Color(0xFF1B4332),
                            const Color(0xFF061A12),
                          ]
                        : [
                            AppTheme.amberSeed,
                            const Color(0xFF5A3A00),
                            const Color(0xFF261800),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isVictory ? AppTheme.leafGreen : AppTheme.amberSeed)
                          .withValues(alpha: 0.55),
                      blurRadius: 22,
                    ),
                  ],
                  border: Border.all(
                    color: isVictory ? const Color(0xFFA7F3D0) : const Color(0xFFFFE8A3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isVictory ? Icons.verified_rounded : Icons.shield_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Title Header
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  resolution.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: titleColor,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Narrative Resolution Text
              Text(
                resolution.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFFD8F3DC),
                ),
              ),

              const SizedBox(height: 18),

              // Reward Banner: Magical Botanical Resilience Seed Relic
              if (resolution.awardedSeed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1C00),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppTheme.amberSeed,
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.amberSeed.withValues(alpha: 0.35),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.grain_rounded,
                          color: AppTheme.amberSeed,
                          size: 26,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '+1 RESILIENCE SEED AWARDED!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.9,
                            color: AppTheme.amberSeed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 22),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReturnToAtrium,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: AppTheme.glassBorder,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'ATRIUM',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: Color(0xFFD8F3DC),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onReplay,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppTheme.leafGreen,
                        foregroundColor: Colors.black,
                        elevation: 6,
                        shadowColor: AppTheme.leafGreen.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'PLAY AGAIN',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

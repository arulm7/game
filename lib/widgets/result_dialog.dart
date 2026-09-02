import 'package:flutter/material.dart';
import '../game/game_logic.dart';
import '../models/heart_level.dart';
import '../theme/app_theme.dart';

class ResultDialog extends StatelessWidget {
  final DefenseResolution resolution;
  final HeartLevel? level;
  final VoidCallback onReplay;
  final VoidCallback onReturnToCampaign;
  final VoidCallback? onViewBioFact;

  const ResultDialog({
    super.key,
    required this.resolution,
    this.level,
    required this.onReplay,
    required this.onReturnToCampaign,
    this.onViewBioFact,
  });

  @override
  Widget build(BuildContext context) {
    final isVictory = resolution.isVictory;
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
                  isVictory ? 'LEVEL SECURED • VICTORY!' : 'DEFENSIVE STRAIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: titleColor,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Synergy Name Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.mintGlow.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.mintGlow.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  resolution.synergyName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    color: AppTheme.mintGlow,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Narrative Resolution Text
              Text(
                resolution.outcomeDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFFD8F3DC),
                ),
              ),

              const SizedBox(height: 18),

              // Reward Banner
              if (isVictory)
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.grain_rounded,
                          color: AppTheme.amberSeed,
                          size: 26,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '+${level?.seedReward ?? 1} RESILIENCE SEED AWARDED!',
                          style: const TextStyle(
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

              const SizedBox(height: 20),

              // View Bio-Fact Button (If victory & level provided)
              if (isVictory && onViewBioFact != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onViewBioFact,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF2D6A4F),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: const Color(0xFF52B788).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'VIEW BIO-FACT',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Action Buttons: Campaign Map & Play Again
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReturnToCampaign,
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
                        'CAMPAIGN',
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
                        backgroundColor: isVictory ? AppTheme.leafGreen : AppTheme.rosePetal,
                        foregroundColor: isVictory ? Colors.black : Colors.white,
                        elevation: 6,
                        shadowColor: AppTheme.leafGreen.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isVictory ? 'REPLAY' : 'TRY AGAIN',
                        style: const TextStyle(
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

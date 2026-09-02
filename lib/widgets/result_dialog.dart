import 'package:flutter/material.dart';
import '../game/game_logic.dart';
import '../models/battle_outcome.dart';
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

  Color _getGradeColor(BattleOutcomeGrade grade) {
    switch (grade) {
      case BattleOutcomeGrade.excellent:
        return const Color(0xFF52B788);
      case BattleOutcomeGrade.good:
        return const Color(0xFF38BDF8);
      case BattleOutcomeGrade.poor:
        return const Color(0xFFFFD166);
      case BattleOutcomeGrade.toxic:
        return const Color(0xFFFF0054);
    }
  }

  IconData _getGradeIcon(BattleOutcomeGrade grade) {
    switch (grade) {
      case BattleOutcomeGrade.excellent:
        return Icons.verified_rounded;
      case BattleOutcomeGrade.good:
        return Icons.shield_rounded;
      case BattleOutcomeGrade.poor:
        return Icons.warning_amber_rounded;
      case BattleOutcomeGrade.toxic:
        return Icons.dangerous_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grade = resolution.grade;
    final isVictory = resolution.isVictory;
    final themeColor = _getGradeColor(grade);

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
            color: themeColor,
            width: 2.2,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.4),
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
              // Result Grade Emblem Badge
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      themeColor,
                      const Color(0xFF1B4332),
                      const Color(0xFF061A12),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.55),
                      blurRadius: 22,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getGradeIcon(grade),
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
                  resolution.outcome.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: themeColor,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Grade & Synergy Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: themeColor, width: 1),
                    ),
                    child: Text(
                      resolution.outcome.gradeLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: themeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.mintGlow.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.mintGlow.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        resolution.synergyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: AppTheme.mintGlow,
                        ),
                      ),
                    ),
                  ),
                ],
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

              const SizedBox(height: 14),

              // Pressure & Vitality Change Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF04140E).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.glassBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      resolution.pressureChange <= 0
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      size: 16,
                      color: resolution.pressureChange <= 0
                          ? const Color(0xFF52B788)
                          : const Color(0xFFFF758F),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pressure: ${resolution.pressureChange > 0 ? "+" : ""}${resolution.pressureChange}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: resolution.pressureChange <= 0
                            ? const Color(0xFF52B788)
                            : const Color(0xFFFF758F),
                      ),
                    ),
                    if (resolution.vitalityRestored > 0) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.favorite_rounded, size: 14, color: Color(0xFFFF758F)),
                      const SizedBox(width: 4),
                      Text(
                        '+${resolution.vitalityRestored} Vitality',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF8FA3),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Reward Banner
              if (isVictory)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1C00),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.amberSeed,
                      width: 1.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.amberSeed.withValues(alpha: 0.35),
                        blurRadius: 14,
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
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${level?.seedReward ?? 1} RESILIENCE SEED AWARDED!',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: AppTheme.amberSeed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 18),

              // View Bio-Fact Button (If victory & level provided)
              if (isVictory && onViewBioFact != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onViewBioFact,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
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
                        padding: const EdgeInsets.symmetric(vertical: 13),
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
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          color: Color(0xFFD8F3DC),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onReplay,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
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
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
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

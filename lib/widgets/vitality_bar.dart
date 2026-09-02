import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VitalityBar extends StatelessWidget {
  final int vitality;
  final int maxVitality;
  final String label;

  const VitalityBar({
    super.key,
    required this.vitality,
    this.maxVitality = 100,
    this.label = 'HEART VITALITY',
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (vitality / maxVitality).clamp(0.0, 1.0);
    final color = ratio > 0.6
        ? AppTheme.leafGreen
        : ratio > 0.3
            ? AppTheme.amberSeed
            : AppTheme.plaqueWarning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFF091E16).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.rosePetal.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      size: 15,
                      color: AppTheme.mintGlow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.3,
                      color: Color(0xFFD8F3DC),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$vitality%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Botanical Living Sap Channel
          Stack(
            children: [
              // Living root conduit track
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF04100B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.glassBorder.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
              ),

              // Animated Living Sap Fill
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                widthFactor: ratio,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.7),
                        color,
                        const Color(0xFFE8F5E9),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.65),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

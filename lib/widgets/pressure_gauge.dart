import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PressureGauge extends StatelessWidget {
  final int pressure;
  final int baselinePressure;

  const PressureGauge({
    super.key,
    required this.pressure,
    this.baselinePressure = 100,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = ((pressure - 40) / 160.0).clamp(0.0, 1.0);
    final isElevated = pressure >= 90 && pressure <= 120;
    final isLow = pressure < 90;

    final Color statusColor = isLow
        ? AppTheme.leafGreen
        : isElevated
            ? AppTheme.amberSeed
            : AppTheme.plaqueWarning;

    final String statusText = isLow
        ? 'CALM / STABLE'
        : isElevated
            ? 'ELEVATED SURGE'
            : 'CRITICAL PRESSURE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF091E16).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                  Icon(
                    Icons.speed_rounded,
                    size: 14,
                    color: statusColor,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'VASCULAR PRESSURE',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      color: Color(0xFFD8F3DC),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: statusColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$pressure',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Bar Track
          Stack(
            children: [
              Container(
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFF04100B),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppTheme.glassBorder.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                widthFactor: ratio,
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withValues(alpha: 0.65),
                        statusColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.5),
                        blurRadius: 6,
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

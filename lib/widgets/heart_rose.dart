import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HeartRose extends StatefulWidget {
  final double size;
  final double vitalityRatio;
  final bool isGlowing;

  const HeartRose({
    super.key,
    this.size = 190,
    this.vitalityRatio = 0.8,
    this.isGlowing = true,
  });

  @override
  State<HeartRose> createState() => _HeartRoseState();
}

class _HeartRoseState extends State<HeartRose>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Heart rhythm pulse: natural biological double-beat feeling
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final pulseVal = _pulseAnimation.value;
        final scale = 0.94 + (pulseVal * 0.08 * (0.5 + widget.vitalityRatio * 0.5));
        final glowAlpha = (0.3 + pulseVal * 0.45).clamp(0.0, 1.0);

        return SizedBox(
          width: widget.size,
          height: widget.size * 1.15,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient radiant plant aura
              if (widget.isGlowing)
                Container(
                  width: widget.size * scale * 0.85,
                  height: widget.size * scale * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.roseGlow.withValues(alpha: glowAlpha * 0.4),
                        blurRadius: 36,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: AppTheme.leafGreen.withValues(alpha: glowAlpha * 0.3),
                        blurRadius: 48,
                        spreadRadius: 14,
                      ),
                    ],
                  ),
                ),

              // Living Plant Image with scale pulse
              Transform.scale(
                scale: scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size * 0.5),
                  child: Image.asset(
                    'assets/images/heart/heart_rose.png',
                    width: widget.size * 0.95,
                    height: widget.size * 1.1,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to custom vector painter if asset loading fails
                      return CustomPaint(
                        size: Size(widget.size, widget.size * 1.15),
                        painter: _LivingHeartRosePainter(
                          vitalityRatio: widget.vitalityRatio,
                          pulseValue: pulseVal,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Living Sap Sparkle Spores Overlay
              CustomPaint(
                size: Size(widget.size, widget.size * 1.15),
                painter: _LifeSporePainter(pulse: pulseVal),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LifeSporePainter extends CustomPainter {
  final double pulse;

  _LifeSporePainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.42);
    final sparklePaint = Paint()
      ..color = const Color(0xFFFFD166).withValues(alpha: 0.7 + pulse * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) + (pulse * 0.3);
      final r = 12.0 + (i % 2) * 8.0;
      final px = center.dx + cos(angle) * r;
      final py = center.dy + sin(angle) * r;
      canvas.drawCircle(Offset(px, py), 2.0, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LifeSporePainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

class _LivingHeartRosePainter extends CustomPainter {
  final double vitalityRatio;
  final double pulseValue;

  _LivingHeartRosePainter({
    required this.vitalityRatio,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.45);
    final outerGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(const Color(0xFF6B2034), const Color(0xFFFF758F), vitalityRatio)!,
        Color.lerp(const Color(0xFF47111F), const Color(0xFFFF4D6D), vitalityRatio)!,
        const Color(0xFFC9184A),
      ],
    );
    final paint = Paint()
      ..shader = outerGradient.createShader(Rect.fromCircle(center: center, radius: size.width * 0.4))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.35, paint);
  }

  @override
  bool shouldRepaint(covariant _LivingHeartRosePainter oldDelegate) => false;
}

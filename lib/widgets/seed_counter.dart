import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SeedCounter extends StatefulWidget {
  final int count;

  const SeedCounter({
    super.key,
    required this.count,
  });

  @override
  State<SeedCounter> createState() => _SeedCounterState();
}

class _SeedCounterState extends State<SeedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF131F16).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.amberSeed.withValues(alpha: 0.65),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.amberSeed.withValues(alpha: 0.2),
            blurRadius: 14,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Glowing Botanical Seed Relic Icon
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(20, 24),
                painter: _BotanicalSeedPainter(pulse: _pulseController.value),
              );
            },
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'RESILIENCE SEEDS',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.9,
                  color: Color(0xFFA7D8B9),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Text(
                  '${widget.count}',
                  key: ValueKey<int>(widget.count),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.amberSeed,
                    letterSpacing: 0.5,
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

class _BotanicalSeedPainter extends CustomPainter {
  final double pulse;

  _BotanicalSeedPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Glowing aura behind seed
    final auraPaint = Paint()
      ..color = AppTheme.amberSeed.withValues(alpha: 0.4 + pulse * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, size.width * 0.45, auraPaint);

    // Organic Teardrop Seed Silhouette
    final seedPath = Path()
      ..moveTo(center.dx, 1)
      ..cubicTo(
        size.width * 0.95,
        size.height * 0.45,
        size.width * 0.85,
        size.height * 0.92,
        center.dx,
        size.height - 1,
      )
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.92,
        size.width * 0.05,
        size.height * 0.45,
        center.dx,
        1,
      );

    final seedGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFE8A3),
        Color(0xFFFFD166),
        Color(0xFFCC8A00),
        Color(0xFF664400),
      ],
    );

    final seedPaint = Paint()
      ..shader = seedGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(seedPath, seedPaint);

    // Engraved Leaf Sprout Marking in seed center
    final sproutPaint = Paint()
      ..color = const Color(0xFF382300).withValues(alpha: 0.7)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sproutPath = Path()
      ..moveTo(center.dx, size.height * 0.3)
      ..quadraticBezierTo(center.dx, size.height * 0.6, center.dx, size.height * 0.75);

    canvas.drawPath(sproutPath, sproutPaint);

    // Sparkle glint on seed tip
    final glintPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx, size.height * 0.25), 1.2, glintPaint);
  }

  @override
  bool shouldRepaint(covariant _BotanicalSeedPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

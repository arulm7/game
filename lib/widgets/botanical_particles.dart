import 'dart:math';
import 'package:flutter/material.dart';

class BotanicalParticles extends StatefulWidget {
  final int count;
  final Widget? child;

  const BotanicalParticles({
    super.key,
    this.count = 24,
    this.child,
  });

  @override
  State<BotanicalParticles> createState() => _BotanicalParticlesState();
}

class _BotanicalParticlesState extends State<BotanicalParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(widget.count, (index) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: 1.5 + _random.nextDouble() * 3.0,
        speedY: 0.05 + _random.nextDouble() * 0.12,
        speedX: (_random.nextDouble() - 0.5) * 0.04,
        opacity: 0.2 + _random.nextDouble() * 0.6,
        color: index % 3 == 0
            ? const Color(0xFFFF758F) // Rose glow
            : index % 3 == 1
                ? const Color(0xFF74C69D) // Mint glow
                : const Color(0xFFFFD166), // Gold pollen
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ParticlePainter(_particles, _controller.value),
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  final double radius;
  final double speedY;
  final double speedX;
  final double opacity;
  final Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedY,
    required this.speedX,
    required this.opacity,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final currentY = (p.y - progress * p.speedY) % 1.0;
      final currentX = (p.x + sin((progress + p.y) * 2 * pi) * 0.03) % 1.0;

      final posX = (currentX < 0 ? currentX + 1.0 : currentX) * size.width;
      final posY = (currentY < 0 ? currentY + 1.0 : currentY) * size.height;

      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 0.8);

      canvas.drawCircle(Offset(posX, posY), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

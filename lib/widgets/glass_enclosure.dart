import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassEnclosure extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final String? label;

  const GlassEnclosure({
    super.key,
    required this.child,
    this.width = 250,
    this.height = 310,
    this.onTap,
    this.label,
  });

  @override
  State<GlassEnclosure> createState() => _GlassEnclosureState();
}

class _GlassEnclosureState extends State<GlassEnclosure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheenController;

  @override
  void initState() {
    super.initState();
    _sheenController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _sheenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Terrarium Atmospheric Back Glow
                Positioned(
                  top: 15,
                  child: Container(
                    width: widget.width * 0.8,
                    height: widget.height * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.mintGlow.withValues(alpha: 0.22),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Terrarium Enclosure Base Dome
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/heart/glass_terrarium.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: AppTheme.glassGradient,
                          border: Border.all(color: AppTheme.glassBorder, width: 1.8),
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Organ Plant Composited Inside Enclosure
                Positioned(
                  top: widget.height * 0.18,
                  bottom: widget.height * 0.2,
                  child: Center(child: widget.child),
                ),

                // 4. Dynamic Glass Sheen & Highlight Reflections
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _sheenController,
                      builder: (context, _) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: _TerrariumGlassHighlightPainter(
                            progress: _sheenController.value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Enclosure Sanctuary Label
          if (widget.label != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF091E16).withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.mintGlow.withValues(alpha: 0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.3,
                  color: Color(0xFFD8F3DC),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TerrariumGlassHighlightPainter extends CustomPainter {
  final double progress;

  _TerrariumGlassHighlightPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Dynamic glass shine reflection
    final glintAngle = progress * 2 * pi;
    final glintX = size.width * 0.5 + cos(glintAngle) * (size.width * 0.2);
    final glintY = size.height * 0.22 + sin(glintAngle) * 6;

    final glintPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(Offset(glintX, glintY), 12, glintPaint);
  }

  @override
  bool shouldRepaint(covariant _TerrariumGlassHighlightPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

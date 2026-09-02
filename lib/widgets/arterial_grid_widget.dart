import 'dart:math';
import 'package:flutter/material.dart';
import '../models/grid_cell.dart';
import '../theme/app_theme.dart';

class ArterialGridWidget extends StatefulWidget {
  final List<GridCell> grid;
  final bool isResolving;

  const ArterialGridWidget({
    super.key,
    required this.grid,
    this.isResolving = false,
  });

  @override
  State<ArterialGridWidget> createState() => _ArterialGridWidgetState();
}

class _ArterialGridWidgetState extends State<ArterialGridWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF061811).withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppTheme.glassBorder,
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppTheme.leafGreen.withValues(alpha: 0.15),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final pulseVal = _pulseController.value;

            return Stack(
              children: [
                // 1. High Resolution Arterial Root Network Background Artwork
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.45 + pulseVal * 0.15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/heart/arterial_root_network.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),

                // 2. Animated Vascular Conduit Lines
                CustomPaint(
                  size: Size.infinite,
                  painter: _LivingArterialNetworkPainter(pulse: pulseVal),
                ),

                // 3. 3x3 Grid of Interactive Vascular Root Chambers
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: widget.grid.length,
                  itemBuilder: (context, index) {
                    final cell = widget.grid[index];
                    return _buildNode(cell, pulseVal);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNode(GridCell cell, double pulseVal) {
    Color borderColor;
    Color bgColor;
    Color glowColor;
    Widget nodeVisual;
    String statusText;

    switch (cell.status) {
      case CellStatus.open:
        borderColor = AppTheme.leafGreen.withValues(alpha: 0.7);
        bgColor = const Color(0xFF0F3625).withValues(alpha: 0.85);
        glowColor = AppTheme.leafGreen;
        statusText = 'FLOW ACTIVE';
        nodeVisual = Icon(
          Icons.waves_rounded,
          color: AppTheme.mintGlow.withValues(alpha: 0.9 + pulseVal * 0.1),
          size: 20,
        );
        break;

      case CellStatus.blocked:
        borderColor = AppTheme.plaqueWarning;
        bgColor = const Color(0xFF330B14).withValues(alpha: 0.9);
        glowColor = AppTheme.plaqueWarning;
        statusText = '[X] BLOCKED';
        nodeVisual = Icon(
          Icons.coronavirus_rounded,
          color: AppTheme.plaqueWarning.withValues(alpha: 0.85 + pulseVal * 0.15),
          size: 20,
        );
        break;

      case CellStatus.critical:
        borderColor = AppTheme.amberSeed;
        bgColor = const Color(0xFF382002).withValues(alpha: 0.9);
        glowColor = AppTheme.amberSeed;
        statusText = '[!] CRITICAL';
        nodeVisual = Icon(
          Icons.warning_amber_rounded,
          color: AppTheme.amberSeed.withValues(alpha: 0.85 + pulseVal * 0.15),
          size: 22,
        );
        break;

      case CellStatus.cleared:
        borderColor = const Color(0xFF38BDF8);
        bgColor = const Color(0xFF0B3347).withValues(alpha: 0.9);
        glowColor = const Color(0xFF38BDF8);
        statusText = 'PURIFIED';
        nodeVisual = const Icon(
          Icons.auto_awesome_rounded,
          color: Color(0xFF38BDF8),
          size: 20,
        );
        break;
    }

    final isThreat = cell.status == CellStatus.blocked || cell.status == CellStatus.critical;
    final pulseAlpha = isThreat ? (0.2 + pulseVal * 0.45) : (0.1 + pulseVal * 0.2);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: isThreat ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: pulseAlpha),
            blurRadius: isThreat ? 14 : 6,
            spreadRadius: isThreat ? 1 : 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            nodeVisual,
            const SizedBox(height: 2),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                color: borderColor,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              cell.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD8F3DC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivingArterialNetworkPainter extends CustomPainter {
  final double pulse;

  _LivingArterialNetworkPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / 3;
    final cellH = size.height / 3;

    // Organic Interconnecting Blood Vessel Conduit Lines
    final vesselPaint = Paint()
      ..color = const Color(0xFF1B4332).withValues(alpha: 0.75)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sapFlowPaint = Paint()
      ..color = AppTheme.mintGlow.withValues(alpha: 0.35 + pulse * 0.35)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Horizontal vascular conduits
    for (int r = 0; r < 3; r++) {
      final y = r * cellH + cellH / 2;
      final path = Path()
        ..moveTo(cellW / 2, y)
        ..quadraticBezierTo(size.width / 2, y + sin(pulse * pi + r) * 3, size.width - cellW / 2, y);
      canvas.drawPath(path, sapFlowPaint);
      canvas.drawPath(path, vesselPaint);
    }

    // Vertical vascular conduits
    for (int c = 0; c < 3; c++) {
      final x = c * cellW + cellW / 2;
      final path = Path()
        ..moveTo(x, cellH / 2)
        ..quadraticBezierTo(x + cos(pulse * pi + c) * 3, size.height / 2, x, size.height - cellH / 2);
      canvas.drawPath(path, sapFlowPaint);
      canvas.drawPath(path, vesselPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LivingArterialNetworkPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

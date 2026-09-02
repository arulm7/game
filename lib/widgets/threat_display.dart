import 'dart:math';
import 'package:flutter/material.dart';
import '../models/enemy.dart';

class ThreatDisplay extends StatefulWidget {
  final Enemy enemy;
  final bool compact;

  const ThreatDisplay({
    super.key,
    required this.enemy,
    this.compact = false,
  });

  @override
  State<ThreatDisplay> createState() => _ThreatDisplayState();
}

class _ThreatDisplayState extends State<ThreatDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wiggleController;

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C0D12).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: widget.enemy.threatColor.withValues(alpha: 0.7),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.enemy.threatColor.withValues(alpha: 0.25),
            blurRadius: 18,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated Plaque Creep Creature Asset Portrait
          AnimatedBuilder(
            animation: _wiggleController,
            builder: (context, child) {
              final wobble = sin(_wiggleController.value * pi) * 0.08;
              return Transform.rotate(
                angle: wobble,
                child: Container(
                  width: widget.compact ? 52 : 66,
                  height: widget.compact ? 52 : 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5964).withValues(alpha: 0.45),
                        blurRadius: 14,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFFF8FA3),
                      width: 1.8,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      widget.enemy.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF800F2F),
                        child: const Icon(
                          Icons.coronavirus_rounded,
                          color: Color(0xFFFF5964),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),

          // Threat Information & Creature Lore
          Expanded(
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
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.enemy.threatColor,
                            boxShadow: [
                              BoxShadow(
                                color: widget.enemy.threatColor,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ACTIVE BLIGHT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.3,
                            color: widget.enemy.threatColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.enemy.threatColor.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.enemy.threatColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'HP ${widget.enemy.currentHealth}/${widget.enemy.maxHealth}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: widget.enemy.threatColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.enemy.name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: Color(0xFFFFF0F3),
                  ),
                ),
                if (widget.enemy.type == EnemyType.stressAndSodium) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF758F).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFFF758F).withValues(alpha: 0.6),
                            width: 0.8,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bolt_rounded, size: 10, color: Color(0xFFFF758F)),
                            SizedBox(width: 3),
                            Text(
                              'STRESS',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF758F),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9E00).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFFF9E00).withValues(alpha: 0.6),
                            width: 0.8,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.grain_rounded, size: 10, color: Color(0xFFFF9E00)),
                            SizedBox(width: 3),
                            Text(
                              'SODIUM',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF9E00),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (!widget.compact) ...[
                  const SizedBox(height: 3),
                  Text(
                    widget.enemy.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: const Color(0xFFFCD5CE).withValues(alpha: 0.85),
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

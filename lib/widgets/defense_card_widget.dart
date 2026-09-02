import 'package:flutter/material.dart';
import '../models/defense_card.dart';
import '../theme/app_theme.dart';

class DefenseCardWidget extends StatefulWidget {
  final DefenseCard card;
  final bool isSelected;
  final bool isSelectionLocked;
  final VoidCallback onTap;

  const DefenseCardWidget({
    super.key,
    required this.card,
    required this.isSelected,
    this.isSelectionLocked = false,
    required this.onTap,
  });

  @override
  State<DefenseCardWidget> createState() => _DefenseCardWidgetState();
}

class _DefenseCardWidgetState extends State<DefenseCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  LinearGradient _getCardGradient() {
    switch (widget.card.type) {
      case DefenseCardType.isotonicFlow:
        return AppTheme.isotonicGradient;
      case DefenseCardType.beetrootFlush:
        return AppTheme.beetrootGradient;
      case DefenseCardType.potassiumRainbow:
        return AppTheme.potassiumGradient;
      case DefenseCardType.relaxation:
        return AppTheme.relaxationGradient;
      case DefenseCardType.isometricHold:
        return AppTheme.isometricGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.isSelected ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      child: GestureDetector(
        onTap: widget.isSelectionLocked ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, _) {
            final pulseVal = _glowController.value;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 172,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                gradient: _getCardGradient(),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.card.accentColor
                      : AppTheme.glassBorder,
                  width: widget.isSelected ? 2.4 : 1.2,
                ),
                boxShadow: [
                  if (widget.isSelected) ...[
                    BoxShadow(
                      color: widget.card.accentColor.withValues(alpha: 0.45 + pulseVal * 0.25),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Pure Illustration Artwork Thumbnail (No text, pure art)
                  Stack(
                    children: [
                      Container(
                        height: 72,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.card.accentColor.withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.card.accentColor.withValues(alpha: 0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.asset(
                            widget.card.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: widget.card.accentColor.withValues(alpha: 0.25),
                              child: Icon(
                                widget.card.icon,
                                size: 28,
                                color: widget.card.accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Energy Crystal Badge
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF04141C).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.energyCyan.withValues(alpha: 0.8),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.energyCyan.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.bolt_rounded,
                                size: 12,
                                color: AppTheme.energyCyan,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${widget.card.energyCost}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.energyCyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // 2. Separate Flutter Text: Card Title
                  Text(
                    widget.card.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.7,
                      color: widget.isSelected ? Colors.white : const Color(0xFFE8F5E9),
                      shadows: widget.isSelected
                          ? [
                              Shadow(
                                color: widget.card.accentColor,
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  ),

                  // 3. Separate Flutter Text: Card Description
                  Expanded(
                    child: Text(
                      widget.card.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.2,
                        height: 1.2,
                        color: const Color(0xFFB7E4C7).withValues(alpha: 0.9),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // 4. Separate Flutter Widget: Selection State Indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? widget.card.accentColor.withValues(alpha: 0.3)
                          : const Color(0xFF05150F),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.isSelected
                            ? widget.card.accentColor
                            : AppTheme.glassBorder.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isSelected) ...[
                            Icon(
                              Icons.check_circle_rounded,
                              size: 12,
                              color: widget.card.accentColor,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            widget.isSelected ? 'SELECTED' : 'TAP TO SELECT',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.9,
                              color: widget.isSelected
                                  ? widget.card.accentColor
                                  : const Color(0xFF74C69D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

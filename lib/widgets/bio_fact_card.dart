import 'package:flutter/material.dart';
import '../models/heart_level.dart';
import '../theme/app_theme.dart';

class BioFactCard extends StatelessWidget {
  final HeartLevel level;
  final VoidCallback onContinue;

  const BioFactCard({
    super.key,
    required this.level,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF071F17).withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF52B788),
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF52B788).withValues(alpha: 0.35),
              blurRadius: 28,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF52B788).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF52B788), width: 1.2),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF74C69D),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BIO-FACT ARCHIVE',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.4,
                            color: Color(0xFF74C69D),
                          ),
                        ),
                        Text(
                          'LEVEL ${level.id} • ${level.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section 1: What Happened
              _buildFactSection(
                title: 'WHAT HAPPENED?',
                icon: Icons.flash_on_rounded,
                iconColor: const Color(0xFFFFD166),
                content: level.bioFact.whatHappened,
              ),

              const SizedBox(height: 12),

              // Section 2: Game Lesson
              _buildFactSection(
                title: 'GAME STRATEGY LESSON',
                icon: Icons.psychology_rounded,
                iconColor: const Color(0xFF38BDF8),
                content: level.bioFact.gameLesson,
              ),

              const SizedBox(height: 12),

              // Section 3: Real-World Connection
              _buildFactSection(
                title: 'REAL-WORLD HEALTH CONNECTION',
                icon: Icons.favorite_rounded,
                iconColor: const Color(0xFFFF758F),
                content: level.bioFact.realWorldConnection,
                isHighlight: true,
              ),

              const SizedBox(height: 20),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6A4F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: const Color(0xFF52B788).withValues(alpha: 0.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONTINUE TO CAMPAIGN',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFactSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight
            ? const Color(0xFF142E23).withValues(alpha: 0.9)
            : const Color(0xFF04140E).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlight
              ? const Color(0xFF52B788).withValues(alpha: 0.6)
              : AppTheme.glassBorder,
          width: isHighlight ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: Color(0xFFD8F3DC),
            ),
          ),
        ],
      ),
    );
  }
}

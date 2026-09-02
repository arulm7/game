import 'package:flutter/material.dart';
import '../../game/heart_campaign.dart';
import '../../models/game_state.dart';
import '../../models/heart_level.dart';
import '../../theme/app_theme.dart';
import '../../widgets/botanical_particles.dart';
import '../../widgets/level_intro_dialog.dart';
import '../../widgets/level_node.dart';
import '../../widgets/seed_counter.dart';
import '../puzzle/arterial_breach_screen.dart';

class HeartCampaignScreen extends StatelessWidget {
  final GameState gameState;

  const HeartCampaignScreen({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Garden / Sanctuary Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/garden/garden_background.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.gardenBackgroundGradient,
                ),
              ),
            ),
          ),

          // 2. Dark Vignette Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xEE040D09),
                    Color(0xBB040D09),
                    Color(0xDD040D09),
                    Color(0xF9040D09),
                  ],
                ),
              ),
            ),
          ),

          // 3. Spores & Campaign Content
          BotanicalParticles(
            count: 24,
            child: SafeArea(
              child: Column(
                children: [
                  // Top Navigation Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFFD8F3DC),
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF091E16).withValues(alpha: 0.8),
                            side: BorderSide(color: AppTheme.glassBorder),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                children: [
                                  Text(
                                    HeartCampaign.stageTitle,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.6,
                                      color: AppTheme.roseGlow,
                                    ),
                                  ),
                                  const Text(
                                    'HEART-ROSE SANCTUARY',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListenableBuilder(
                          listenable: gameState,
                          builder: (context, _) => SeedCounter(
                            count: gameState.resilienceSeeds,
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Stage Subtitle / Mission Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C2B1F).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.mintGlow.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Phase 1: Clear Acute Vascular Blockages to Restore the Heart-Rose',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB7E4C7),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Winding Botanical Campaign Map
                  Expanded(
                    child: ListenableBuilder(
                      listenable: gameState,
                      builder: (context, _) {
                        final progress = gameState.campaignProgress;
                        final levels = HeartCampaign.stage1Levels;

                        return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          itemCount: levels.length,
                          separatorBuilder: (context, index) {
                            return _buildConnectingPath(index, progress.isLevelCompleted(levels[index].id));
                          },
                          itemBuilder: (context, index) {
                            final level = levels[index];
                            final isUnlocked = progress.isLevelUnlocked(level.id);
                            final isCompleted = progress.isLevelCompleted(level.id);

                            // Alternating left/right serpentine alignment
                            final alignment = index % 2 == 0
                                ? Alignment.centerLeft
                                : Alignment.centerRight;

                            return Align(
                              alignment: alignment,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (index % 2 == 1) ...[
                                      _buildLevelInfo(level, isUnlocked),
                                      const SizedBox(width: 12),
                                    ],
                                    LevelNode(
                                      level: level,
                                      isUnlocked: isUnlocked,
                                      isCompleted: isCompleted,
                                      onTap: () => _onLevelTapped(context, level),
                                    ),
                                    if (index % 2 == 0) ...[
                                      const SizedBox(width: 12),
                                      _buildLevelInfo(level, isUnlocked),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingPath(int index, bool isPathActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Column(
          children: List.generate(
            3,
            (i) => Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: 4,
              height: 10,
              decoration: BoxDecoration(
                color: isPathActive
                    ? const Color(0xFF52B788).withValues(alpha: 0.8)
                    : const Color(0xFF1B4332).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isPathActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF52B788).withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelInfo(HeartLevel level, bool isUnlocked) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF091E16).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? (level.isBoss ? const Color(0xFFFF0054).withValues(alpha: 0.6) : AppTheme.mintGlow.withValues(alpha: 0.4))
              : Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            level.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: isUnlocked ? Colors.white : const Color(0xFF758A80),
            ),
          ),
          Text(
            level.enemy.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: isUnlocked
                  ? (level.isBoss ? const Color(0xFFFF8FA3) : const Color(0xFFB7E4C7))
                  : const Color(0xFF526159),
            ),
          ),
        ],
      ),
    );
  }

  void _onLevelTapped(BuildContext context, HeartLevel level) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => LevelIntroDialog(
        level: level,
        onEnterBattle: () {
          gameState.selectLevel(level);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArterialBreachScreen(
                gameState: gameState,
                level: level,
              ),
            ),
          );
        },
      ),
    );
  }
}

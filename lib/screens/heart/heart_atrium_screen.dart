import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/botanical_particles.dart';
import '../../widgets/glass_enclosure.dart';
import '../../widgets/heart_rose.dart';
import '../../widgets/seed_counter.dart';
import '../../widgets/threat_display.dart';
import '../../widgets/vitality_bar.dart';
import '../campaign/heart_campaign_screen.dart';

class HeartAtriumScreen extends StatelessWidget {
  final GameState gameState;

  const HeartAtriumScreen({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HEART-ROSE ATRIUM'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Return to Garden',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: ListenableBuilder(
                listenable: gameState,
                builder: (context, _) => SeedCounter(
                  count: gameState.resilienceSeeds,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.gardenBackgroundGradient,
        ),
        child: BotanicalParticles(
          count: 24,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Section: Living Sap Vitality Gauge
                        ListenableBuilder(
                          listenable: gameState,
                          builder: (context, _) {
                            return VitalityBar(
                              vitality: gameState.vitality,
                              maxVitality: gameState.maxVitality,
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        // Center Section: Sanctuary Terrarium Enclosure with living Heart-Rose
                        ListenableBuilder(
                          listenable: gameState,
                          builder: (context, _) {
                            return GlassEnclosure(
                              width: constraints.maxWidth > 400 ? 260 : 230,
                              height: constraints.maxWidth > 400 ? 310 : 280,
                              label: 'BOTANICAL CORE • HEART-ROSE',
                              child: HeartRose(
                                size: constraints.maxWidth > 400 ? 200 : 175,
                                vitalityRatio: gameState.vitalityRatio,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        // Active Threat: Level Threat Creature
                        ListenableBuilder(
                          listenable: gameState,
                          builder: (context, _) {
                            return ThreatDisplay(
                              enemy: gameState.enemy,
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Bottom Action: ENTER STRATEGY CAMPAIGN
                        _buildEnterStrategyButton(context),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnterStrategyButton(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      child: ElevatedButton(
        onPressed: () => _navigateToCampaign(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.leafGreen,
          foregroundColor: Colors.black,
          elevation: 8,
          shadowColor: AppTheme.leafGreen.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_rounded, size: 22),
              SizedBox(width: 10),
              Text(
                'ENTER CAMPAIGN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCampaign(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HeartCampaignScreen(gameState: gameState),
      ),
    );
  }
}

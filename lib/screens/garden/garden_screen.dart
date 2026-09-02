import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/botanical_particles.dart';
import '../../widgets/glass_enclosure.dart';
import '../../widgets/heart_rose.dart';
import '../../widgets/seed_counter.dart';
import '../heart/heart_atrium_screen.dart';

class GardenScreen extends StatelessWidget {
  final GameState gameState;

  const GardenScreen({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. High Resolution Enchanted Botanical Garden Background Artwork
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

          // 2. Atmospheric Dark Vignette Overlay for perfect readability
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xCC040D09),
                    Color(0x44040D09),
                    Color(0x22040D09),
                    Color(0xDD040D09),
                  ],
                ),
              ),
            ),
          ),

          // 3. Floating Luminescent Spores & Pollen
          BotanicalParticles(
            count: 28,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Header: Game Title & Resilience Seed Relic
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ListenableBuilder(
                                      listenable: gameState,
                                      builder: (context, _) => SeedCounter(
                                        count: gameState.resilienceSeeds,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                _buildGameTitle(),
                                const SizedBox(height: 8),
                                _buildSubtitle(),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Central Sanctuary Enclosure: Living Heart-Rose
                            ListenableBuilder(
                              listenable: gameState,
                              builder: (context, _) {
                                return GlassEnclosure(
                                  width: constraints.maxWidth > 400 ? 270 : 240,
                                  height: constraints.maxWidth > 400 ? 320 : 290,
                                  label: 'ORGAN ENCLOSURE • HEART-ROSE',
                                  onTap: () => _navigateToHeart(context),
                                  child: HeartRose(
                                    size: constraints.maxWidth > 400 ? 190 : 165,
                                    vitalityRatio: gameState.vitalityRatio,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // Living Garden Conduit Pathway Hint
                            _buildGardenPathwayBadge(),

                            const SizedBox(height: 14),

                            // Main Action: ENTER HEART SANCTUARY
                            _buildEnterHeartButton(context),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFF74C69D),
              Color(0xFF52B788),
            ],
          ).createShader(bounds),
          child: const Text(
            'SAVIOURS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.5,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Color(0xFF52B788),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 1.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppTheme.amberSeed],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'VS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.0,
                  color: AppTheme.amberSeed,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 1.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.amberSeed, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFFF8FA3),
              Color(0xFFFF4D6D),
              Color(0xFFC9184A),
            ],
          ).createShader(bounds),
          child: const Text(
            'SABOTEURS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.5,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Color(0xFFFF4D6D),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2B1F).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.mintGlow.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.mintGlow.withValues(alpha: 0.15),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.nature_people_rounded,
            size: 15,
            color: AppTheme.mintGlow,
          ),
          SizedBox(width: 8),
          Text(
            'Protect the Living Garden',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFFB7E4C7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenPathwayBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF091E16).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.glassBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.all_inclusive_rounded,
            size: 16,
            color: AppTheme.mintGlow,
          ),
          SizedBox(width: 8),
          Text(
            'Vascular Root Conduit • Heart Sanctuary',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA7D8B9),
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterHeartButton(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      child: ElevatedButton(
        onPressed: () => _navigateToHeart(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.rosePetal,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppTheme.rosePetal.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_rounded, size: 22),
              SizedBox(width: 10),
              Text(
                'ENTER HEART',
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

  void _navigateToHeart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HeartAtriumScreen(gameState: gameState),
      ),
    );
  }
}

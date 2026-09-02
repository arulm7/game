import 'package:flutter/material.dart';
import '../../game/game_logic.dart';
import '../../models/game_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/arterial_grid_widget.dart';
import '../../widgets/botanical_particles.dart';
import '../../widgets/defense_card_widget.dart';
import '../../widgets/result_dialog.dart';
import '../../widgets/seed_counter.dart';
import '../../widgets/threat_display.dart';
import '../../widgets/vitality_bar.dart';

class ArterialBreachScreen extends StatefulWidget {
  final GameState gameState;

  const ArterialBreachScreen({
    super.key,
    required this.gameState,
  });

  @override
  State<ArterialBreachScreen> createState() => _ArterialBreachScreenState();
}

class _ArterialBreachScreenState extends State<ArterialBreachScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _defendAnimController;

  @override
  void initState() {
    super.initState();
    _defendAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _defendAnimController.dispose();
    super.dispose();
  }

  Future<void> _executeDefense() async {
    if (!widget.gameState.canDefend) return;

    widget.gameState.setResolving(true);
    await _defendAnimController.forward(from: 0.0);

    // Resolve defense logic
    final resolution = GameLogic.resolveDefense(
      selectedCards: widget.gameState.selectedCards,
      currentVitality: widget.gameState.heartVitality,
      currentEnemy: widget.gameState.currentEnemy,
      currentGrid: widget.gameState.grid,
    );

    widget.gameState.updateAfterDefense(
      newVitality: resolution.newVitality,
      updatedEnemy: resolution.updatedEnemy,
      updatedGrid: resolution.updatedGrid,
      outcome: resolution.outcome,
      message: resolution.message,
      awardedSeed: resolution.awardedSeed,
    );

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => ResultDialog(
        resolution: resolution,
        onReplay: () {
          Navigator.of(dialogCtx).pop();
          widget.gameState.resetPuzzle();
        },
        onReturnToAtrium: () {
          Navigator.of(dialogCtx).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('THE ARTERIAL BREACH'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Return to Atrium',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: ListenableBuilder(
                listenable: widget.gameState,
                builder: (context, _) => SeedCounter(
                  count: widget.gameState.resilienceSeeds,
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
          count: 20,
          child: SafeArea(
            child: ListenableBuilder(
              listenable: widget.gameState,
              builder: (context, _) {
                final selectedCount = widget.gameState.selectedCards.length;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Row: Living Sap Vitality Gauge & Threat Snapshot
                      VitalityBar(
                        vitality: widget.gameState.heartVitality,
                        maxVitality: widget.gameState.maxHeartVitality,
                      ),

                      const SizedBox(height: 10),

                      ThreatDisplay(
                        enemy: widget.gameState.currentEnemy,
                        compact: true,
                      ),

                      const SizedBox(height: 14),

                      // Living Root Network Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ARTERIAL ROOT NETWORK',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: Color(0xFFD8F3DC),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF091E16),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.mintGlow.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              '3 × 3 GRID',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.mintGlow,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 3x3 Strategy Grid
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 320),
                          child: ArterialGridWidget(
                            grid: widget.gameState.grid,
                            isResolving: widget.gameState.isResolving,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tactical Botanical Abilities Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'BOTANICAL DEFENSE ABILITIES',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: Color(0xFFD8F3DC),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: selectedCount == 2
                                  ? AppTheme.leafGreen.withValues(alpha: 0.25)
                                  : const Color(0xFF261800),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedCount == 2
                                    ? AppTheme.leafGreen
                                    : AppTheme.amberSeed,
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              'SELECT 2 CARDS ($selectedCount/2)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: selectedCount == 2
                                    ? AppTheme.leafGreen
                                    : AppTheme.amberSeed,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Horizontal Scrollable Cards
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.gameState.availableCards.length,
                          itemBuilder: (context, index) {
                            final card = widget.gameState.availableCards[index];
                            final isSelected = widget.gameState.isCardSelected(card);

                            return DefenseCardWidget(
                              card: card,
                              isSelected: isSelected,
                              isSelectionLocked: widget.gameState.isResolving,
                              onTap: () => widget.gameState.toggleCardSelection(card),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // DEFEND HEART Major Action Button
                      Center(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 380),
                          child: ElevatedButton(
                            onPressed: widget.gameState.canDefend ? _executeDefense : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppTheme.rosePetal,
                              disabledBackgroundColor: const Color(0xFF13221C),
                              foregroundColor: Colors.white,
                              disabledForegroundColor: const Color(0xFF4A6B5E),
                              elevation: widget.gameState.canDefend ? 8 : 0,
                              shadowColor: AppTheme.rosePetal.withValues(alpha: 0.55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: widget.gameState.isResolving
                                ? const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'PURIFYING ARTERIAL BREACH...',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.shield_rounded, size: 22),
                                        const SizedBox(width: 8),
                                        Text(
                                          selectedCount == 2
                                              ? 'DEFEND HEART'
                                              : 'SELECT 2 CARDS TO DEFEND',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

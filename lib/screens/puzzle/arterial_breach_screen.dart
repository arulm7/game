import 'package:flutter/material.dart';
import '../../game/game_logic.dart';
import '../../models/game_state.dart';
import '../../models/heart_level.dart';
import '../../theme/app_theme.dart';
import '../../widgets/arterial_grid_widget.dart';
import '../../widgets/bio_fact_card.dart';
import '../../widgets/botanical_particles.dart';
import '../../widgets/defense_card_widget.dart';
import '../../widgets/pressure_gauge.dart';
import '../../widgets/result_dialog.dart';
import '../../widgets/seed_counter.dart';
import '../../widgets/threat_display.dart';
import '../../widgets/vitality_bar.dart';

class ArterialBreachScreen extends StatefulWidget {
  final GameState gameState;
  final HeartLevel? level;

  const ArterialBreachScreen({
    super.key,
    required this.gameState,
    this.level,
  });

  @override
  State<ArterialBreachScreen> createState() => _ArterialBreachScreenState();
}

class _ArterialBreachScreenState extends State<ArterialBreachScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _defendAnimController;
  bool _isResolving = false;

  @override
  void initState() {
    super.initState();
    _defendAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    if (widget.level != null && widget.gameState.currentLevel.id != widget.level!.id) {
      widget.gameState.selectLevel(widget.level!);
    }
  }

  @override
  void dispose() {
    _defendAnimController.dispose();
    super.dispose();
  }

  HeartLevel get _activeLevel => widget.level ?? widget.gameState.currentLevel;

  Future<void> _executeDefense() async {
    if (widget.gameState.selectedCards.length != 2) return;

    setState(() => _isResolving = true);
    widget.gameState.setBattleStatus(BattleStatus.resolving);
    await _defendAnimController.forward(from: 0.0);

    // Deterministic battle resolution through AbilityResolver & GameLogic
    final resolution = GameLogic.resolveBattle(
      level: _activeLevel,
      selectedCards: widget.gameState.selectedCards,
      currentGrid: widget.gameState.grid,
      currentVitality: widget.gameState.vitality,
      maxVitality: widget.gameState.maxVitality,
      currentPressure: widget.gameState.pressure,
    );

    widget.gameState.applyResolution(resolution);

    setState(() => _isResolving = false);
    if (!mounted) return;

    _showResultDialog(resolution, widget.gameState.isLastVictoryFirstCompletion);
  }

  void _showResultDialog(DefenseResolution resolution, bool isFirstCompletion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => ResultDialog(
        resolution: resolution,
        level: _activeLevel,
        isFirstCompletion: isFirstCompletion,
        onReplay: () {
          Navigator.of(dialogCtx).pop();
          widget.gameState.resetBattleState();
        },
        onReturnToCampaign: () {
          Navigator.of(dialogCtx).pop();
          Navigator.of(context).pop();
        },
        onViewBioFact: resolution.isVictory
            ? () {
                Navigator.of(dialogCtx).pop();
                _showBioFactModal();
              }
            : null,
      ),
    );
  }

  void _showBioFactModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (factCtx) => BioFactCard(
        level: _activeLevel,
        onContinue: () {
          Navigator.of(factCtx).pop();
          Navigator.of(context).pop(); // Return to Campaign Level Select
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BREACH • LEVEL ${_activeLevel.id}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Return to Campaign',
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
                final availableCards = _activeLevel.availableCards;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Row: Living Sap Vitality Gauge & Level Threat
                      VitalityBar(
                        vitality: widget.gameState.vitality,
                        maxVitality: widget.gameState.maxVitality,
                      ),

                      const SizedBox(height: 8),

                      ThreatDisplay(
                        enemy: widget.gameState.enemy,
                        compact: true,
                      ),

                      const SizedBox(height: 8),

                      // Vascular Pressure Gauge
                      PressureGauge(
                        pressure: widget.gameState.pressure,
                      ),

                      const SizedBox(height: 12),

                      // Threat Approach & Scenario Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B090F).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.gameState.enemy.threatColor.withValues(alpha: 0.45),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 15,
                              color: widget.gameState.enemy.threatColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${widget.gameState.enemy.name} approaching the Heart-Rose arterial roots!',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: widget.gameState.enemy.threatColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Living Root Network Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'ARTERIAL ROOT NETWORK • ${_activeLevel.title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                                color: Color(0xFFD8F3DC),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                            isResolving: _isResolving,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tactical Botanical Abilities Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CURATED TACTICAL DECK',
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

                      // Horizontal Scrollable Cards Deck
                      SizedBox(
                        height: 192,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: availableCards.length,
                          itemBuilder: (context, index) {
                            final card = availableCards[index];
                            final isSelected = widget.gameState.selectedCards.any((c) => c.id == card.id);

                            return DefenseCardWidget(
                              card: card,
                              isSelected: isSelected,
                              isSelectionLocked: _isResolving,
                              onTap: () => widget.gameState.toggleCardSelection(card),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // DEFEND HEART Action Button
                      Center(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 380),
                          child: ElevatedButton(
                            onPressed: (selectedCount == 2 && !_isResolving)
                                ? _executeDefense
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppTheme.rosePetal,
                              disabledBackgroundColor: const Color(0xFF13221C),
                              foregroundColor: Colors.white,
                              disabledForegroundColor: const Color(0xFF4A6B5E),
                              elevation: selectedCount == 2 ? 8 : 0,
                              shadowColor: AppTheme.rosePetal.withValues(alpha: 0.55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: _isResolving
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

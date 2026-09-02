import 'package:flutter/foundation.dart';
import '../game/heart_campaign.dart';
import 'ability.dart';
import 'battle_outcome.dart';
import 'campaign_progress.dart';
import 'defense_card.dart';
import 'enemy.dart';
import 'grid_cell.dart';
import 'heart_level.dart';

enum BattleStatus {
  ready,
  selecting,
  resolving,
  victory,
  defeat,
}

class GameState extends ChangeNotifier {
  int _vitality;
  final int maxVitality;
  int _resilienceSeeds;
  int _pressure;
  HeartLevel _currentLevel;
  final CampaignProgress _campaignProgress;
  BattleStatus _status = BattleStatus.ready;
  BattleOutcome? _lastOutcome;

  List<GridCell> _grid;
  Enemy _enemy;
  final List<DefenseCard> _selectedCards = [];

  GameState({
    int initialVitality = 80,
    this.maxVitality = 100,
    int initialResilienceSeeds = 1,
    int initialPressure = 50,
    CampaignProgress? campaignProgress,
    HeartLevel? initialLevel,
  })  : _vitality = initialVitality,
        _resilienceSeeds = initialResilienceSeeds,
        _pressure = initialPressure,
        _campaignProgress = campaignProgress ?? CampaignProgress(),
        _currentLevel = initialLevel ?? HeartCampaign.stage1Levels.first,
        _grid = List.from((initialLevel ?? HeartCampaign.stage1Levels.first).initialGrid),
        _enemy = (initialLevel ?? HeartCampaign.stage1Levels.first).enemy;

  // Getters
  int get vitality => _vitality;
  double get vitalityRatio => (_vitality / maxVitality).clamp(0.0, 1.0);
  int get resilienceSeeds => _resilienceSeeds;
  int get pressure => _pressure;
  double get pressureRatio => (_pressure / 100).clamp(0.0, 1.0);
  HeartLevel get currentLevel => _currentLevel;
  CampaignProgress get campaignProgress => _campaignProgress;
  BattleStatus get status => _status;
  BattleOutcome? get lastOutcome => _lastOutcome;
  List<GridCell> get grid => List.unmodifiable(_grid);
  Enemy get enemy => _enemy;
  List<DefenseCard> get selectedCards => List.unmodifiable(_selectedCards);
  List<Ability> get selectedAbilities =>
      _selectedCards.map((c) => c.ability).toList();

  /// Strictly enforces that exactly 2 cards are required and no 3rd card can be added.
  bool get canSelectMoreCards => _selectedCards.length < 2;
  bool get canDefend => _selectedCards.length == 2;
  bool get isResolving => _status == BattleStatus.resolving;

  void selectLevel(HeartLevel level) {
    _currentLevel = level;
    _grid = List.from(level.initialGrid);
    _enemy = level.enemy;
    _selectedCards.clear();
    _status = BattleStatus.ready;
    _lastOutcome = null;
    notifyListeners();
  }

  void toggleCardSelection(DefenseCard card) {
    if (_selectedCards.any((c) => c.id == card.id)) {
      _selectedCards.removeWhere((c) => c.id == card.id);
      _status = _selectedCards.isEmpty ? BattleStatus.ready : BattleStatus.selecting;
      notifyListeners();
    } else if (canSelectMoreCards) {
      _selectedCards.add(card);
      _status = _selectedCards.length == 2 ? BattleStatus.selecting : BattleStatus.ready;
      notifyListeners();
    }
  }

  void toggleAbilitySelection(Ability ability) {
    toggleCardSelection(DefenseCard.fromAbility(ability));
  }

  void clearSelection() {
    _selectedCards.clear();
    _status = BattleStatus.ready;
    notifyListeners();
  }

  void setResolving(bool resolving) {
    _status = resolving ? BattleStatus.resolving : BattleStatus.selecting;
    notifyListeners();
  }

  /// Applies BattleOutcome to the game state deterministically.
  void applyBattleOutcome(BattleOutcome outcome) {
    _lastOutcome = outcome;
    _vitality = (_vitality + outcome.vitalityChange).clamp(0, maxVitality);
    _pressure = (_pressure + outcome.pressureChange).clamp(0, 100);
    _grid = List.from(outcome.updatedGrid);
    _enemy = outcome.updatedEnemy;
    _status = outcome.isVictory ? BattleStatus.victory : BattleStatus.defeat;

    if (outcome.isVictory) {
      _campaignProgress.completeLevel(_currentLevel.id);
      _resilienceSeeds += _currentLevel.seedReward;
    }

    notifyListeners();
  }

  /// Backward-compatible resolution applier
  void applyDefenseResolution({
    required int vitalityChange,
    required List<GridCell> updatedGrid,
    required Enemy updatedEnemy,
    bool isVictory = true,
  }) {
    _vitality = (_vitality + vitalityChange).clamp(0, maxVitality);
    _grid = List.from(updatedGrid);
    _enemy = updatedEnemy;
    _status = isVictory ? BattleStatus.victory : BattleStatus.defeat;

    if (isVictory) {
      _campaignProgress.completeLevel(_currentLevel.id);
      _resilienceSeeds += _currentLevel.seedReward;
    }

    notifyListeners();
  }

  void resetBattleState() {
    _grid = List.from(_currentLevel.initialGrid);
    _enemy = _currentLevel.enemy;
    _selectedCards.clear();
    _status = BattleStatus.ready;
    _lastOutcome = null;
    _vitality = 80;
    _pressure = 50;
    notifyListeners();
  }
}

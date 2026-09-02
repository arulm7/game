import 'package:flutter/foundation.dart';
import '../game/game_logic.dart';
import '../game/heart_campaign.dart';
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
  BattleStatus _battleStatus;
  BattleOutcome? _lastOutcome;
  bool _isLastVictoryFirstCompletion = false;

  List<GridCell> _grid;
  Enemy _enemy;
  final List<DefenseCard> _selectedCards = [];

  GameState({
    int initialVitality = 80,
    this.maxVitality = 100,
    int initialResilienceSeeds = 1,
    int initialPressure = 100,
    CampaignProgress? campaignProgress,
    HeartLevel? initialLevel,
    BattleStatus initialBattleStatus = BattleStatus.ready,
  })  : _vitality = initialVitality,
        _resilienceSeeds = initialResilienceSeeds,
        _pressure = initialPressure,
        _campaignProgress = campaignProgress ?? CampaignProgress(),
        _currentLevel = initialLevel ?? HeartCampaign.stage1Levels.first,
        _grid = List.from((initialLevel ?? HeartCampaign.stage1Levels.first).initialGrid),
        _enemy = (initialLevel ?? HeartCampaign.stage1Levels.first).enemy,
        _battleStatus = initialBattleStatus;

  // Getters
  int get vitality => _vitality;
  double get vitalityRatio => (_vitality / maxVitality).clamp(0.0, 1.0);
  int get resilienceSeeds => _resilienceSeeds;
  int get pressure => _pressure;
  HeartLevel get currentLevel => _currentLevel;
  CampaignProgress get campaignProgress => _campaignProgress;
  BattleStatus get battleStatus => _battleStatus;
  BattleOutcome? get lastOutcome => _lastOutcome;
  bool get isLastVictoryFirstCompletion => _isLastVictoryFirstCompletion;
  List<GridCell> get grid => List.unmodifiable(_grid);
  Enemy get enemy => _enemy;
  List<DefenseCard> get selectedCards => List.unmodifiable(_selectedCards);
  bool get canSelectMoreCards => _selectedCards.length < 2;
  bool get canDefend => _selectedCards.length == 2;
  bool get isResolving => _battleStatus == BattleStatus.resolving;

  void selectLevel(HeartLevel level) {
    _currentLevel = level;
    _grid = List.from(level.initialGrid);
    _enemy = level.enemy;
    _selectedCards.clear();
    _battleStatus = BattleStatus.ready;
    _lastOutcome = null;
    _isLastVictoryFirstCompletion = false;
    notifyListeners();
  }

  /// Toggles selection of a defense card.
  /// Enforces strictly: max 2 cards. Attempting a 3rd selection is rejected.
  bool toggleCardSelection(DefenseCard card) {
    if (_selectedCards.any((c) => c.id == card.id)) {
      _selectedCards.removeWhere((c) => c.id == card.id);
      _battleStatus = _selectedCards.isEmpty ? BattleStatus.ready : BattleStatus.selecting;
      notifyListeners();
      return true;
    } else if (canSelectMoreCards) {
      _selectedCards.add(card);
      _battleStatus = BattleStatus.selecting;
      notifyListeners();
      return true;
    }
    // Rejected third selection
    return false;
  }

  void clearSelection() {
    _selectedCards.clear();
    _battleStatus = BattleStatus.ready;
    notifyListeners();
  }

  void setBattleStatus(BattleStatus status) {
    _battleStatus = status;
    notifyListeners();
  }

  void applyResolution(DefenseResolution resolution) {
    _lastOutcome = resolution.outcome;

    if (resolution.vitalityRestored > 0) {
      _vitality = (_vitality + resolution.vitalityRestored).clamp(0, maxVitality);
    }
    if (resolution.netDamageToHeart > 0) {
      _vitality = (_vitality - resolution.netDamageToHeart).clamp(0, maxVitality);
    }

    _pressure = (_pressure + resolution.pressureChange).clamp(40, 200);
    _grid = List.from(resolution.updatedGrid);
    _enemy = resolution.updatedEnemy;

    if (resolution.isVictory) {
      _battleStatus = BattleStatus.victory;
      _isLastVictoryFirstCompletion = _campaignProgress.completeLevel(_currentLevel.id);
      if (_isLastVictoryFirstCompletion) {
        _resilienceSeeds += _currentLevel.seedReward;
      }
    } else {
      _battleStatus = BattleStatus.defeat;
      _isLastVictoryFirstCompletion = false;
    }

    notifyListeners();
  }

  /// Backward-compatible method
  void applyDefenseResolution({
    required int vitalityChange,
    required List<GridCell> updatedGrid,
    required Enemy updatedEnemy,
    bool isVictory = true,
  }) {
    if (vitalityChange > 0) {
      _vitality = (_vitality + vitalityChange).clamp(0, maxVitality);
    } else if (vitalityChange < 0) {
      _vitality = (_vitality + vitalityChange).clamp(0, maxVitality);
    }

    _grid = List.from(updatedGrid);
    _enemy = updatedEnemy;

    if (isVictory) {
      _battleStatus = BattleStatus.victory;
      _isLastVictoryFirstCompletion = _campaignProgress.completeLevel(_currentLevel.id);
      if (_isLastVictoryFirstCompletion) {
        _resilienceSeeds += _currentLevel.seedReward;
      }
    } else {
      _battleStatus = BattleStatus.defeat;
      _isLastVictoryFirstCompletion = false;
    }

    notifyListeners();
  }

  void resetBattleState() {
    _grid = List.from(_currentLevel.initialGrid);
    _enemy = _currentLevel.enemy;
    _selectedCards.clear();
    _vitality = 80;
    _pressure = 100;
    _battleStatus = BattleStatus.ready;
    _lastOutcome = null;
    _isLastVictoryFirstCompletion = false;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'defense_card.dart';
import 'enemy.dart';
import 'grid_cell.dart';

enum PuzzleOutcome {
  none,
  success,
  partialSuccess,
  failure,
}

class GameState extends ChangeNotifier {
  int _heartVitality = 80;
  final int _maxHeartVitality = 100;
  final int _energy = 5;
  int _resilienceSeeds = 0;
  Enemy _currentEnemy = Enemy.plaqueCreep;
  final List<DefenseCard> _availableCards = DefenseCard.initialCards;
  final List<DefenseCard> _selectedCards = [];
  List<GridCell> _grid = GridCell.initialBreachGrid;
  PuzzleOutcome _puzzleResult = PuzzleOutcome.none;
  String _resultMessage = '';
  bool _isResolving = false;
  int _consecutiveVictories = 0;

  // Getters
  int get heartVitality => _heartVitality;
  int get maxHeartVitality => _maxHeartVitality;
  double get vitalityRatio => (_heartVitality / _maxHeartVitality).clamp(0.0, 1.0);
  int get energy => _energy;
  int get resilienceSeeds => _resilienceSeeds;
  Enemy get currentEnemy => _currentEnemy;
  List<DefenseCard> get availableCards => _availableCards;
  List<DefenseCard> get selectedCards => List.unmodifiable(_selectedCards);
  List<GridCell> get grid => _grid;
  PuzzleOutcome get puzzleResult => _puzzleResult;
  String get resultMessage => _resultMessage;
  bool get isResolving => _isResolving;
  int get consecutiveVictories => _consecutiveVictories;

  bool get canDefend => _selectedCards.length == 2 && !_isResolving;

  bool isCardSelected(DefenseCard card) {
    return _selectedCards.any((c) => c.id == card.id);
  }

  void toggleCardSelection(DefenseCard card) {
    if (_isResolving) return;

    if (isCardSelected(card)) {
      _selectedCards.removeWhere((c) => c.id == card.id);
      notifyListeners();
    } else {
      if (_selectedCards.length < 2) {
        _selectedCards.add(card);
        notifyListeners();
      }
    }
  }

  void clearSelection() {
    _selectedCards.clear();
    notifyListeners();
  }

  void setResolving(bool resolving) {
    _isResolving = resolving;
    notifyListeners();
  }

  void updateAfterDefense({
    required int newVitality,
    required Enemy updatedEnemy,
    required List<GridCell> updatedGrid,
    required PuzzleOutcome outcome,
    required String message,
    required bool awardedSeed,
  }) {
    _heartVitality = newVitality.clamp(0, _maxHeartVitality);
    _currentEnemy = updatedEnemy;
    _grid = updatedGrid;
    _puzzleResult = outcome;
    _resultMessage = message;
    if (awardedSeed) {
      _resilienceSeeds += 1;
      _consecutiveVictories += 1;
    }
    _isResolving = false;
    notifyListeners();
  }

  void resetPuzzle() {
    _selectedCards.clear();
    _grid = GridCell.initialBreachGrid;
    _puzzleResult = PuzzleOutcome.none;
    _resultMessage = '';
    _isResolving = false;
    _currentEnemy = Enemy.plaqueCreep;
    notifyListeners();
  }
}

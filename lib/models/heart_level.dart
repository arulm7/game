import 'defense_card.dart';
import 'enemy.dart';
import 'grid_cell.dart';

class BioFact {
  final String whatHappened;
  final String gameLesson;
  final String realWorldConnection;

  const BioFact({
    required this.whatHappened,
    required this.gameLesson,
    required this.realWorldConnection,
  });
}

class HeartLevel {
  final String id; // e.g. '1-1', '1-2', '1-3', '1-4'
  final int stageNumber;
  final int levelNumber;
  final String title;
  final String subtitle;
  final String scenario;
  final Enemy enemy;
  final List<GridCell> initialGrid;
  final List<DefenseCardType> availableCardTypes;
  final List<DefenseCardType> recommendedSynergy;
  final String recommendedHint;
  final BioFact bioFact;
  final bool isBoss;
  final int seedReward;
  final String iconEmoji;

  const HeartLevel({
    required this.id,
    required this.stageNumber,
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.scenario,
    required this.enemy,
    required this.initialGrid,
    required this.availableCardTypes,
    required this.recommendedSynergy,
    required this.recommendedHint,
    required this.bioFact,
    this.isBoss = false,
    this.seedReward = 1,
    this.iconEmoji = '🌱',
  });

  List<DefenseCard> get availableCards =>
      DefenseCard.getCardsForTypes(availableCardTypes);
}

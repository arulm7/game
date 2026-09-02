import '../models/ability.dart';
import '../models/battle_outcome.dart';
import '../models/defense_card.dart';
import '../models/enemy.dart';
import '../models/grid_cell.dart';
import '../models/heart_level.dart';
import 'ability_resolver.dart';

class DefenseResolution {
  final BattleOutcome outcome;
  final int totalDefensePower;
  final int netDamageToHeart;
  final int vitalityRestored;
  final int enemyDamageTaken;
  final bool isVictory;
  final String synergyName;
  final String outcomeDescription;
  final List<GridCell> updatedGrid;
  final Enemy updatedEnemy;
  final int pressureChange;

  const DefenseResolution({
    required this.outcome,
    required this.totalDefensePower,
    required this.netDamageToHeart,
    required this.vitalityRestored,
    required this.enemyDamageTaken,
    required this.isVictory,
    required this.synergyName,
    required this.outcomeDescription,
    required this.updatedGrid,
    required this.updatedEnemy,
    required this.pressureChange,
  });

  BattleOutcomeGrade get grade => outcome.grade;
}

class GameLogic {
  /// Validates that exactly 2 abilities/cards are selected.
  static bool validateSelection(List<DefenseCard> selectedCards) {
    return selectedCards.length == 2;
  }

  /// Authoritative battle resolution method using [AbilityResolver].
  static DefenseResolution resolveBattle({
    required HeartLevel level,
    required List<DefenseCard> selectedCards,
    required List<GridCell> currentGrid,
    int currentVitality = 80,
    int maxVitality = 100,
    int currentPressure = 100,
  }) {
    if (!validateSelection(selectedCards)) {
      throw ArgumentError('Exactly 2 cards must be selected to resolve battle.');
    }

    final abilities = selectedCards.map((c) => c.ability).toList();
    final outcome = AbilityResolver.resolve(
      level: level,
      selectedAbilities: abilities,
    );

    final enemy = level.enemy;
    final int enemyDmg = outcome.threatDamage;
    final updatedEnemy = enemy.copyWith(
      currentHealth: (enemy.currentHealth - enemyDmg).clamp(0, enemy.maxHealth),
    );

    final isVictory = outcome.isSuccess;

    // Update arterial grid cells: resolve blocked and critical nodes on success
    final updatedGrid = currentGrid.map((cell) {
      if (isVictory) {
        if (cell.status == CellStatus.blocked || cell.status == CellStatus.critical) {
          return cell.copyWith(status: CellStatus.cleared);
        }
      }
      return cell;
    }).toList();

    int baseDefense = 0;
    for (final card in selectedCards) {
      baseDefense += card.defensePower;
    }

    return DefenseResolution(
      outcome: outcome,
      totalDefensePower: baseDefense + (outcome.isSuccess ? 40 : 0),
      netDamageToHeart: outcome.playerDamage,
      vitalityRestored: outcome.vitalityRestored,
      enemyDamageTaken: outcome.threatDamage,
      isVictory: isVictory,
      synergyName: outcome.synergyName,
      outcomeDescription: outcome.message,
      updatedGrid: updatedGrid,
      updatedEnemy: updatedEnemy,
      pressureChange: outcome.pressureChange,
    );
  }

  /// Backward-compatible bridge for existing callers.
  static DefenseResolution resolveDefense({
    required List<DefenseCard> selectedCards,
    required Enemy enemy,
    required List<GridCell> currentGrid,
    int currentVitality = 80,
    int maxVitality = 100,
  }) {
    // Construct or infer level context
    final level = _inferLevelForEnemy(enemy, selectedCards);
    return resolveBattle(
      level: level,
      selectedCards: selectedCards,
      currentGrid: currentGrid,
      currentVitality: currentVitality,
      maxVitality: maxVitality,
    );
  }

  static HeartLevel _inferLevelForEnemy(Enemy enemy, List<DefenseCard> cards) {
    // Map by enemy type
    switch (enemy.type) {
      case EnemyType.stressParasites:
        return HeartLevel(
          id: '1-1',
          stageNumber: 1,
          levelNumber: 1,
          title: 'THE MORNING RUSH',
          subtitle: 'Stage 1-1',
          scenario: 'Stress Parasites invasion.',
          enemy: enemy,
          initialGrid: const [],
          availableCardTypes: const [
            AbilityId.forgivenessMeditation,
            AbilityId.isotonicFlow,
            AbilityId.relaxation,
            AbilityId.isometricHold,
          ],
          recommendedSynergy: const [
            AbilityId.forgivenessMeditation,
            AbilityId.relaxation,
          ],
          recommendedHint: '',
          bioFact: const BioFact(
            whatHappened: '',
            gameLesson: '',
            realWorldConnection: '',
          ),
        );
      case EnemyType.sodiumSpikes:
        return HeartLevel(
          id: '1-2',
          stageNumber: 1,
          levelNumber: 2,
          title: 'THE FAST-FOOD PITSTOP',
          subtitle: 'Stage 1-2',
          scenario: 'Sodium Spikes invasion.',
          enemy: enemy,
          initialGrid: const [],
          availableCardTypes: const [
            AbilityId.potassiumRainbow,
            AbilityId.beetrootFlush,
            AbilityId.isotonicFlow,
            AbilityId.isometricHold,
          ],
          recommendedSynergy: const [
            AbilityId.potassiumRainbow,
            AbilityId.beetrootFlush,
          ],
          recommendedHint: '',
          bioFact: const BioFact(
            whatHappened: '',
            gameLesson: '',
            realWorldConnection: '',
          ),
        );
      case EnemyType.stressAndSodium:
        return HeartLevel(
          id: '1-3',
          stageNumber: 1,
          levelNumber: 3,
          title: 'THE ALL-NIGHTER',
          subtitle: 'Stage 1-3',
          scenario: 'Dual invasion.',
          enemy: enemy,
          initialGrid: const [],
          availableCardTypes: const [
            AbilityId.deepSleepShield,
            AbilityId.isotonicFlow,
            AbilityId.relaxation,
            AbilityId.potassiumRainbow,
          ],
          recommendedSynergy: const [
            AbilityId.deepSleepShield,
            AbilityId.isotonicFlow,
          ],
          recommendedHint: '',
          bioFact: const BioFact(
            whatHappened: '',
            gameLesson: '',
            realWorldConnection: '',
          ),
        );
      case EnemyType.hypertensionHijacker:
        return HeartLevel(
          id: '1-4',
          stageNumber: 1,
          levelNumber: 4,
          title: 'HYPERTENSION HIJACKER',
          subtitle: 'Stage 1 Boss',
          scenario: 'Boss encounter.',
          enemy: enemy,
          initialGrid: const [],
          availableCardTypes: const [
            AbilityId.goodLaughBlast,
            AbilityId.beetrootFlush,
            AbilityId.isotonicFlow,
            AbilityId.relaxation,
            AbilityId.isometricHold,
          ],
          recommendedSynergy: const [
            AbilityId.goodLaughBlast,
            AbilityId.beetrootFlush,
          ],
          recommendedHint: '',
          bioFact: const BioFact(
            whatHappened: '',
            gameLesson: '',
            realWorldConnection: '',
          ),
          isBoss: true,
        );
      case EnemyType.plaqueCreep:
        return HeartLevel(
          id: '1-1',
          stageNumber: 1,
          levelNumber: 1,
          title: 'PLAQUE BREACH',
          subtitle: 'Stage 1 Prototype',
          scenario: 'Plaque Creep invasion.',
          enemy: enemy,
          initialGrid: const [],
          availableCardTypes: const [
            AbilityId.isotonicFlow,
            AbilityId.beetrootFlush,
            AbilityId.potassiumRainbow,
            AbilityId.relaxation,
            AbilityId.isometricHold,
          ],
          recommendedSynergy: const [
            AbilityId.isotonicFlow,
            AbilityId.beetrootFlush,
          ],
          recommendedHint: '',
          bioFact: const BioFact(
            whatHappened: '',
            gameLesson: '',
            realWorldConnection: '',
          ),
        );
    }
  }
}

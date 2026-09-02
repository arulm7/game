import 'package:flutter_test/flutter_test.dart';
import 'package:saviours_vs_saboteurs/game/ability_resolver.dart';
import 'package:saviours_vs_saboteurs/game/game_logic.dart';
import 'package:saviours_vs_saboteurs/game/heart_campaign.dart';
import 'package:saviours_vs_saboteurs/models/ability.dart';
import 'package:saviours_vs_saboteurs/models/battle_outcome.dart';
import 'package:saviours_vs_saboteurs/models/campaign_progress.dart';
import 'package:saviours_vs_saboteurs/models/defense_card.dart';
import 'package:saviours_vs_saboteurs/models/enemy.dart';
import 'package:saviours_vs_saboteurs/models/game_state.dart';
import 'package:saviours_vs_saboteurs/models/heart_level.dart';

void main() {
  group('Level 1-1 (The Morning Rush) Complete Specification Tests', () {
    late HeartLevel level1_1;

    setUp(() {
      level1_1 = HeartCampaign.getLevelById('1-1');
    });

    test('1. Level 1-1 loads correctly with correct metadata', () {
      expect(level1_1.id, '1-1');
      expect(level1_1.title, 'THE MORNING RUSH');
      expect(level1_1.stageNumber, 1);
      expect(level1_1.levelNumber, 1);
      expect(level1_1.isBoss, isFalse);
      expect(level1_1.seedReward, 1);
    });

    test('2, 3 & 4. Threat is Stress Parasites with HP 50 and Base Damage 20', () {
      final enemy = level1_1.enemy;
      expect(enemy.type, EnemyType.stressParasites);
      expect(enemy.name.toUpperCase(), 'STRESS PARASITES');
      expect(enemy.maxHealth, 50);
      expect(enemy.currentHealth, 50);
      expect(enemy.baseDamage, 20);
    });

    test('5, 6, 7, 8 & 9. Exactly four curated abilities appear in 1-1', () {
      expect(level1_1.availableCardTypes.length, 4);
      expect(level1_1.availableCards.length, 4);

      final cardTypes = level1_1.availableCardTypes;
      expect(cardTypes, contains(AbilityId.forgivenessMeditation));
      expect(cardTypes, contains(AbilityId.relaxation));
      expect(cardTypes, contains(AbilityId.isotonicFlow));
      expect(cardTypes, contains(AbilityId.isometricHold));
    });

    test('10. Zero cards selected: cannot defend', () {
      final gameState = GameState(initialLevel: level1_1);
      expect(gameState.selectedCards.isEmpty, isTrue);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);
    });

    test('11. One card selected: cannot defend', () {
      final gameState = GameState(initialLevel: level1_1);
      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);

      gameState.toggleCardSelection(card1);
      expect(gameState.selectedCards.length, 1);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);
    });

    test('12. Exactly two cards selected: can defend', () {
      final gameState = GameState(initialLevel: level1_1);
      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      final card2 = DefenseCard.fromAbilityId(AbilityId.relaxation);

      gameState.toggleCardSelection(card1);
      gameState.toggleCardSelection(card2);

      expect(gameState.selectedCards.length, 2);
      expect(gameState.canDefend, isTrue);
      expect(GameLogic.validateSelection(gameState.selectedCards), isTrue);
    });

    test('13. Third selection attempt is rejected and preserves existing two', () {
      final gameState = GameState(initialLevel: level1_1);
      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      final card2 = DefenseCard.fromAbilityId(AbilityId.relaxation);
      final card3 = DefenseCard.fromAbilityId(AbilityId.isotonicFlow);

      expect(gameState.toggleCardSelection(card1), isTrue);
      expect(gameState.toggleCardSelection(card2), isTrue);
      expect(gameState.selectedCards.length, 2);

      // 3rd attempt rejected
      expect(gameState.toggleCardSelection(card3), isFalse);
      expect(gameState.selectedCards.length, 2);
      expect(
        gameState.selectedCards.map((c) => c.type).toSet(),
        containsAll([AbilityId.forgivenessMeditation, AbilityId.relaxation]),
      );
    });

    test('14. Forgiveness Meditation + Relaxation -> EXCELLENT', () {
      final a1 = Ability.get(AbilityId.forgivenessMeditation);
      final a2 = Ability.get(AbilityId.relaxation);

      final outcome = AbilityResolver.resolve(
        level: level1_1,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, 0);
      expect(outcome.threatDamage, greaterThanOrEqualTo(50));
      expect(outcome.pressureChange, lessThan(0));
      expect(outcome.synergyDetected, isTrue);
      expect(outcome.synergyName, 'SERENE PARASYMPATHETIC CALM');
    });

    test('15. Reverse order: Relaxation + Forgiveness Meditation -> EXCELLENT', () {
      final a1 = Ability.get(AbilityId.relaxation);
      final a2 = Ability.get(AbilityId.forgivenessMeditation);

      final outcome = AbilityResolver.resolve(
        level: level1_1,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.synergyName, 'SERENE PARASYMPATHETIC CALM');
    });

    test('16. Useful non-optimal combination -> GOOD', () {
      final a1 = Ability.get(AbilityId.forgivenessMeditation);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(
        level: level1_1,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.good);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, lessThan(level1_1.enemy.baseDamage));
      expect(outcome.pressureChange, lessThanOrEqualTo(0));
    });

    test('17. Weak combination -> POOR', () {
      final a1 = Ability.get(AbilityId.isometricHold);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(
        level: level1_1,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.poor);
      expect(outcome.isSuccess, isFalse);
      expect(outcome.playerDamage, greaterThan(0));
      expect(outcome.pressureChange, greaterThan(0));
    });

    test('18. Applying resolution updates GameState correctly', () {
      final gameState = GameState(initialLevel: level1_1, initialVitality: 80, initialPressure: 100);
      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      final card2 = DefenseCard.fromAbilityId(AbilityId.relaxation);

      final resolution = GameLogic.resolveBattle(
        level: level1_1,
        selectedCards: [card1, card2],
        currentGrid: level1_1.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(resolution);

      expect(gameState.vitality, greaterThan(80));
      expect(gameState.pressure, lessThan(100));
      expect(gameState.enemy.currentHealth, 0);
      expect(gameState.battleStatus, BattleStatus.victory);
      expect(gameState.lastOutcome?.grade, BattleOutcomeGrade.excellent);
    });

    test('19, 20, 21 & 22. Successful 1-1 marks completed, unlocks 1-2, keeps 1-3 and 1-4 locked', () {
      final progress = CampaignProgress();
      expect(progress.isLevelUnlocked('1-1'), isTrue);
      expect(progress.isLevelUnlocked('1-2'), isFalse);
      expect(progress.isLevelUnlocked('1-3'), isFalse);
      expect(progress.isLevelUnlocked('1-4'), isFalse);

      progress.completeLevel('1-1');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelUnlocked('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isFalse);
      expect(progress.isLevelUnlocked('1-4'), isFalse);
    });

    test('23. Replay of 1-1 does not reset progression', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isTrue);

      // Replaying 1-1
      progress.completeLevel('1-1');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isFalse);
    });
  });
}

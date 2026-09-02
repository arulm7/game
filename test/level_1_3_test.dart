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
  group('Level 1-3 (The All-Nighter) Specification Tests', () {
    late HeartLevel level1_3;

    setUp(() {
      level1_3 = HeartCampaign.getLevelById('1-3');
    });

    test('1 & 2. Level 1-3 exists and title is THE ALL-NIGHTER', () {
      expect(level1_3.id, '1-3');
      expect(level1_3.title, 'THE ALL-NIGHTER');
      expect(level1_3.stageNumber, 1);
      expect(level1_3.levelNumber, 3);
      expect(level1_3.isBoss, isFalse);
      expect(level1_3.seedReward, 1);
    });

    test('3, 4 & 5. Threat is combined Stress & Sodium with HP 80 and Base Damage 30', () {
      final enemy = level1_3.enemy;
      expect(enemy.type, EnemyType.stressAndSodium);
      expect(enemy.name, contains('STRESS'));
      expect(enemy.name, contains('SODIUM'));
      expect(enemy.maxHealth, 80);
      expect(enemy.currentHealth, 80);
      expect(enemy.baseDamage, 30);
    });

    test('6, 7, 8, 9 & 10. Exactly four curated abilities available in 1-3', () {
      expect(level1_3.availableCardTypes.length, 4);
      expect(level1_3.availableCards.length, 4);

      final cardTypes = level1_3.availableCardTypes;
      expect(cardTypes, contains(AbilityId.deepSleepShield));
      expect(cardTypes, contains(AbilityId.isotonicFlow));
      expect(cardTypes, contains(AbilityId.relaxation));
      expect(cardTypes, contains(AbilityId.potassiumRainbow));
    });

    test('11. Zero cards selected: cannot defend', () {
      final gameState = GameState(initialLevel: level1_3);
      expect(gameState.selectedCards.isEmpty, isTrue);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);
    });

    test('12. One card selected: cannot defend', () {
      final gameState = GameState(initialLevel: level1_3);
      final card1 = DefenseCard.fromAbilityId(AbilityId.deepSleepShield);

      gameState.toggleCardSelection(card1);
      expect(gameState.selectedCards.length, 1);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);
    });

    test('13. Exactly two cards selected: can defend', () {
      final gameState = GameState(initialLevel: level1_3);
      final card1 = DefenseCard.fromAbilityId(AbilityId.deepSleepShield);
      final card2 = DefenseCard.fromAbilityId(AbilityId.isotonicFlow);

      gameState.toggleCardSelection(card1);
      gameState.toggleCardSelection(card2);

      expect(gameState.selectedCards.length, 2);
      expect(gameState.canDefend, isTrue);
      expect(GameLogic.validateSelection(gameState.selectedCards), isTrue);
    });

    test('14. Third selection is rejected and preserves existing two', () {
      final gameState = GameState(initialLevel: level1_3);
      final card1 = DefenseCard.fromAbilityId(AbilityId.deepSleepShield);
      final card2 = DefenseCard.fromAbilityId(AbilityId.isotonicFlow);
      final card3 = DefenseCard.fromAbilityId(AbilityId.relaxation);

      expect(gameState.toggleCardSelection(card1), isTrue);
      expect(gameState.toggleCardSelection(card2), isTrue);
      expect(gameState.selectedCards.length, 2);

      // 3rd selection rejected
      expect(gameState.toggleCardSelection(card3), isFalse);
      expect(gameState.selectedCards.length, 2);
      expect(
        gameState.selectedCards.map((c) => c.type).toSet(),
        containsAll([AbilityId.deepSleepShield, AbilityId.isotonicFlow]),
      );
    });

    test('15. Deep Sleep Shield + Isotonic Flow -> EXCELLENT', () {
      final a1 = Ability.get(AbilityId.deepSleepShield);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(
        level: level1_3,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, 0);
      expect(outcome.threatDamage, greaterThanOrEqualTo(80));
      expect(outcome.pressureChange, lessThan(0));
      expect(outcome.synergyDetected, isTrue);
      expect(outcome.synergyName, 'CIRCADIAN RESTORATIVE FLOW');
    });

    test('16. Reverse order: Isotonic Flow + Deep Sleep Shield -> EXCELLENT', () {
      final a1 = Ability.get(AbilityId.isotonicFlow);
      final a2 = Ability.get(AbilityId.deepSleepShield);

      final outcome = AbilityResolver.resolve(
        level: level1_3,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.synergyName, 'CIRCADIAN RESTORATIVE FLOW');
    });

    test('17. Useful non-optimal combinations -> GOOD', () {
      final a1 = Ability.get(AbilityId.deepSleepShield);
      final a2 = Ability.get(AbilityId.relaxation);

      final outcome1 = AbilityResolver.resolve(
        level: level1_3,
        selectedAbilities: [a1, a2],
      );

      expect(outcome1.grade, BattleOutcomeGrade.good);
      expect(outcome1.isSuccess, isTrue);
      expect(outcome1.threatDamage, greaterThan(0));
      expect(outcome1.pressureChange, lessThanOrEqualTo(0));

      final a3 = Ability.get(AbilityId.potassiumRainbow);
      final a4 = Ability.get(AbilityId.isotonicFlow);

      final outcome2 = AbilityResolver.resolve(
        level: level1_3,
        selectedAbilities: [a3, a4],
      );

      expect(outcome2.grade, BattleOutcomeGrade.good);
      expect(outcome2.isSuccess, isTrue);
    });

    test('18. Weak combination -> POOR', () {
      final a1 = Ability.get(AbilityId.relaxation);
      final a2 = Ability.get(AbilityId.potassiumRainbow);

      final outcome = AbilityResolver.resolve(
        level: level1_3,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.poor);
      expect(outcome.isSuccess, isFalse);
      expect(outcome.playerDamage, greaterThan(0));
      expect(outcome.pressureChange, greaterThan(0));
    });

    test('19, 20 & 21. BattleOutcome application correctly updates GameState, Threat HP, and Pressure', () {
      final gameState = GameState(initialLevel: level1_3, initialVitality: 80, initialPressure: 100);
      final card1 = DefenseCard.fromAbilityId(AbilityId.deepSleepShield);
      final card2 = DefenseCard.fromAbilityId(AbilityId.isotonicFlow);

      final resolution = GameLogic.resolveBattle(
        level: level1_3,
        selectedCards: [card1, card2],
        currentGrid: level1_3.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(resolution);

      expect(gameState.vitality, greaterThan(80));
      expect(gameState.pressure, lessThan(100));
      expect(gameState.enemy.currentHealth, 0);
      expect(gameState.battleStatus, BattleStatus.victory);
      expect(gameState.lastOutcome?.grade, BattleOutcomeGrade.excellent);
      expect(gameState.isLastVictoryFirstCompletion, isTrue);
    });

    test('22, 23 & 24. First successful 1-3 completion marks completed, unlocks 1-4, and awards seed reward', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelCompleted('1-3'), isFalse);
      expect(progress.isLevelUnlocked('1-4'), isFalse);

      final isFirst = progress.completeLevel('1-3');
      expect(isFirst, isTrue);
      expect(progress.isLevelCompleted('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isTrue);
    });

    test('25 & 26. Replaying 1-3 does not duplicate seed reward and preserves 1-4 unlocked', () {
      final gameState = GameState(initialResilienceSeeds: 3);
      final progress = gameState.campaignProgress;
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');

      gameState.selectLevel(level1_3);

      final card1 = DefenseCard.fromAbilityId(AbilityId.deepSleepShield);
      final card2 = DefenseCard.fromAbilityId(AbilityId.isotonicFlow);

      // First victory on 1-3
      final res1 = GameLogic.resolveBattle(
        level: level1_3,
        selectedCards: [card1, card2],
        currentGrid: level1_3.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(res1);
      final seedsAfter1_3 = gameState.resilienceSeeds;
      expect(seedsAfter1_3, 4); // 3 + 1
      expect(progress.isLevelCompleted('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isTrue);

      // Replay 1-3
      gameState.resetBattleState();
      final res2 = GameLogic.resolveBattle(
        level: level1_3,
        selectedCards: [card1, card2],
        currentGrid: level1_3.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(res2);
      expect(gameState.resilienceSeeds, seedsAfter1_3); // No duplicate seed
      expect(gameState.isLastVictoryFirstCompletion, isFalse);
      expect(progress.isLevelCompleted('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isTrue);
    });
  });
}

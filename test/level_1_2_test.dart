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
  group('Part A — Replay Seed Reward Fix Regression Tests', () {
    test('A1. CampaignProgress.completeLevel() returns true on first completion and false on replay', () {
      final progress = CampaignProgress();
      expect(progress.isLevelCompleted('1-1'), isFalse);

      final firstCall = progress.completeLevel('1-1');
      expect(firstCall, isTrue);
      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelUnlocked('1-2'), isTrue);

      final secondCall = progress.completeLevel('1-1');
      expect(secondCall, isFalse);
      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelUnlocked('1-2'), isTrue);
    });

    test('A2. Replaying completed Level 1-1 does not duplicate seed reward or reset progression', () {
      final gameState = GameState(initialResilienceSeeds: 1);
      final l1 = HeartCampaign.getLevelById('1-1');
      gameState.selectLevel(l1);

      // 1. Start with 1-1 incomplete
      expect(gameState.campaignProgress.isLevelCompleted('1-1'), isFalse);
      expect(gameState.campaignProgress.isLevelUnlocked('1-2'), isFalse);
      expect(gameState.resilienceSeeds, 1);

      // 2. Complete 1-1 successfully
      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      final card2 = DefenseCard.fromAbilityId(AbilityId.relaxation);

      final res1 = GameLogic.resolveBattle(
        level: l1,
        selectedCards: [card1, card2],
        currentGrid: l1.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(res1);

      // 3. Record seed count
      final seedsAfterFirstClear = gameState.resilienceSeeds;
      expect(seedsAfterFirstClear, 2); // 1 initial + 1 seedReward

      // 4 & 5. Confirm 1-1 is completed and 1-2 is unlocked
      expect(gameState.campaignProgress.isLevelCompleted('1-1'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-2'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-3'), isFalse);
      expect(gameState.campaignProgress.isLevelUnlocked('1-4'), isFalse);

      // 6 & 7. Replay 1-1 and complete again
      gameState.resetBattleState();
      final res2 = GameLogic.resolveBattle(
        level: l1,
        selectedCards: [card1, card2],
        currentGrid: l1.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(res2);

      // 8. Confirm seed count has NOT increased from the previous value
      expect(gameState.resilienceSeeds, seedsAfterFirstClear);

      // 9, 10 & 11. Confirm progression unchanged
      expect(gameState.campaignProgress.isLevelCompleted('1-1'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-2'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-3'), isFalse);
      expect(gameState.campaignProgress.isLevelUnlocked('1-4'), isFalse);
    });

    test('A2. Replaying completed Level 1-2 does not duplicate seed reward', () {
      final gameState = GameState(initialResilienceSeeds: 2);
      final l2 = HeartCampaign.getLevelById('1-2');
      gameState.selectLevel(l2);

      // Complete 1-2 first time
      final card1 = DefenseCard.fromAbilityId(AbilityId.potassiumRainbow);
      final card2 = DefenseCard.fromAbilityId(AbilityId.beetrootFlush);

      final res1 = GameLogic.resolveBattle(
        level: l2,
        selectedCards: [card1, card2],
        currentGrid: l2.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(res1);
      final seedsAfter1_2 = gameState.resilienceSeeds;
      expect(seedsAfter1_2, 3); // 2 + 1
      expect(gameState.campaignProgress.isLevelCompleted('1-2'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-3'), isTrue);

      // Replay 1-2
      gameState.resetBattleState();
      final res2 = GameLogic.resolveBattle(
        level: l2,
        selectedCards: [card1, card2],
        currentGrid: l2.initialGrid,
        currentVitality: gameState.vitality,
        currentPressure: gameState.pressure,
      );

      gameState.applyResolution(res2);
      expect(gameState.resilienceSeeds, seedsAfter1_2); // No duplicate reward
      expect(gameState.campaignProgress.isLevelCompleted('1-2'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-3'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-4'), isFalse);
    });
  });

  group('Part B — Level 1-2 (The Fast-Food Pitstop) Specification Tests', () {
    late HeartLevel level1_2;

    setUp(() {
      level1_2 = HeartCampaign.getLevelById('1-2');
    });

    test('1 & 2. Level 1-2 exists and title is THE FAST-FOOD PITSTOP', () {
      expect(level1_2.id, '1-2');
      expect(level1_2.title, 'THE FAST-FOOD PITSTOP');
      expect(level1_2.stageNumber, 1);
      expect(level1_2.levelNumber, 2);
      expect(level1_2.isBoss, isFalse);
      expect(level1_2.seedReward, 1);
    });

    test('3, 4 & 5. Threat is Sodium Spikes with HP 60 and Base Damage 25', () {
      final enemy = level1_2.enemy;
      expect(enemy.type, EnemyType.sodiumSpikes);
      expect(enemy.name.toUpperCase(), 'SODIUM SPIKES');
      expect(enemy.maxHealth, 60);
      expect(enemy.currentHealth, 60);
      expect(enemy.baseDamage, 25);
    });

    test('6, 7, 8, 9 & 10. Exactly four curated abilities available in 1-2', () {
      expect(level1_2.availableCardTypes.length, 4);
      expect(level1_2.availableCards.length, 4);

      final cardTypes = level1_2.availableCardTypes;
      expect(cardTypes, contains(AbilityId.potassiumRainbow));
      expect(cardTypes, contains(AbilityId.beetrootFlush));
      expect(cardTypes, contains(AbilityId.isotonicFlow));
      expect(cardTypes, contains(AbilityId.isometricHold));
    });

    test('11. Zero selections cannot defend', () {
      final gameState = GameState(initialLevel: level1_2);
      expect(gameState.selectedCards.isEmpty, isTrue);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);
    });

    test('12. One selection cannot defend', () {
      final gameState = GameState(initialLevel: level1_2);
      final card1 = DefenseCard.fromAbilityId(AbilityId.potassiumRainbow);

      gameState.toggleCardSelection(card1);
      expect(gameState.selectedCards.length, 1);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);
    });

    test('13. Exactly two selections can defend', () {
      final gameState = GameState(initialLevel: level1_2);
      final card1 = DefenseCard.fromAbilityId(AbilityId.potassiumRainbow);
      final card2 = DefenseCard.fromAbilityId(AbilityId.beetrootFlush);

      gameState.toggleCardSelection(card1);
      gameState.toggleCardSelection(card2);

      expect(gameState.selectedCards.length, 2);
      expect(gameState.canDefend, isTrue);
      expect(GameLogic.validateSelection(gameState.selectedCards), isTrue);
    });

    test('14. Third selection is rejected and preserves existing two', () {
      final gameState = GameState(initialLevel: level1_2);
      final card1 = DefenseCard.fromAbilityId(AbilityId.potassiumRainbow);
      final card2 = DefenseCard.fromAbilityId(AbilityId.beetrootFlush);
      final card3 = DefenseCard.fromAbilityId(AbilityId.isotonicFlow);

      expect(gameState.toggleCardSelection(card1), isTrue);
      expect(gameState.toggleCardSelection(card2), isTrue);
      expect(gameState.selectedCards.length, 2);

      // 3rd selection rejected
      expect(gameState.toggleCardSelection(card3), isFalse);
      expect(gameState.selectedCards.length, 2);
      expect(
        gameState.selectedCards.map((c) => c.type).toSet(),
        containsAll([AbilityId.potassiumRainbow, AbilityId.beetrootFlush]),
      );
    });

    test('15. Potassium Rainbow + Beetroot Flush -> EXCELLENT', () {
      final a1 = Ability.get(AbilityId.potassiumRainbow);
      final a2 = Ability.get(AbilityId.beetrootFlush);

      final outcome = AbilityResolver.resolve(
        level: level1_2,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, 0);
      expect(outcome.threatDamage, greaterThanOrEqualTo(60));
      expect(outcome.pressureChange, lessThan(0));
      expect(outcome.synergyDetected, isTrue);
      expect(outcome.synergyName, 'ELECTROLYTE NITRIC SURGE');
    });

    test('16. Reverse order: Beetroot Flush + Potassium Rainbow -> EXCELLENT', () {
      final a1 = Ability.get(AbilityId.beetrootFlush);
      final a2 = Ability.get(AbilityId.potassiumRainbow);

      final outcome = AbilityResolver.resolve(
        level: level1_2,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.synergyName, 'ELECTROLYTE NITRIC SURGE');
    });

    test('17. Useful non-optimal combination -> GOOD', () {
      final a1 = Ability.get(AbilityId.potassiumRainbow);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(
        level: level1_2,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.good);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.threatDamage, greaterThan(0));
      expect(outcome.pressureChange, lessThanOrEqualTo(0));
    });

    test('18. Weak combination -> POOR', () {
      final a1 = Ability.get(AbilityId.isometricHold);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(
        level: level1_2,
        selectedAbilities: [a1, a2],
      );

      expect(outcome.grade, BattleOutcomeGrade.poor);
      expect(outcome.isSuccess, isFalse);
      expect(outcome.playerDamage, greaterThan(0));
      expect(outcome.pressureChange, greaterThan(0));
    });

    test('19. Result is applied to GameState', () {
      final gameState = GameState(initialLevel: level1_2, initialVitality: 80, initialPressure: 100);
      final card1 = DefenseCard.fromAbilityId(AbilityId.potassiumRainbow);
      final card2 = DefenseCard.fromAbilityId(AbilityId.beetrootFlush);

      final resolution = GameLogic.resolveBattle(
        level: level1_2,
        selectedCards: [card1, card2],
        currentGrid: level1_2.initialGrid,
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

    test('20, 21 & 22. First successful 1-2 completion marks completed, unlocks 1-3, keeps 1-4 locked', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelUnlocked('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isFalse);

      final isFirst = progress.completeLevel('1-2');
      expect(isFirst, isTrue);
      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isFalse);
    });

    test('23 & 24. Replay 1-2 does not duplicate first-completion seed reward or reset progression', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isTrue);

      // Replaying 1-2
      final isFirst = progress.completeLevel('1-2');
      expect(isFirst, isFalse);
      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isFalse);
    });
  });
}

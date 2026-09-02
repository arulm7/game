import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saviours_vs_saboteurs/game/ability_resolver.dart';
import 'package:saviours_vs_saboteurs/game/game_logic.dart';
import 'package:saviours_vs_saboteurs/game/heart_campaign.dart';
import 'package:saviours_vs_saboteurs/models/ability.dart';
import 'package:saviours_vs_saboteurs/models/battle_outcome.dart';
import 'package:saviours_vs_saboteurs/models/defense_card.dart';
import 'package:saviours_vs_saboteurs/models/game_state.dart';

void main() {
  group('Stage 2.3 Battle Engine Tests', () {
    test('A & B. 0 or 1 card selected is invalid for defending', () {
      final gameState = GameState();
      expect(gameState.selectedCards.isEmpty, isTrue);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);

      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      gameState.toggleCardSelection(card1);

      expect(gameState.selectedCards.length, 1);
      expect(gameState.canDefend, isFalse);
      expect(GameLogic.validateSelection(gameState.selectedCards), isFalse);
    });

    test('C. Exactly 2 cards selected is valid for defending', () {
      final gameState = GameState();
      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      final card2 = DefenseCard.fromAbilityId(AbilityId.relaxation);

      gameState.toggleCardSelection(card1);
      gameState.toggleCardSelection(card2);

      expect(gameState.selectedCards.length, 2);
      expect(gameState.canDefend, isTrue);
      expect(GameLogic.validateSelection(gameState.selectedCards), isTrue);
    });

    test('D. Attempting to select a 3rd card is rejected and keeps existing 2', () {
      final gameState = GameState();
      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      final card2 = DefenseCard.fromAbilityId(AbilityId.relaxation);
      final card3 = DefenseCard.fromAbilityId(AbilityId.isotonicFlow);

      expect(gameState.toggleCardSelection(card1), isTrue);
      expect(gameState.toggleCardSelection(card2), isTrue);
      expect(gameState.selectedCards.length, 2);

      // Attempting 3rd selection returns false and leaves 2 cards
      expect(gameState.toggleCardSelection(card3), isFalse);
      expect(gameState.selectedCards.length, 2);
      expect(gameState.selectedCards.map((c) => c.id).toSet(), containsAll(['forgivenessMeditation', 'relaxation']));
    });

    test('E & O. Selection order independence (A+B equals B+A)', () {
      final l1 = HeartCampaign.getLevelById('1-1');
      final a1 = Ability.get(AbilityId.forgivenessMeditation);
      final a2 = Ability.get(AbilityId.relaxation);

      final outcomeAB = AbilityResolver.resolve(level: l1, selectedAbilities: [a1, a2]);
      final outcomeBA = AbilityResolver.resolve(level: l1, selectedAbilities: [a2, a1]);

      expect(outcomeAB.grade, outcomeBA.grade);
      expect(outcomeAB.playerDamage, outcomeBA.playerDamage);
      expect(outcomeAB.threatDamage, outcomeBA.threatDamage);
      expect(outcomeAB.pressureChange, outcomeBA.pressureChange);
      expect(outcomeAB.synergyName, outcomeBA.synergyName);
    });

    test('F. Level 1-1 optimal combination -> EXCELLENT', () {
      final l1 = HeartCampaign.getLevelById('1-1');
      final a1 = Ability.get(AbilityId.forgivenessMeditation);
      final a2 = Ability.get(AbilityId.relaxation);

      final outcome = AbilityResolver.resolve(level: l1, selectedAbilities: [a1, a2]);
      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, 0);
      expect(outcome.threatDamage, greaterThanOrEqualTo(l1.enemy.maxHealth));
      expect(outcome.pressureChange, lessThan(0));
      expect(outcome.synergyDetected, isTrue);
    });

    test('G. Level 1-2 optimal combination -> EXCELLENT', () {
      final l2 = HeartCampaign.getLevelById('1-2');
      final a1 = Ability.get(AbilityId.potassiumRainbow);
      final a2 = Ability.get(AbilityId.beetrootFlush);

      final outcome = AbilityResolver.resolve(level: l2, selectedAbilities: [a1, a2]);
      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, 0);
      expect(outcome.threatDamage, greaterThanOrEqualTo(l2.enemy.maxHealth));
      expect(outcome.pressureChange, lessThan(0));
      expect(outcome.synergyDetected, isTrue);
    });

    test('H. Level 1-3 optimal combination -> EXCELLENT', () {
      final l3 = HeartCampaign.getLevelById('1-3');
      final a1 = Ability.get(AbilityId.deepSleepShield);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(level: l3, selectedAbilities: [a1, a2]);
      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, 0);
      expect(outcome.threatDamage, greaterThanOrEqualTo(l3.enemy.maxHealth));
      expect(outcome.pressureChange, lessThan(0));
      expect(outcome.synergyDetected, isTrue);
    });

    test('I. Level 1-4 Boss optimal combination -> EXCELLENT', () {
      final l4 = HeartCampaign.getLevelById('1-4');
      final a1 = Ability.get(AbilityId.goodLaughBlast);
      final a2 = Ability.get(AbilityId.beetrootFlush);

      final outcome = AbilityResolver.resolve(level: l4, selectedAbilities: [a1, a2]);
      expect(outcome.grade, BattleOutcomeGrade.excellent);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.playerDamage, 0);
      expect(outcome.threatDamage, greaterThanOrEqualTo(l4.enemy.maxHealth));
      expect(outcome.pressureChange, lessThan(0));
      expect(outcome.synergyDetected, isTrue);
    });

    test('J. Useful non-optimal combination -> GOOD', () {
      final l1 = HeartCampaign.getLevelById('1-1');
      final a1 = Ability.get(AbilityId.forgivenessMeditation);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(level: l1, selectedAbilities: [a1, a2]);
      expect(outcome.grade, BattleOutcomeGrade.good);
      expect(outcome.isSuccess, isTrue);
      expect(outcome.threatDamage, greaterThan(0));
      expect(outcome.pressureChange, lessThanOrEqualTo(0));
    });

    test('K. Weak/mismatched combination -> POOR', () {
      final l1 = HeartCampaign.getLevelById('1-1');
      final a1 = Ability.get(AbilityId.isometricHold);
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(level: l1, selectedAbilities: [a1, a2]);
      expect(outcome.grade, BattleOutcomeGrade.poor);
      expect(outcome.isSuccess, isFalse);
      expect(outcome.playerDamage, greaterThan(0));
      expect(outcome.pressureChange, greaterThan(0));
    });

    test('L. Toxic/vice combination -> TOXIC', () {
      final l1 = HeartCampaign.getLevelById('1-1');
      const toxicAbility = Ability(
        id: AbilityId.tomatoLasers,
        name: 'EXCESS STIMULANT',
        description: 'Harmful vice choice.',
        energyCost: 2,
        defensePower: 0,
        tags: {'vice'},
        isToxic: true,
        icon: Icons.dangerous_rounded,
        accentColor: Colors.red,
        imagePath: '',
      );
      final a2 = Ability.get(AbilityId.isotonicFlow);

      final outcome = AbilityResolver.resolve(level: l1, selectedAbilities: [toxicAbility, a2]);
      expect(outcome.grade, BattleOutcomeGrade.toxic);
      expect(outcome.isSuccess, isFalse);
      expect(outcome.playerDamage, greaterThan(0));
      expect(outcome.pressureChange, greaterThan(0));
    });

    test('M. Outcome application updates vitality, threat health, and pressure', () {
      final gameState = GameState(initialVitality: 80, initialPressure: 100);
      final l1 = HeartCampaign.getLevelById('1-1');
      gameState.selectLevel(l1);

      final card1 = DefenseCard.fromAbilityId(AbilityId.forgivenessMeditation);
      final card2 = DefenseCard.fromAbilityId(AbilityId.relaxation);

      final resolution = GameLogic.resolveBattle(
        level: l1,
        selectedCards: [card1, card2],
        currentGrid: l1.initialGrid,
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

    test('N. Determinism: Same input produces identical BattleOutcome', () {
      final l2 = HeartCampaign.getLevelById('1-2');
      final a1 = Ability.get(AbilityId.potassiumRainbow);
      final a2 = Ability.get(AbilityId.beetrootFlush);

      final run1 = AbilityResolver.resolve(level: l2, selectedAbilities: [a1, a2]);
      final run2 = AbilityResolver.resolve(level: l2, selectedAbilities: [a1, a2]);

      expect(run1.grade, run2.grade);
      expect(run1.playerDamage, run2.playerDamage);
      expect(run1.threatDamage, run2.threatDamage);
      expect(run1.pressureChange, run2.pressureChange);
      expect(run1.message, run2.message);
    });
  });
}

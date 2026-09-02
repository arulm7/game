import 'package:flutter_test/flutter_test.dart';
import 'package:saviours_vs_saboteurs/game/game_logic.dart';
import 'package:saviours_vs_saboteurs/game/heart_campaign.dart';
import 'package:saviours_vs_saboteurs/models/campaign_progress.dart';
import 'package:saviours_vs_saboteurs/models/defense_card.dart';
import 'package:saviours_vs_saboteurs/models/game_state.dart';

void main() {
  group('Heart-Rose Campaign Stage 1 Progression Tests', () {
    test('1. Level 1-1 is initially unlocked and 1-2, 1-3, 1-4 are locked', () {
      final progress = CampaignProgress();
      expect(progress.isLevelUnlocked('1-1'), isTrue);
      expect(progress.isLevelUnlocked('1-2'), isFalse);
      expect(progress.isLevelUnlocked('1-3'), isFalse);
      expect(progress.isLevelUnlocked('1-4'), isFalse);
      expect(progress.isStage1Completed, isFalse);
    });

    test('2. Completing 1-1 unlocks 1-2', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelUnlocked('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isFalse);
      expect(progress.isLevelUnlocked('1-4'), isFalse);
    });

    test('3. Completing 1-2 unlocks 1-3', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');

      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isFalse);
    });

    test('4. Completing 1-3 unlocks 1-4', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');
      progress.completeLevel('1-3');

      expect(progress.isLevelCompleted('1-3'), isTrue);
      expect(progress.isLevelUnlocked('1-4'), isTrue);
    });

    test('5. Completing 1-4 completes Stage 1', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');
      progress.completeLevel('1-3');
      progress.completeLevel('1-4');

      expect(progress.isLevelCompleted('1-4'), isTrue);
      expect(progress.isStage1Completed, isTrue);
    });

    test('6. Replaying a completed level does not reset progression', () {
      final progress = CampaignProgress();
      progress.completeLevel('1-1');
      progress.completeLevel('1-2');

      // Replaying level 1-1
      progress.completeLevel('1-1');

      expect(progress.isLevelCompleted('1-1'), isTrue);
      expect(progress.isLevelCompleted('1-2'), isTrue);
      expect(progress.isLevelUnlocked('1-3'), isTrue);
    });

    test('7. Resilience Seed rewards persist and accumulate', () {
      final gameState = GameState(initialResilienceSeeds: 1);
      expect(gameState.resilienceSeeds, 1);

      // Complete Level 1-1
      final l1 = HeartCampaign.getLevelById('1-1');
      gameState.selectLevel(l1);
      gameState.applyDefenseResolution(
        vitalityChange: 20,
        updatedGrid: l1.initialGrid,
        updatedEnemy: l1.enemy,
        isVictory: true,
      );

      expect(gameState.resilienceSeeds, 2);
      expect(gameState.campaignProgress.isLevelCompleted('1-1'), isTrue);
      expect(gameState.campaignProgress.isLevelUnlocked('1-2'), isTrue);
    });

    test('8. Level-specific curated card decks are correct', () {
      final l1 = HeartCampaign.getLevelById('1-1');
      expect(l1.availableCardTypes, contains(DefenseCardType.forgivenessMeditation));
      expect(l1.availableCardTypes, contains(DefenseCardType.isotonicFlow));
      expect(l1.availableCardTypes, contains(DefenseCardType.relaxation));
      expect(l1.availableCardTypes, contains(DefenseCardType.isometricHold));
      expect(l1.availableCards.length, 4);

      final l2 = HeartCampaign.getLevelById('1-2');
      expect(l2.availableCardTypes, contains(DefenseCardType.potassiumRainbow));
      expect(l2.availableCardTypes, contains(DefenseCardType.beetrootFlush));
      expect(l2.availableCards.length, 4);

      final l3 = HeartCampaign.getLevelById('1-3');
      expect(l3.availableCardTypes, contains(DefenseCardType.deepSleepShield));
      expect(l3.availableCardTypes, contains(DefenseCardType.isotonicFlow));
      expect(l3.availableCards.length, 4);

      final l4 = HeartCampaign.getLevelById('1-4');
      expect(l4.availableCardTypes, contains(DefenseCardType.goodLaughBlast));
      expect(l4.availableCardTypes, contains(DefenseCardType.beetrootFlush));
      expect(l4.isBoss, isTrue);
      expect(l4.availableCards.length, 5);
    });

    test('9. Card selection is strictly constrained to 2 cards', () {
      final gameState = GameState();
      final cards = DefenseCard.allCards;

      gameState.toggleCardSelection(cards[0]);
      gameState.toggleCardSelection(cards[1]);
      expect(gameState.selectedCards.length, 2);
      expect(gameState.canSelectMoreCards, isFalse);

      // Attempting 3rd selection is blocked
      gameState.toggleCardSelection(cards[2]);
      expect(gameState.selectedCards.length, 2);

      // Deselection works
      gameState.toggleCardSelection(cards[0]);
      expect(gameState.selectedCards.length, 1);
      expect(gameState.canSelectMoreCards, isTrue);
    });

    test('10. Level-specific synergies resolve deterministically', () {
      final l1 = HeartCampaign.getLevelById('1-1');
      final cards = DefenseCard.allCards;
      final forgivenessCard = cards.firstWhere((c) => c.type == DefenseCardType.forgivenessMeditation);
      final relaxationCard = cards.firstWhere((c) => c.type == DefenseCardType.relaxation);

      // Optimal synergy for Level 1-1
      final resL1 = GameLogic.resolveDefense(
        selectedCards: [forgivenessCard, relaxationCard],
        enemy: l1.enemy,
        currentGrid: l1.initialGrid,
      );

      expect(resL1.isVictory, isTrue);
      expect(resL1.synergyName, 'SERENE PARASYMPATHETIC CALM');
      expect(resL1.totalDefensePower, greaterThan(l1.enemy.baseDamage));

      // Level 1-4 Boss synergy
      final l4 = HeartCampaign.getLevelById('1-4');
      final laughCard = cards.firstWhere((c) => c.type == DefenseCardType.goodLaughBlast);
      final beetrootCard = cards.firstWhere((c) => c.type == DefenseCardType.beetrootFlush);

      final resL4 = GameLogic.resolveDefense(
        selectedCards: [laughCard, beetrootCard],
        enemy: l4.enemy,
        currentGrid: l4.initialGrid,
      );

      expect(resL4.isVictory, isTrue);
      expect(resL4.synergyName, 'ENDORPHIN NITRIC OVERDRIVE');
      expect(resL4.totalDefensePower, greaterThan(l4.enemy.baseDamage));
    });
  });
}

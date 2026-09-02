import '../models/defense_card.dart';
import '../models/enemy.dart';
import '../models/game_state.dart';
import '../models/grid_cell.dart';

class DefenseResolution {
  final PuzzleOutcome outcome;
  final int newVitality;
  final Enemy updatedEnemy;
  final List<GridCell> updatedGrid;
  final String title;
  final String message;
  final bool awardedSeed;
  final int damageDealt;
  final int vitalityRestored;

  const DefenseResolution({
    required this.outcome,
    required this.newVitality,
    required this.updatedEnemy,
    required this.updatedGrid,
    required this.title,
    required this.message,
    required this.awardedSeed,
    required this.damageDealt,
    required this.vitalityRestored,
  });
}

class GameLogic {
  static DefenseResolution resolveDefense({
    required List<DefenseCard> selectedCards,
    required int currentVitality,
    required Enemy currentEnemy,
    required List<GridCell> currentGrid,
  }) {
    if (selectedCards.length != 2) {
      return DefenseResolution(
        outcome: PuzzleOutcome.none,
        newVitality: currentVitality,
        updatedEnemy: currentEnemy,
        updatedGrid: currentGrid,
        title: 'Incomplete Defense',
        message: 'Select exactly 2 defense cards to balance your strategy.',
        awardedSeed: false,
        damageDealt: 0,
        vitalityRestored: 0,
      );
    }

    final card1 = selectedCards[0];
    final card2 = selectedCards[1];
    final types = {card1.type, card2.type};

    int totalPower = card1.defensePower + card2.defensePower;
    int synergyBonus = 0;
    String synergyName = 'Botanical Synergy';
    String description = '';

    // Calculate synergies
    if (types.contains(DefenseCardType.isotonicFlow) &&
        types.contains(DefenseCardType.beetrootFlush)) {
      synergyBonus = 25;
      synergyName = 'Hydro-Nitric Rush';
      description =
          'Rhythmic isotonic movement combined with nitric-oxide botanical surge flushes the arterial breach!';
    } else if (types.contains(DefenseCardType.relaxation) &&
        types.contains(DefenseCardType.beetrootFlush)) {
      synergyBonus = 20;
      synergyName = 'Vascular Harmony';
      description =
          'Arterial tension dropped rapidly, allowing beetroot nutrients to dilate and soothe root channels.';
    } else if (types.contains(DefenseCardType.isotonicFlow) &&
        types.contains(DefenseCardType.relaxation)) {
      synergyBonus = 18;
      synergyName = 'Rhythmic Calm';
      description =
          'Active movement without stress overload stabilizes the heart-rose rhythm and clears pressure nodes.';
    } else if (types.contains(DefenseCardType.potassiumRainbow) &&
        types.contains(DefenseCardType.isometricHold)) {
      synergyBonus = 15;
      synergyName = 'Electrolyte Fortification';
      description =
          'Mineral balance reinforces vascular wall resilience against plaque calcification.';
    } else if (types.contains(DefenseCardType.potassiumRainbow) &&
        types.contains(DefenseCardType.isotonicFlow)) {
      synergyBonus = 15;
      synergyName = 'Nutrient Flow';
      description =
          'Vital nutrients spread quickly through active channels, dissolving early crystalline deposits.';
    } else {
      synergyBonus = 10;
      synergyName = 'Botanical Reinforcement';
      description =
          'The combined botanical remedies fortify the Heart-Rose against Plaque Creep encroachment.';
    }

    final int finalDamage = totalPower + synergyBonus;
    final int enemyNewHealth = (currentEnemy.currentHealth - finalDamage).clamp(0, currentEnemy.maxHealth);
    final bool enemyDefeated = enemyNewHealth == 0;

    // Grid purification: turn blocked and critical cells into cleared/open
    final updatedGrid = currentGrid.map((cell) {
      if (cell.status == CellStatus.blocked || cell.status == CellStatus.critical) {
        return cell.copyWith(status: CellStatus.cleared);
      }
      return cell;
    }).toList();

    if (enemyDefeated) {
      final int heal = 20;
      final int newVit = (currentVitality + heal).clamp(0, 100);
      return DefenseResolution(
        outcome: PuzzleOutcome.success,
        newVitality: newVit,
        updatedEnemy: currentEnemy.copyWith(currentHealth: 0),
        updatedGrid: updatedGrid,
        title: 'BREACH SECURED! ($synergyName)',
        message:
            '$description\n\nPlaque Creep was dispelled from the arterial roots. Heart Vitality restored to $newVit%!',
        awardedSeed: true,
        damageDealt: finalDamage,
        vitalityRestored: heal,
      );
    } else {
      final int heal = 10;
      final int newVit = (currentVitality + heal).clamp(0, 100);
      return DefenseResolution(
        outcome: PuzzleOutcome.partialSuccess,
        newVitality: newVit,
        updatedEnemy: currentEnemy.copyWith(currentHealth: enemyNewHealth),
        updatedGrid: updatedGrid,
        title: 'PARTIAL DEFENSE ($synergyName)',
        message:
            '$description\n\nPlaque Creep took $finalDamage damage ($enemyNewHealth/${currentEnemy.maxHealth} HP remaining).',
        awardedSeed: false,
        damageDealt: finalDamage,
        vitalityRestored: heal,
      );
    }
  }
}

import '../models/defense_card.dart';
import '../models/enemy.dart';
import '../models/grid_cell.dart';

class DefenseResolution {
  final int totalDefensePower;
  final int netDamageToHeart;
  final int vitalityRestored;
  final int enemyDamageTaken;
  final bool isVictory;
  final String synergyName;
  final String outcomeDescription;
  final List<GridCell> updatedGrid;
  final Enemy updatedEnemy;

  const DefenseResolution({
    required this.totalDefensePower,
    required this.netDamageToHeart,
    required this.vitalityRestored,
    required this.enemyDamageTaken,
    required this.isVictory,
    required this.synergyName,
    required this.outcomeDescription,
    required this.updatedGrid,
    required this.updatedEnemy,
  });
}

class GameLogic {
  static DefenseResolution resolveDefense({
    required List<DefenseCard> selectedCards,
    required Enemy enemy,
    required List<GridCell> currentGrid,
    int currentVitality = 80,
    int maxVitality = 100,
  }) {
    int baseDefense = 0;
    for (final card in selectedCards) {
      baseDefense += card.defensePower;
    }

    final types = selectedCards.map((c) => c.type).toSet();
    int bonusDefense = 0;
    String synergyName = 'Standard Botanical Defense';
    String outcomeDescription = 'The Heart-Rose deployed natural botanical resistance.';

    // 1. Level 1-1 Synergy: Forgiveness Meditation + Relaxation / Isotonic Flow
    if (types.contains(DefenseCardType.forgivenessMeditation) &&
        types.contains(DefenseCardType.relaxation)) {
      bonusDefense = 45;
      synergyName = 'SERENE PARASYMPATHETIC CALM';
      outcomeDescription =
          'Mindful forgiveness froze the adrenaline swarm while gentle relaxation soothed arterial tension!';
    } else if (types.contains(DefenseCardType.forgivenessMeditation)) {
      bonusDefense = 30;
      synergyName = 'MINDFUL SURGE FREEZE';
      outcomeDescription =
          'Forgiveness Meditation arrested the acute stress surge and shielded root conduits.';
    }

    // 2. Level 1-2 Synergy: Potassium Rainbow + Beetroot Flush
    else if (types.contains(DefenseCardType.potassiumRainbow) &&
        types.contains(DefenseCardType.beetrootFlush)) {
      bonusDefense = 50;
      synergyName = 'ELECTROLYTE NITRIC SURGE';
      outcomeDescription =
          'Potassium Rainbow dissolved sodium crystallization while Beetroot Flush dilated constricted pathways!';
    } else if (types.contains(DefenseCardType.potassiumRainbow)) {
      bonusDefense = 30;
      synergyName = 'POTASSIUM FLUID EQUILIBRIUM';
      outcomeDescription =
          'Potassium nutrients countered acute sodium fluid pressure across arterial walls.';
    }

    // 3. Level 1-3 Synergy: Deep Sleep Shield + Isotonic Flow
    else if (types.contains(DefenseCardType.deepSleepShield) &&
        types.contains(DefenseCardType.isotonicFlow)) {
      bonusDefense = 55;
      synergyName = 'CIRCADIAN RESTORATIVE FLOW';
      outcomeDescription =
          'Deep Sleep Shield created an impenetrable recovery wall while Isotonic Flow restored rhythmic circulation!';
    } else if (types.contains(DefenseCardType.deepSleepShield)) {
      bonusDefense = 35;
      synergyName = 'NOCTURNAL BARRIER';
      outcomeDescription =
          'Deep Sleep Shield absorbed the compound invasion and provided crucial recovery window.';
    }

    // 4. Level 1-4 Boss Synergy: Good Laugh Blast + Beetroot Flush
    else if (types.contains(DefenseCardType.goodLaughBlast) &&
        types.contains(DefenseCardType.beetrootFlush)) {
      bonusDefense = 65;
      synergyName = 'ENDORPHIN NITRIC OVERDRIVE';
      outcomeDescription =
          'Joyful laughter endorphins triggered massive endothelial dilation, shattering the Hypertension Hijacker!';
    } else if (types.contains(DefenseCardType.goodLaughBlast)) {
      bonusDefense = 40;
      synergyName = 'ENDORPHIN VASCULAR RELEASE';
      outcomeDescription =
          'Good Laugh Blast expanded constricted channels and destabilized the Hijacker rhythm.';
    }

    // 5. Classic Stage 1 Prototype Synergies
    else if (types.contains(DefenseCardType.isotonicFlow) &&
        types.contains(DefenseCardType.beetrootFlush)) {
      bonusDefense = 45;
      synergyName = 'VASCULAR FLOW SURGE';
      outcomeDescription =
          'Rhythmic flow and nitric-oxide root dilation surged through arterial pathways, clearing blockages!';
    } else if (types.contains(DefenseCardType.relaxation) &&
        types.contains(DefenseCardType.isometricHold)) {
      bonusDefense = 40;
      synergyName = 'EQUILIBRIUM FORTRESS';
      outcomeDescription =
          'Calming resonance and sustained root conditioning fortified vascular tone against pressure!';
    }

    final totalDefense = baseDefense + bonusDefense;
    final isVictory = totalDefense >= enemy.baseDamage;

    final int enemyDmg = isVictory ? enemy.maxHealth : (totalDefense * 0.8).round();
    final updatedEnemy = enemy.copyWith(
      currentHealth: (enemy.currentHealth - enemyDmg).clamp(0, enemy.maxHealth),
    );

    int netDmg = 0;
    int vitalityRestored = 0;

    if (isVictory) {
      vitalityRestored = (totalDefense * 0.35).round().clamp(15, 40);
    } else {
      netDmg = (enemy.baseDamage - totalDefense).clamp(10, 45);
    }

    // Update arterial grid cells: resolve blocked and critical nodes
    final updatedGrid = currentGrid.map((cell) {
      if (isVictory) {
        if (cell.status == CellStatus.blocked || cell.status == CellStatus.critical) {
          return cell.copyWith(status: CellStatus.cleared);
        }
      }
      return cell;
    }).toList();

    return DefenseResolution(
      totalDefensePower: totalDefense,
      netDamageToHeart: netDmg,
      vitalityRestored: vitalityRestored,
      enemyDamageTaken: enemyDmg,
      isVictory: isVictory,
      synergyName: synergyName,
      outcomeDescription: outcomeDescription,
      updatedGrid: updatedGrid,
      updatedEnemy: updatedEnemy,
    );
  }
}

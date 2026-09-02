import '../models/ability.dart';
import '../models/battle_outcome.dart';
import '../models/heart_level.dart';

class AbilityResolver {
  static BattleOutcome resolve({
    required HeartLevel level,
    required List<Ability> selectedAbilities,
  }) {
    if (selectedAbilities.length != 2) {
      throw ArgumentError('AbilityResolver requires exactly 2 selected abilities.');
    }

    // Normalized set of ability IDs for order-independent evaluation
    final selectedIds = selectedAbilities.map((a) => a.id).toSet();
    final combinedTags = selectedAbilities.expand((a) => a.tags).toSet();
    final hasToxicAbility = selectedAbilities.any((a) => a.isToxic);

    // 1. Check for Toxic / Vice Trap
    if (hasToxicAbility) {
      return const BattleOutcome(
        grade: BattleOutcomeGrade.toxic,
        playerDamage: 35,
        threatDamage: 0,
        pressureChange: 30,
        vitalityRestored: 0,
        message: 'A toxic choice caused a severe setback and escalated vascular pressure!',
        synergyDetected: false,
        synergyName: 'TOXIC DISRUPTION',
        effectIdentifier: 'toxic_hazard',
      );
    }

    // 2. Check for Configured Optimal Level Synergy (EXCELLENT)
    final recommendedSet = level.recommendedSynergy.toSet();
    if (selectedIds.containsAll(recommendedSet) && selectedIds.length == recommendedSet.length) {
      return _buildOptimalOutcomeForLevel(level);
    }

    // 3. Level-specific Partial & Useful Counter Combos (GOOD)
    final goodOutcome = _evaluateUsefulCombo(level, selectedIds, combinedTags);
    if (goodOutcome != null) {
      return goodOutcome;
    }

    // 4. Mismatched / Weak Defense (POOR)
    return _buildPoorOutcomeForLevel(level);
  }

  static BattleOutcome _buildOptimalOutcomeForLevel(HeartLevel level) {
    switch (level.id) {
      case '1-1':
        return const BattleOutcome(
          grade: BattleOutcomeGrade.excellent,
          playerDamage: 0,
          threatDamage: 50,
          pressureChange: -25,
          vitalityRestored: 25,
          message:
              'Mindful forgiveness froze the adrenaline swarm while gentle relaxation soothed arterial tension perfectly!',
          synergyDetected: true,
          synergyName: 'SERENE PARASYMPATHETIC CALM',
          effectIdentifier: 'stress_swarm_freeze',
        );

      case '1-2':
        return const BattleOutcome(
          grade: BattleOutcomeGrade.excellent,
          playerDamage: 0,
          threatDamage: 60,
          pressureChange: -25,
          vitalityRestored: 25,
          message:
              'Potassium Rainbow dissolved sodium crystallization while Beetroot Flush dilated constricted pathways completely!',
          synergyDetected: true,
          synergyName: 'ELECTROLYTE NITRIC SURGE',
          effectIdentifier: 'sodium_crystal_dissolve',
        );

      case '1-3':
        return const BattleOutcome(
          grade: BattleOutcomeGrade.excellent,
          playerDamage: 0,
          threatDamage: 80,
          pressureChange: -30,
          vitalityRestored: 30,
          message:
              'Deep Sleep Shield created an impenetrable recovery wall while Isotonic Flow restored rhythmic circulation!',
          synergyDetected: true,
          synergyName: 'CIRCADIAN RESTORATIVE FLOW',
          effectIdentifier: 'circadian_shield_restoration',
        );

      case '1-4':
        return const BattleOutcome(
          grade: BattleOutcomeGrade.excellent,
          playerDamage: 0,
          threatDamage: 120,
          pressureChange: -35,
          vitalityRestored: 35,
          message:
              'Joyful laughter endorphins triggered massive endothelial dilation, shattering the Hypertension Hijacker!',
          synergyDetected: true,
          synergyName: 'ENDORPHIN NITRIC OVERDRIVE',
          effectIdentifier: 'boss_overdrive_shatter',
        );

      default:
        return BattleOutcome(
          grade: BattleOutcomeGrade.excellent,
          playerDamage: 0,
          threatDamage: level.enemy.maxHealth,
          pressureChange: -20,
          vitalityRestored: 25,
          message: 'Optimal synergy deployed, securing the Heart-Rose sanctuary!',
          synergyDetected: true,
          synergyName: 'PERFECT BOTANICAL SYNERGY',
        );
    }
  }

  static BattleOutcome? _evaluateUsefulCombo(
    HeartLevel level,
    Set<AbilityId> ids,
    Set<String> tags,
  ) {
    // Level 1-1 Useful Combinations (Partial stress counters)
    if (level.id == '1-1') {
      if (ids.contains(AbilityId.forgivenessMeditation)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 5,
          threatDamage: 40,
          pressureChange: -15,
          vitalityRestored: 15,
          message:
              'Forgiveness Meditation arrested the acute stress surge and shielded root conduits.',
          synergyDetected: true,
          synergyName: 'MINDFUL SURGE FREEZE',
        );
      }
      if (ids.contains(AbilityId.relaxation) && ids.contains(AbilityId.isotonicFlow)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 8,
          threatDamage: 35,
          pressureChange: -10,
          vitalityRestored: 12,
          message: 'Gentle relaxation and rhythmic circulation relieved active vascular tension.',
          synergyDetected: true,
          synergyName: 'GENTLE CIRCULATION',
        );
      }
    }

    // Level 1-2 Useful Combinations (Partial sodium/dilation counters)
    if (level.id == '1-2') {
      if (ids.contains(AbilityId.potassiumRainbow)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 5,
          threatDamage: 45,
          pressureChange: -15,
          vitalityRestored: 15,
          message:
              'Potassium nutrients countered acute sodium fluid pressure across arterial walls.',
          synergyDetected: true,
          synergyName: 'POTASSIUM FLUID EQUILIBRIUM',
        );
      }
      if (ids.contains(AbilityId.beetrootFlush)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 8,
          threatDamage: 40,
          pressureChange: -10,
          vitalityRestored: 12,
          message: 'Beetroot nitric surge dilated constricted channels despite lingering sodium.',
          synergyDetected: true,
          synergyName: 'VASCULAR DILATION',
        );
      }
    }

    // Level 1-3 Useful Combinations (Sleep shield or potassium flow)
    if (level.id == '1-3') {
      if (ids.contains(AbilityId.deepSleepShield)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 10,
          threatDamage: 55,
          pressureChange: -15,
          vitalityRestored: 15,
          message:
              'Deep Sleep Shield absorbed the compound invasion and provided crucial recovery window.',
          synergyDetected: true,
          synergyName: 'NOCTURNAL BARRIER',
        );
      }
      if (ids.contains(AbilityId.potassiumRainbow) && ids.contains(AbilityId.isotonicFlow)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 12,
          threatDamage: 50,
          pressureChange: -10,
          vitalityRestored: 12,
          message:
              'Potassium nutrients and isotonic circulation softened the dual surge.',
          synergyDetected: true,
          synergyName: 'ELECTROLYTE CIRCULATION',
        );
      }
    }

    // Level 1-4 Useful Combinations (Boss fight partial counter)
    if (level.id == '1-4') {
      if (ids.contains(AbilityId.goodLaughBlast)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 12,
          threatDamage: 75,
          pressureChange: -15,
          vitalityRestored: 18,
          message:
              'Good Laugh Blast expanded constricted channels and destabilized the Hijacker rhythm.',
          synergyDetected: true,
          synergyName: 'ENDORPHIN VASCULAR RELEASE',
        );
      }
      if (ids.contains(AbilityId.beetrootFlush)) {
        return const BattleOutcome(
          grade: BattleOutcomeGrade.good,
          playerDamage: 15,
          threatDamage: 65,
          pressureChange: -10,
          vitalityRestored: 14,
          message: 'Beetroot Flush maintained open vascular conduits against high pressure.',
          synergyDetected: true,
          synergyName: 'NITRIC EXPANSION',
        );
      }
    }

    // Generic Tag-Based Useful Synergies (Flow + Dilation, Calm + Tone)
    if (tags.contains('circulation') && tags.contains('dilation')) {
      return const BattleOutcome(
        grade: BattleOutcomeGrade.good,
        playerDamage: 8,
        threatDamage: 40,
        pressureChange: -10,
        vitalityRestored: 15,
        message: 'Rhythmic flow and nitric dilation surged through arterial pathways!',
        synergyDetected: true,
        synergyName: 'VASCULAR FLOW SURGE',
      );
    }

    if (tags.contains('calm') && tags.contains('conditioning')) {
      return const BattleOutcome(
        grade: BattleOutcomeGrade.good,
        playerDamage: 8,
        threatDamage: 38,
        pressureChange: -10,
        vitalityRestored: 12,
        message: 'Calming resonance and sustained root conditioning fortified vascular tone.',
        synergyDetected: true,
        synergyName: 'EQUILIBRIUM FORTRESS',
      );
    }

    return null;
  }

  static BattleOutcome _buildPoorOutcomeForLevel(HeartLevel level) {
    return BattleOutcome(
      grade: BattleOutcomeGrade.poor,
      playerDamage: level.enemy.baseDamage,
      threatDamage: 15,
      pressureChange: 15,
      vitalityRestored: 0,
      message:
          'Mismatched defense! The chosen abilities did not address the primary threat, and arterial pressure surged.',
      synergyDetected: false,
      synergyName: 'UNFOCUSED DEFENSE',
    );
  }
}

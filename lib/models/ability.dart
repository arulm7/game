import 'package:flutter/material.dart';

enum AbilityId {
  forgivenessMeditation,
  isotonicFlow,
  relaxation,
  isometricHold,
  potassiumRainbow,
  beetrootFlush,
  deepSleepShield,
  goodLaughBlast,
  hydrationTorrent,
  tomatoLasers,
}

class Ability {
  final AbilityId id;
  final String name;
  final String description;
  final int energyCost;
  final int defensePower;
  final Set<String> tags;
  final bool isToxic;
  final IconData icon;
  final Color accentColor;
  final String imagePath;

  const Ability({
    required this.id,
    required this.name,
    required this.description,
    required this.energyCost,
    required this.defensePower,
    required this.tags,
    this.isToxic = false,
    required this.icon,
    required this.accentColor,
    required this.imagePath,
  });

  static const Map<AbilityId, Ability> registry = {
    AbilityId.forgivenessMeditation: Ability(
      id: AbilityId.forgivenessMeditation,
      name: 'FORGIVENESS MEDITATION',
      description: 'Mindful emotional release that freezes stress parasites and calms acute surges.',
      energyCost: 1,
      defensePower: 30,
      tags: {'calm', 'mental', 'stress_counter', 'parasympathetic'},
      icon: Icons.self_improvement_rounded,
      accentColor: Color(0xFF80ED99),
      imagePath: 'assets/images/cards/relaxation.png',
    ),
    AbilityId.isotonicFlow: Ability(
      id: AbilityId.isotonicFlow,
      name: 'ISOTONIC FLOW',
      description: 'Circulation-themed rhythmic movement to clear active vascular blockages.',
      energyCost: 2,
      defensePower: 35,
      tags: {'circulation', 'movement', 'flow', 'aerobic'},
      icon: Icons.water_drop_rounded,
      accentColor: Color(0xFF38BDF8),
      imagePath: 'assets/images/cards/isotonic_flow.png',
    ),
    AbilityId.relaxation: Ability(
      id: AbilityId.relaxation,
      name: 'RELAXATION',
      description: 'Harmonious calm to relieve critical arterial tension & pressure spikes.',
      energyCost: 1,
      defensePower: 20,
      tags: {'calm', 'recovery', 'pressure_relief'},
      icon: Icons.spa_rounded,
      accentColor: Color(0xFF74C69D),
      imagePath: 'assets/images/cards/relaxation.png',
    ),
    AbilityId.isometricHold: Ability(
      id: AbilityId.isometricHold,
      name: 'ISOMETRIC HOLD',
      description: 'Conditioning botanical tonic building resilient sustained vascular tone.',
      energyCost: 3,
      defensePower: 40,
      tags: {'strength', 'conditioning', 'vascular_tone'},
      icon: Icons.shield_rounded,
      accentColor: Color(0xFFB5179E),
      imagePath: 'assets/images/cards/isometric_hold.png',
    ),
    AbilityId.potassiumRainbow: Ability(
      id: AbilityId.potassiumRainbow,
      name: 'POTASSIUM RAINBOW',
      description: 'Electrolyte nutrient spectrum to counter sodium constriction and fortify root walls.',
      energyCost: 2,
      defensePower: 35,
      tags: {'nutrition', 'electrolyte', 'sodium_counter', 'potassium'},
      icon: Icons.wb_sunny_rounded,
      accentColor: Color(0xFFFFD166),
      imagePath: 'assets/images/cards/potassium_rainbow.png',
    ),
    AbilityId.beetrootFlush: Ability(
      id: AbilityId.beetrootFlush,
      name: 'BEETROOT FLUSH',
      description: 'Nitric-oxide botanical surge to dilate constricted root vessels.',
      energyCost: 2,
      defensePower: 30,
      tags: {'nitric', 'dilation', 'circulation', 'endothelial'},
      icon: Icons.eco_rounded,
      accentColor: Color(0xFFFF5D8F),
      imagePath: 'assets/images/cards/beetroot_flush.png',
    ),
    AbilityId.deepSleepShield: Ability(
      id: AbilityId.deepSleepShield,
      name: 'DEEP SLEEP SHIELD',
      description: 'Nocturnal restorative barrier shielding the Heart-Rose from dual exhaustion.',
      energyCost: 2,
      defensePower: 40,
      tags: {'sleep', 'circadian', 'recovery', 'barrier'},
      icon: Icons.bedtime_rounded,
      accentColor: Color(0xFF7209B7),
      imagePath: 'assets/images/cards/isometric_hold.png',
    ),
    AbilityId.goodLaughBlast: Ability(
      id: AbilityId.goodLaughBlast,
      name: 'GOOD LAUGH BLAST',
      description: 'Endorphin-rich joyful botanical burst rapidly expanding constricted vessels.',
      energyCost: 2,
      defensePower: 45,
      tags: {'endorphin', 'joy', 'dilation', 'boss_counter'},
      icon: Icons.sentiment_very_satisfied_rounded,
      accentColor: Color(0xFFFF9E00),
      imagePath: 'assets/images/cards/potassium_rainbow.png',
    ),
    AbilityId.hydrationTorrent: Ability(
      id: AbilityId.hydrationTorrent,
      name: 'HYDRATION TORRENT',
      description: 'Pure botanical spring water flushing crystalline mineral deposits.',
      energyCost: 2,
      defensePower: 30,
      tags: {'hydration', 'flush', 'fluid_balance'},
      icon: Icons.opacity_rounded,
      accentColor: Color(0xFF48CAE4),
      imagePath: 'assets/images/cards/isotonic_flow.png',
    ),
    AbilityId.tomatoLasers: Ability(
      id: AbilityId.tomatoLasers,
      name: 'TOMATO LASERS',
      description: 'Lycopene antioxidant botanical beams dissolving vascular plaque.',
      energyCost: 2,
      defensePower: 35,
      tags: {'antioxidant', 'lycopene', 'plaque_dissolve'},
      icon: Icons.flare_rounded,
      accentColor: Color(0xFFE63946),
      imagePath: 'assets/images/cards/beetroot_flush.png',
    ),
  };

  static Ability get(AbilityId id) => registry[id]!;
  static List<Ability> get all => registry.values.toList();
}

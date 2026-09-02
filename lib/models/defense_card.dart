import 'package:flutter/material.dart';

enum DefenseCardType {
  isotonicFlow,
  beetrootFlush,
  potassiumRainbow,
  relaxation,
  isometricHold,
  forgivenessMeditation,
  deepSleepShield,
  goodLaughBlast,
  hydrationTorrent,
  tomatoLasers,
}

class DefenseCard {
  final String id;
  final String name;
  final String description;
  final int energyCost;
  final int defensePower;
  final DefenseCardType type;
  final IconData icon;
  final Color accentColor;
  final String imagePath;

  const DefenseCard({
    required this.id,
    required this.name,
    required this.description,
    required this.energyCost,
    required this.defensePower,
    required this.type,
    required this.icon,
    required this.accentColor,
    required this.imagePath,
  });

  static List<DefenseCard> get allCards => const [
        DefenseCard(
          id: 'isotonic_flow',
          name: 'ISOTONIC FLOW',
          description: 'Circulation-themed rhythmic movement to clear active vascular blockages.',
          energyCost: 2,
          defensePower: 35,
          type: DefenseCardType.isotonicFlow,
          icon: Icons.water_drop_rounded,
          accentColor: Color(0xFF38BDF8),
          imagePath: 'assets/images/cards/isotonic_flow.png',
        ),
        DefenseCard(
          id: 'beetroot_flush',
          name: 'BEETROOT FLUSH',
          description: 'Nitric-oxide botanical surge to dilate constricted root vessels.',
          energyCost: 2,
          defensePower: 30,
          type: DefenseCardType.beetrootFlush,
          icon: Icons.eco_rounded,
          accentColor: Color(0xFFFF5D8F),
          imagePath: 'assets/images/cards/beetroot_flush.png',
        ),
        DefenseCard(
          id: 'potassium_rainbow',
          name: 'POTASSIUM RAINBOW',
          description: 'Electrolyte nutrient spectrum to counter sodium constriction and fortify root walls.',
          energyCost: 2,
          defensePower: 35,
          type: DefenseCardType.potassiumRainbow,
          icon: Icons.wb_sunny_rounded,
          accentColor: Color(0xFFFFD166),
          imagePath: 'assets/images/cards/potassium_rainbow.png',
        ),
        DefenseCard(
          id: 'relaxation',
          name: 'RELAXATION',
          description: 'Harmonious calm to relieve critical arterial tension & pressure spikes.',
          energyCost: 1,
          defensePower: 20,
          type: DefenseCardType.relaxation,
          icon: Icons.spa_rounded,
          accentColor: Color(0xFF74C69D),
          imagePath: 'assets/images/cards/relaxation.png',
        ),
        DefenseCard(
          id: 'isometric_hold',
          name: 'ISOMETRIC HOLD',
          description: 'Conditioning botanical tonic building resilient sustained vascular tone.',
          energyCost: 3,
          defensePower: 40,
          type: DefenseCardType.isometricHold,
          icon: Icons.shield_rounded,
          accentColor: Color(0xFFB5179E),
          imagePath: 'assets/images/cards/isometric_hold.png',
        ),
        DefenseCard(
          id: 'forgiveness_meditation',
          name: 'FORGIVENESS MEDITATION',
          description: 'Mindful emotional release that freezes stress parasites and calms acute surges.',
          energyCost: 1,
          defensePower: 30,
          type: DefenseCardType.forgivenessMeditation,
          icon: Icons.self_improvement_rounded,
          accentColor: Color(0xFF80ED99),
          imagePath: 'assets/images/cards/relaxation.png',
        ),
        DefenseCard(
          id: 'deep_sleep_shield',
          name: 'DEEP SLEEP SHIELD',
          description: 'Nocturnal restorative barrier shielding the Heart-Rose from dual exhaustion.',
          energyCost: 2,
          defensePower: 40,
          type: DefenseCardType.deepSleepShield,
          icon: Icons.bedtime_rounded,
          accentColor: Color(0xFF7209B7),
          imagePath: 'assets/images/cards/isometric_hold.png',
        ),
        DefenseCard(
          id: 'good_laugh_blast',
          name: 'GOOD LAUGH BLAST',
          description: 'Endorphin-rich joyful botanical burst rapidly expanding constricted vessels.',
          energyCost: 2,
          defensePower: 45,
          type: DefenseCardType.goodLaughBlast,
          icon: Icons.sentiment_very_satisfied_rounded,
          accentColor: Color(0xFFFF9E00),
          imagePath: 'assets/images/cards/potassium_rainbow.png',
        ),
        DefenseCard(
          id: 'hydration_torrent',
          name: 'HYDRATION TORRENT',
          description: 'Pure botanical spring water flushing crystalline mineral deposits.',
          energyCost: 2,
          defensePower: 30,
          type: DefenseCardType.hydrationTorrent,
          icon: Icons.opacity_rounded,
          accentColor: Color(0xFF48CAE4),
          imagePath: 'assets/images/cards/isotonic_flow.png',
        ),
        DefenseCard(
          id: 'tomato_lasers',
          name: 'TOMATO LASERS',
          description: 'Lycopene antioxidant botanical beams dissolving vascular plaque.',
          energyCost: 2,
          defensePower: 35,
          type: DefenseCardType.tomatoLasers,
          icon: Icons.flare_rounded,
          accentColor: Color(0xFFE63946),
          imagePath: 'assets/images/cards/beetroot_flush.png',
        ),
      ];

  static List<DefenseCard> get initialCards => allCards.take(5).toList();

  static List<DefenseCard> getCardsForTypes(List<DefenseCardType> types) {
    return allCards.where((c) => types.contains(c.type)).toList();
  }
}

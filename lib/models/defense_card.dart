import 'package:flutter/material.dart';

enum DefenseCardType {
  isotonicFlow,
  beetrootFlush,
  potassiumRainbow,
  relaxation,
  isometricHold,
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

  static List<DefenseCard> get initialCards => const [
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
          description: 'Electrolyte nutrient spectrum to fortify vascular wall stability.',
          energyCost: 2,
          defensePower: 25,
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
      ];
}

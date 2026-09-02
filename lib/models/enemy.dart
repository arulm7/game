import 'package:flutter/material.dart';

enum EnemyType {
  plaqueCreep,
  stressParasites,
  sodiumSpikes,
  stressAndSodium,
  hypertensionHijacker,
}

class Enemy {
  final String id;
  final String name;
  final String title;
  final String description;
  final int baseDamage;
  final int currentHealth;
  final int maxHealth;
  final EnemyType type;
  final Color threatColor;
  final String imagePath;
  final bool isBoss;

  const Enemy({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.baseDamage,
    required this.currentHealth,
    required this.maxHealth,
    required this.type,
    this.threatColor = const Color(0xFFFF5964),
    this.imagePath = 'assets/images/enemies/plaque_creep.png',
    this.isBoss = false,
  });

  Enemy copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    int? baseDamage,
    int? currentHealth,
    int? maxHealth,
    EnemyType? type,
    Color? threatColor,
    String? imagePath,
    bool? isBoss,
  }) {
    return Enemy(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      baseDamage: baseDamage ?? this.baseDamage,
      currentHealth: currentHealth ?? this.currentHealth,
      maxHealth: maxHealth ?? this.maxHealth,
      type: type ?? this.type,
      threatColor: threatColor ?? this.threatColor,
      imagePath: imagePath ?? this.imagePath,
      isBoss: isBoss ?? this.isBoss,
    );
  }

  static Enemy get plaqueCreep => const Enemy(
        id: 'plaque_creep',
        name: 'PLAQUE CREEP',
        title: 'Calcifying Blightling',
        description:
            'A mischievous biological blight creature that secretes sticky mineral crusts onto arterial roots, narrowing blood flow.',
        baseDamage: 25,
        currentHealth: 60,
        maxHealth: 60,
        type: EnemyType.plaqueCreep,
        threatColor: Color(0xFFFF5964),
        imagePath: 'assets/images/enemies/plaque_creep.png',
      );

  static Enemy get stressParasites => const Enemy(
        id: 'stress_parasites',
        name: 'STRESS PARASITES',
        title: 'Acute Adrenaline Swarm',
        description:
            'A swarm of erratic electrical parasites feeding on acute stress surges, causing rapid arterial clamping.',
        baseDamage: 20,
        currentHealth: 50,
        maxHealth: 50,
        type: EnemyType.stressParasites,
        threatColor: Color(0xFFFF758F),
        imagePath: 'assets/images/enemies/plaque_creep.png',
      );

  static Enemy get sodiumSpikes => const Enemy(
        id: 'sodium_spikes',
        name: 'SODIUM SPIKES',
        title: 'Mineral Crystal Constrictor',
        description:
            'Sharp crystalline mineral blight that draws excess fluid and stiffens arterial root conduits.',
        baseDamage: 25,
        currentHealth: 60,
        maxHealth: 60,
        type: EnemyType.sodiumSpikes,
        threatColor: Color(0xFFFF9E00),
        imagePath: 'assets/images/enemies/plaque_creep.png',
      );

  static Enemy get stressAndSodium => const Enemy(
        id: 'stress_and_sodium',
        name: 'DUAL INVASION: STRESS & SODIUM',
        title: 'Combined Exhaustion Surge',
        description:
            'A synchronized onslaught of adrenaline parasites and rigid sodium crystals suffocating the Heart-Rose.',
        baseDamage: 30,
        currentHealth: 80,
        maxHealth: 80,
        type: EnemyType.stressAndSodium,
        threatColor: Color(0xFF9D4EDD),
        imagePath: 'assets/images/enemies/plaque_creep.png',
      );

  static Enemy get hypertensionHijacker => const Enemy(
        id: 'hypertension_hijacker',
        name: 'HYPERTENSION HIJACKER',
        title: 'Stage 1 Overlord Boss',
        description:
            'A colossal pulsing bio-electrical blight monstrosity threatening to permanently hijack the Heart-Rose pressure rhythm.',
        baseDamage: 35,
        currentHealth: 120,
        maxHealth: 120,
        type: EnemyType.hypertensionHijacker,
        threatColor: Color(0xFFFF0054),
        imagePath: 'assets/images/enemies/plaque_creep.png',
        isBoss: true,
      );
}

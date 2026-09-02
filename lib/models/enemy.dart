import 'package:flutter/material.dart';

enum EnemyType {
  plaqueCreep,
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
}

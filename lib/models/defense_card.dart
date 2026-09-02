import 'package:flutter/material.dart';
import 'ability.dart';

typedef DefenseCardType = AbilityId;

class DefenseCard {
  final Ability ability;

  const DefenseCard({
    required this.ability,
  });

  String get id => ability.id.name;
  String get name => ability.name;
  String get description => ability.description;
  int get energyCost => ability.energyCost;
  int get defensePower => ability.defensePower;
  DefenseCardType get type => ability.id;
  IconData get icon => ability.icon;
  Color get accentColor => ability.accentColor;
  String get imagePath => ability.imagePath;
  bool get isToxic => ability.isToxic;
  Set<String> get tags => ability.tags;

  static List<DefenseCard> get allCards =>
      Ability.all.map((ability) => DefenseCard(ability: ability)).toList();

  static List<DefenseCard> get initialCards => allCards.take(5).toList();

  static List<DefenseCard> getCardsForTypes(List<DefenseCardType> types) {
    return allCards.where((c) => types.contains(c.type)).toList();
  }

  static DefenseCard fromAbilityId(AbilityId id) {
    return DefenseCard(ability: Ability.get(id));
  }
}

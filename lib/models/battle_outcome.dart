enum BattleOutcomeGrade {
  excellent,
  good,
  poor,
  toxic,
}

class BattleOutcome {
  final BattleOutcomeGrade grade;
  final int playerDamage;
  final int threatDamage;
  final int pressureChange;
  final int vitalityRestored;
  final String message;
  final bool synergyDetected;
  final String synergyName;
  final String? effectIdentifier;

  const BattleOutcome({
    required this.grade,
    required this.playerDamage,
    required this.threatDamage,
    required this.pressureChange,
    this.vitalityRestored = 0,
    required this.message,
    required this.synergyDetected,
    required this.synergyName,
    this.effectIdentifier,
  });

  bool get isSuccess =>
      grade == BattleOutcomeGrade.excellent || grade == BattleOutcomeGrade.good;

  bool get isVictory => isSuccess;

  String get title {
    switch (grade) {
      case BattleOutcomeGrade.excellent:
        return 'EXCELLENT DEFENSE!';
      case BattleOutcomeGrade.good:
        return 'DEFENSE HELD!';
      case BattleOutcomeGrade.poor:
        return 'HEAVY PRESSURE!';
      case BattleOutcomeGrade.toxic:
        return 'TOXIC SETBACK!';
    }
  }

  String get gradeLabel {
    switch (grade) {
      case BattleOutcomeGrade.excellent:
        return 'EXCELLENT';
      case BattleOutcomeGrade.good:
        return 'GOOD';
      case BattleOutcomeGrade.poor:
        return 'POOR';
      case BattleOutcomeGrade.toxic:
        return 'TOXIC';
    }
  }
}

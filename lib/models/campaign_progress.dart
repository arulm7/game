class CampaignProgress {
  final Set<String> _unlockedLevelIds;
  final Set<String> _completedLevelIds;

  CampaignProgress({
    Set<String>? unlockedLevelIds,
    Set<String>? completedLevelIds,
  })  : _unlockedLevelIds = unlockedLevelIds ?? {'1-1'},
        _completedLevelIds = completedLevelIds ?? {};

  Set<String> get unlockedLevelIds => Set.unmodifiable(_unlockedLevelIds);
  Set<String> get completedLevelIds => Set.unmodifiable(_completedLevelIds);

  bool isLevelUnlocked(String levelId) => _unlockedLevelIds.contains(levelId);
  bool isLevelCompleted(String levelId) => _completedLevelIds.contains(levelId);

  bool get isStage1Completed => _completedLevelIds.contains('1-4');

  bool completeLevel(String levelId) {
    final isFirstCompletion = _completedLevelIds.add(levelId);

    // Unlock next level in progression
    if (levelId == '1-1') {
      _unlockedLevelIds.add('1-2');
    } else if (levelId == '1-2') {
      _unlockedLevelIds.add('1-3');
    } else if (levelId == '1-3') {
      _unlockedLevelIds.add('1-4');
    }

    return isFirstCompletion;
  }

  void resetProgress() {
    _unlockedLevelIds.clear();
    _unlockedLevelIds.add('1-1');
    _completedLevelIds.clear();
  }
}

import '../models/defense_card.dart';
import '../models/enemy.dart';
import '../models/grid_cell.dart';
import '../models/heart_level.dart';

class HeartCampaign {
  static const String stageTitle = 'STAGE 1: THE PRESSURE SURGE';
  static const String stageSubtitle = 'Acute Stress, Sodium & Vascular Pressure Campaigns';

  static final List<HeartLevel> stage1Levels = [
    // Level 1-1: The Morning Rush
    HeartLevel(
      id: '1-1',
      stageNumber: 1,
      levelNumber: 1,
      title: 'THE MORNING RUSH',
      subtitle: 'Stage 1-1 • Acute Adrenaline Threat',
      scenario:
          'Sudden acute morning stress swarms the arterial roots. Stress Parasites are clamping the vascular conduits of the Heart-Rose!',
      enemy: Enemy.stressParasites,
      initialGrid: const [
        GridCell(row: 0, col: 0, status: CellStatus.open, label: 'L-Superior'),
        GridCell(row: 0, col: 1, status: CellStatus.blocked, label: 'Aortic Arch'),
        GridCell(row: 0, col: 2, status: CellStatus.open, label: 'R-Coronary'),
        GridCell(row: 1, col: 0, status: CellStatus.open, label: 'Pulm-Trunk'),
        GridCell(row: 1, col: 1, status: CellStatus.critical, label: 'Septal Root'),
        GridCell(row: 1, col: 2, status: CellStatus.open, label: 'Circumflex'),
        GridCell(row: 2, col: 0, status: CellStatus.open, label: 'Apex Tendril'),
        GridCell(row: 2, col: 1, status: CellStatus.open, label: 'Marginal Bed'),
        GridCell(row: 2, col: 2, status: CellStatus.open, label: 'Micro-Vessel'),
      ],
      availableCardTypes: const [
        DefenseCardType.forgivenessMeditation,
        DefenseCardType.isotonicFlow,
        DefenseCardType.relaxation,
        DefenseCardType.isometricHold,
      ],
      recommendedSynergy: const [
        DefenseCardType.forgivenessMeditation,
        DefenseCardType.relaxation,
      ],
      recommendedHint:
          'Forgiveness Meditation freezes the adrenaline parasite swarm, while Relaxation soothes arterial tension.',
      bioFact: const BioFact(
        whatHappened:
            'The selected defenses reduced the Stress Parasites\' pressure in the game.',
        gameLesson:
            'Combining abilities that address the same challenge can create a stronger defense.',
        realWorldConnection:
            'Stress activates the body\'s stress-response systems. Relaxation and healthy coping strategies can support a calmer response. Long-term healthy lifestyle patterns are important for cardiovascular health.',
      ),
      isBoss: false,
      seedReward: 1,
      iconEmoji: '🌱',
    ),

    // Level 1-2: The Fast-Food Pitstop
    HeartLevel(
      id: '1-2',
      stageNumber: 1,
      levelNumber: 2,
      title: 'THE FAST-FOOD PITSTOP',
      subtitle: 'Stage 1-2 • Sodium Overload',
      scenario:
          'An in-game Sodium Spike surge is moving through the arterial roots. Choose two defenses to protect the Heart-Rose.',
      enemy: Enemy.sodiumSpikes,
      initialGrid: const [
        GridCell(row: 0, col: 0, status: CellStatus.blocked, label: 'L-Superior'),
        GridCell(row: 0, col: 1, status: CellStatus.blocked, label: 'Aortic Arch'),
        GridCell(row: 0, col: 2, status: CellStatus.open, label: 'R-Coronary'),
        GridCell(row: 1, col: 0, status: CellStatus.open, label: 'Pulm-Trunk'),
        GridCell(row: 1, col: 1, status: CellStatus.critical, label: 'Septal Root'),
        GridCell(row: 1, col: 2, status: CellStatus.blocked, label: 'Circumflex'),
        GridCell(row: 2, col: 0, status: CellStatus.open, label: 'Apex Tendril'),
        GridCell(row: 2, col: 1, status: CellStatus.open, label: 'Marginal Bed'),
        GridCell(row: 2, col: 2, status: CellStatus.open, label: 'Micro-Vessel'),
      ],
      availableCardTypes: const [
        DefenseCardType.potassiumRainbow,
        DefenseCardType.beetrootFlush,
        DefenseCardType.isotonicFlow,
        DefenseCardType.isometricHold,
      ],
      recommendedSynergy: const [
        DefenseCardType.potassiumRainbow,
        DefenseCardType.beetrootFlush,
      ],
      recommendedHint:
          'Potassium-Rich Rainbow Flush counters sodium crystallization while Beetroot Flush expands constricted conduits.',
      bioFact: const BioFact(
        whatHappened:
            'The Sodium Spikes overwhelmed the arterial roots in this game scenario until the selected defenses countered the surge.',
        gameLesson:
            'Some abilities work better together because they address related parts of the same challenge.',
        realWorldConnection:
            'Potassium is an important nutrient, and overall dietary patterns can influence cardiovascular health. The game\'s effects are simplified representations for learning and are not medical treatment.',
      ),
      isBoss: false,
      seedReward: 1,
      iconEmoji: '🌿',
    ),

    // Level 1-3: The All-Nighter
    HeartLevel(
      id: '1-3',
      stageNumber: 1,
      levelNumber: 3,
      title: 'THE ALL-NIGHTER',
      subtitle: 'Stage 1-3 • Combined Threat Surge',
      scenario:
          'An all-night session has stirred a combined Stress Parasite and Sodium Spike surge through the arterial roots. Choose two defenses to protect the Heart-Rose.',
      enemy: Enemy.stressAndSodium,
      initialGrid: const [
        GridCell(row: 0, col: 0, status: CellStatus.blocked, label: 'L-Superior'),
        GridCell(row: 0, col: 1, status: CellStatus.critical, label: 'Aortic Arch'),
        GridCell(row: 0, col: 2, status: CellStatus.blocked, label: 'R-Coronary'),
        GridCell(row: 1, col: 0, status: CellStatus.open, label: 'Pulm-Trunk'),
        GridCell(row: 1, col: 1, status: CellStatus.critical, label: 'Septal Root'),
        GridCell(row: 1, col: 2, status: CellStatus.open, label: 'Circumflex'),
        GridCell(row: 2, col: 0, status: CellStatus.blocked, label: 'Apex Tendril'),
        GridCell(row: 2, col: 1, status: CellStatus.open, label: 'Marginal Bed'),
        GridCell(row: 2, col: 2, status: CellStatus.open, label: 'Micro-Vessel'),
      ],
      availableCardTypes: const [
        DefenseCardType.deepSleepShield,
        DefenseCardType.isotonicFlow,
        DefenseCardType.relaxation,
        DefenseCardType.potassiumRainbow,
      ],
      recommendedSynergy: const [
        DefenseCardType.deepSleepShield,
        DefenseCardType.isotonicFlow,
      ],
      recommendedHint:
          'Think about the whole challenge, not just one threat. Deep Sleep Shield provides recovery while Isotonic Flow restores circulation.',
      bioFact: const BioFact(
        whatHappened:
            'The combined Stress Parasite and Sodium Spike surge created a stronger challenge in this game scenario.',
        gameLesson:
            'Some challenges have more than one pressure point. A strong strategy considers the whole situation before choosing a pair of defenses.',
        realWorldConnection:
            'Sleep is an important part of overall health, and dietary patterns including sodium and potassium can be relevant to cardiovascular health. The game\'s abilities simplify these ideas into strategy mechanics and are not medical treatment.',
      ),
      isBoss: false,
      seedReward: 1,
      iconEmoji: '🌺',
    ),

    // Level 1-4: Boss — The Hypertension Hijacker
    HeartLevel(
      id: '1-4',
      stageNumber: 1,
      levelNumber: 4,
      title: 'HYPERTENSION HIJACKER',
      subtitle: 'Stage 1 Boss • Critical Pressure Peak',
      scenario:
          'The Hypertension Hijacker has emerged! A colossal bio-electrical monstrosity threatening to permanently hijack the Heart-Rose pressure rhythm!',
      enemy: Enemy.hypertensionHijacker,
      initialGrid: const [
        GridCell(row: 0, col: 0, status: CellStatus.critical, label: 'L-Superior'),
        GridCell(row: 0, col: 1, status: CellStatus.blocked, label: 'Aortic Arch'),
        GridCell(row: 0, col: 2, status: CellStatus.critical, label: 'R-Coronary'),
        GridCell(row: 1, col: 0, status: CellStatus.blocked, label: 'Pulm-Trunk'),
        GridCell(row: 1, col: 1, status: CellStatus.critical, label: 'Septal Root'),
        GridCell(row: 1, col: 2, status: CellStatus.blocked, label: 'Circumflex'),
        GridCell(row: 2, col: 0, status: CellStatus.open, label: 'Apex Tendril'),
        GridCell(row: 2, col: 1, status: CellStatus.open, label: 'Marginal Bed'),
        GridCell(row: 2, col: 2, status: CellStatus.open, label: 'Micro-Vessel'),
      ],
      availableCardTypes: const [
        DefenseCardType.goodLaughBlast,
        DefenseCardType.beetrootFlush,
        DefenseCardType.isotonicFlow,
        DefenseCardType.relaxation,
        DefenseCardType.isometricHold,
      ],
      recommendedSynergy: const [
        DefenseCardType.goodLaughBlast,
        DefenseCardType.beetrootFlush,
      ],
      recommendedHint:
          'Good Laugh Blast combined with Beetroot Nitric-Flush triggers massive endothelial dilation to shatter the Hijacker!',
      bioFact: const BioFact(
        whatHappened:
            'The Hypertension Hijacker was dispelled through massive endorphin release and nitric-oxide vascular surge.',
        gameLesson:
            'Overcoming major cardiovascular pressure requires joyful stress release, vascular elasticity, and comprehensive lifestyle harmony.',
        realWorldConnection:
            'Laughter triggers endorphins and enhances blood flow, while dietary nitrates boost nitric oxide production, promoting sustained endothelial dilation.',
      ),
      isBoss: true,
      seedReward: 2,
      iconEmoji: '👑',
    ),
  ];

  static HeartLevel getLevelById(String id) {
    return stage1Levels.firstWhere(
      (level) => level.id == id,
      orElse: () => stage1Levels.first,
    );
  }
}

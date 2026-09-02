import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saviours_vs_saboteurs/game/game_logic.dart';
import 'package:saviours_vs_saboteurs/main.dart';
import 'package:saviours_vs_saboteurs/models/defense_card.dart';
import 'package:saviours_vs_saboteurs/models/enemy.dart';
import 'package:saviours_vs_saboteurs/models/game_state.dart';
import 'package:saviours_vs_saboteurs/models/grid_cell.dart';

void main() {
  testWidgets('Game navigation and full defense flow test', (WidgetTester tester) async {
    // Set standard tablet/desktop test surface to comfortably fit all screens
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SavioursVsSaboteursApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Verify Magical Garden screen
    expect(find.text('SAVIOURS'), findsOneWidget);
    expect(find.text('SABOTEURS'), findsOneWidget);
    expect(find.text('Protect the Living Garden'), findsOneWidget);
    expect(find.text('ENTER HEART'), findsOneWidget);

    // 2. Tap ENTER HEART -> Navigate to Heart-Rose Atrium
    await tester.tap(find.text('ENTER HEART'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('HEART-ROSE ATRIUM'), findsOneWidget);
    expect(find.text('HEART VITALITY'), findsOneWidget);
    expect(find.text('PLAQUE CREEP'), findsOneWidget);
    expect(find.text('ENTER STRATEGY'), findsOneWidget);

    // 3. Tap ENTER STRATEGY -> Navigate to The Arterial Breach
    await tester.tap(find.text('ENTER STRATEGY'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('THE ARTERIAL BREACH'), findsOneWidget);
    expect(find.text('ARTERIAL ROOT NETWORK'), findsOneWidget);
    expect(find.text('3 × 3 GRID'), findsOneWidget);
    expect(find.text('ISOTONIC FLOW'), findsOneWidget);
    expect(find.text('BEETROOT FLUSH'), findsOneWidget);

    // Defend button is initially disabled with text prompt
    expect(find.text('SELECT 2 CARDS TO DEFEND'), findsOneWidget);

    // 4. Select exactly 2 cards
    await tester.tap(find.text('ISOTONIC FLOW'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('SELECT 2 CARDS TO DEFEND'), findsOneWidget);

    await tester.tap(find.text('BEETROOT FLUSH'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Now Defend button should say DEFEND HEART
    expect(find.text('DEFEND HEART'), findsOneWidget);

    // 5. Tap DEFEND HEART to resolve
    await tester.tap(find.text('DEFEND HEART'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Result dialog appears with victory/success & seed award
    expect(find.textContaining('BREACH SECURED'), findsOneWidget);
    expect(find.text('+1 RESILIENCE SEED AWARDED!'), findsOneWidget);
    expect(find.text('PLAY AGAIN'), findsOneWidget);

    // 6. Test replay
    await tester.tap(find.text('PLAY AGAIN'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('SELECT 2 CARDS TO DEFEND'), findsOneWidget);
  });

  test('GameLogic unit test for deterministic synergy resolution', () {
    final cards = [
      DefenseCard.initialCards[0], // Isotonic Flow
      DefenseCard.initialCards[1], // Beetroot Flush
    ];

    final result = GameLogic.resolveDefense(
      selectedCards: cards,
      currentVitality: 80,
      currentEnemy: Enemy.plaqueCreep,
      currentGrid: GridCell.initialBreachGrid,
    );

    expect(result.outcome, equals(PuzzleOutcome.success));
    expect(result.awardedSeed, isTrue);
    expect(result.newVitality, equals(100));
    expect(result.updatedEnemy.currentHealth, equals(0));
  });
}

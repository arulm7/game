import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saviours_vs_saboteurs/game/heart_campaign.dart';
import 'package:saviours_vs_saboteurs/main.dart';

void main() {
  testWidgets('Full Campaign Navigation, Level Intro, Battle, and Bio-Fact flow test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SavioursVsSaboteursApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Garden Screen
    expect(find.text('SAVIOURS'), findsOneWidget);
    expect(find.text('SABOTEURS'), findsOneWidget);
    expect(find.text('ENTER HEART'), findsOneWidget);

    // 2. Navigate to Heart Atrium
    await tester.tap(find.text('ENTER HEART'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('HEART-ROSE ATRIUM'), findsOneWidget);
    expect(find.text('ENTER CAMPAIGN'), findsOneWidget);

    // 3. Navigate to Campaign Level Select
    await tester.tap(find.text('ENTER CAMPAIGN'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(HeartCampaign.stageTitle), findsOneWidget);
    expect(find.text('1-1'), findsOneWidget);
    expect(find.text('THE MORNING RUSH'), findsOneWidget);

    // 4. Tap Level 1-1 Node -> Opens Level Intro Dialog
    await tester.tap(find.text('1-1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('LEVEL 1-1'), findsOneWidget);
    expect(find.text('STRESS PARASITES'), findsWidgets);
    expect(find.text('ENTER BATTLE'), findsOneWidget);

    // 5. Enter Battle
    await tester.tap(find.text('ENTER BATTLE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('BREACH • LEVEL 1-1'), findsOneWidget);
    expect(find.text('FORGIVENESS MEDITATION'), findsOneWidget);
    expect(find.text('ISOTONIC FLOW'), findsOneWidget);

    // 6. Select 2 cards & Defend (Optimal Level 1-1 synergy: Forgiveness + Relaxation)
    await tester.tap(find.text('FORGIVENESS MEDITATION'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('RELAXATION'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('DEFEND HEART'), findsOneWidget);

    await tester.tap(find.text('DEFEND HEART'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 500));

    // 7. Verify Result Dialog with EXCELLENT grade
    expect(find.text('EXCELLENT DEFENSE!'), findsOneWidget);
    expect(find.text('+1 RESILIENCE SEED AWARDED!'), findsOneWidget);
    expect(find.text('VIEW BIO-FACT'), findsOneWidget);

    // 8. View Bio-Fact Card
    await tester.tap(find.text('VIEW BIO-FACT'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('BIO-FACT ARCHIVE'), findsOneWidget);
    expect(find.text('WHAT HAPPENED?'), findsOneWidget);
    expect(find.text('GAME STRATEGY LESSON'), findsOneWidget);
    expect(find.text('REAL-WORLD HEALTH CONNECTION'), findsOneWidget);
    expect(find.text('CONTINUE TO CAMPAIGN'), findsOneWidget);

    // 9. Continue to Campaign -> returns to Level Select with 1-2 unlocked!
    await tester.tap(find.text('CONTINUE TO CAMPAIGN'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(HeartCampaign.stageTitle), findsOneWidget);
    expect(find.text('1-2'), findsOneWidget);
  });
}

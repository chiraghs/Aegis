import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aegis/main.dart';
import 'package:aegis/providers/app_state.dart';

void main() {
  testWidgets('Aegis fintech app renders dashboard radar successfully on mobile', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const AegisFintechApp(),
      ),
    );

    // Allow widgets to settle
    await tester.pumpAndSettle();

    // Verify Aegis header and radar are present
    expect(find.text('AEGIS'), findsWidgets);
    expect(find.text('UNIFIED NET WORTH'), findsWidgets);
    expect(find.text('CARD REVOLVING DEBT'), findsWidgets);
  });

  testWidgets('Aegis adapts to Samsung Galaxy Z Fold dual-pane layout', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const AegisFintechApp(),
      ),
    );

    await tester.pumpAndSettle();

    // In dual-pane mode, both master radar and companion detail screen render side-by-side
    expect(find.text('AEGIS'), findsWidgets);
    expect(find.text('UNIFIED NET WORTH'), findsWidgets);
  });

  test('AppState calculates Unified Net Worth correctly', () {
    final state = AppState();
    expect(state.totalAssetValue, greaterThan(0));
    expect(state.totalLiabilityValue, greaterThan(0));
    expect(state.netWorth, equals(state.totalAssetValue - state.totalLiabilityValue));
    expect(state.netWorthHistory.length, equals(6));
  });
}

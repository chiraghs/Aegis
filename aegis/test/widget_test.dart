import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aegis/main.dart';
import 'package:aegis/providers/app_state.dart';

void main() {
  testWidgets('Aegis fintech app renders dashboard radar successfully', (WidgetTester tester) async {
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
    expect(find.text('AEGIS'), findsOneWidget);
    expect(find.text('UNIFIED NET WORTH'), findsOneWidget);
    expect(find.text('CARD REVOLVING DEBT'), findsOneWidget);
  });

  test('AppState calculates Unified Net Worth correctly', () {
    final state = AppState();
    expect(state.totalAssetValue, greaterThan(0));
    expect(state.totalLiabilityValue, greaterThan(0));
    expect(state.netWorth, equals(state.totalAssetValue - state.totalLiabilityValue));
    expect(state.netWorthHistory.length, equals(6));
  });
}

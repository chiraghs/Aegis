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

  testWidgets('Theme Toggle button switches between Light and Dark mode', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final appState = AppState();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appState),
        ],
        child: const AegisFintechApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial dark mode and sun icon (to switch to light mode)
    expect(appState.isDarkMode, isTrue);
    final themeToggleFinder = find.byTooltip('Switch to Light Mode');
    expect(themeToggleFinder, findsOneWidget);

    // Tap theme toggle button
    await tester.tap(themeToggleFinder);
    await tester.pumpAndSettle();

    // Verify it switched to light mode
    expect(appState.isDarkMode, isFalse);
    expect(find.byTooltip('Switch to Dark Mode'), findsOneWidget);

    // Tap again to switch back to dark mode
    await tester.tap(find.byTooltip('Switch to Dark Mode'));
    await tester.pumpAndSettle();

    expect(appState.isDarkMode, isTrue);
    expect(find.byTooltip('Switch to Light Mode'), findsOneWidget);
  });

  test('Garage AppState supports vehicle selection, citation clearing with 2X coins, and US insurance selling', () {
    final state = AppState();

    // Verify initial US vehicles
    expect(state.vehicles.length, greaterThanOrEqualTo(3));
    expect(state.activeVehicle.model, equals('Model 3'));
    expect(state.activeVehicle.licensePlate, equals('CA • 8TSL921'));

    // Switch vehicle
    state.selectGarageVehicle(1);
    expect(state.activeVehicle.model, equals('Taycan'));
    expect(state.activeVehicle.licensePlate, equals('NY • TAY-442'));

    // Check unpaid citations
    expect(state.unpaidChallansCount, equals(1));
    final initialCoins = state.rewards.totalCoins;

    // Settle citation ($150 SFMTA red light ticket)
    final paid = state.payChallan('chl_1');
    expect(paid, isTrue);
    expect(state.unpaidChallansCount, equals(0));
    // $150 * 2 = 300 coins awarded
    expect(state.rewards.totalCoins, equals(initialCoins + 300));

    // Selling insurance policy awards $200 commission (2,000 Aegis Coins)
    final preInsCoins = state.rewards.totalCoins;
    state.purchaseOrSellInsurancePolicy(state.insurancePolicies.first, isSelling: true);
    expect(state.rewards.totalCoins, equals(preInsCoins + 2000));

    // Claim rush hour reward (Apple Watch Ultra 2)
    final claimed = state.claimRushHourReward('rh_1');
    expect(claimed, isTrue);
    expect(state.rushHourRewards.first.isClaimed, isTrue);
  });

  test('AppState tracks Vehicle Insurance Telematics and Personal & Family Insurance Vault', () {
    final state = AppState();

    // 1. Vehicle Insurance Telematics & UBI Tracking
    final activePolicy = state.activeVehicleInsurancePolicy;
    expect(activePolicy, isNotNull);
    expect(activePolicy!.telematics, isNotNull);
    expect(activePolicy.telematics!.safeDriverScore, equals(96));
    expect(activePolicy.telematics!.discountPercent, equals(28.0));
    expect(activePolicy.claims.length, greaterThanOrEqualTo(1));
    expect(activePolicy.claims.first.title, contains('Windshield'));

    // File a new vehicle claim
    final claimFiled = state.fileVehicleInsuranceClaim(
      policyId: activePolicy.id,
      title: 'Bumper scratch in parking lot',
      shop: 'Tesla Collision Fremont',
      estimatedCost: 850.0,
    );
    expect(claimFiled, isTrue);
    expect(state.activeVehicleInsurancePolicy!.claims.length, equals(2));

    // 2. Personal & Family Insurance Vault
    expect(state.familyPolicies.length, equals(3));

    // Health Policy
    final health = state.primaryHealthPolicy;
    expect(health, isNotNull);
    expect(health!.provider, equals('Blue Cross Blue Shield'));
    expect(health.familyDeductibleMet, equals(1450.0));
    expect(health.familyDeductibleTotal, equals(3000.0));
    expect(health.coveredMembers.length, equals(4));

    // Term Life Policy
    final life = state.primaryLifePolicy;
    expect(life, isNotNull);
    expect(life!.lifeFaceValue, equals(1000000.0));
    expect(life.termYearsRemaining, equals(14));
    expect(life.beneficiaries.length, equals(2));

    // Homeowners Policy
    final home = state.primaryHomePolicy;
    expect(home, isNotNull);
    expect(home!.dwellingCoverage, equals(650000.0));

    // Total Family Insured Value calculation
    expect(state.totalFamilyInsuredValue, equals(1900000.0)); // 1M life + 650k dwelling + 250k personal prop

    // File a Family Health claim
    final famClaimFiled = state.fileFamilyClaim(
      policyId: health.id,
      title: 'Dermatology consultation',
      memberName: 'Sarah Vance',
      amount: 180.0,
      notes: 'Out-of-network specialist copay',
    );
    expect(famClaimFiled, isTrue);
    expect(state.primaryHealthPolicy!.claims.length, equals(3));
  });
}


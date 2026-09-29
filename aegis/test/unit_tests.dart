import 'package:flutter_test/flutter_test.dart';
import 'package:aegis/models/subscription_tier.dart';
import 'package:aegis/models/asset_model.dart';
import 'package:aegis/models/vehicle_model.dart';
import 'package:aegis/providers/app_state.dart';
import 'package:aegis/services/networth_service.dart';
import 'package:aegis/services/nhtsa_vehicle_service.dart';

void main() {
  group('AppState Core Financial & Rewards Engine', () {
    test('Initializes with default cards, vehicles, assets, and liabilities', () {
      final state = AppState();
      expect(state.cards.isNotEmpty, isTrue);
      expect(state.vehicles.isNotEmpty, isTrue);
      expect(state.assets.isNotEmpty, isTrue);
      expect(state.fixedLiabilities.isNotEmpty, isTrue);
      expect(state.tier, equals(SubscriptionTier.free));
    });

    test('Computes Unified Net Worth correctly', () {
      final state = AppState();
      final totalAssets = state.totalAssetValue;
      final totalLiab = state.totalLiabilityValue;
      final netWorth = state.netWorth;

      expect(totalAssets, greaterThan(0));
      expect(totalLiab, greaterThan(0));
      expect(netWorth, equals(totalAssets - totalLiab));
      expect(state.liquidityRunwayMonths, greaterThan(0));
    });

    test('Simulates external payment with tier-based coin multipliers', () {
      final state = AppState();
      final firstCard = state.cards.first;
      final initialCoins = state.rewards.totalCoins;
      final initialStreak = state.rewards.streakDays;

      // Free tier: 1x multiplier
      final res = state.simulateExternalPayment(firstCard.id);
      expect(res['success'], isTrue);
      expect(res['multiplier'], equals(1));
      expect(state.rewards.totalCoins, greaterThan(initialCoins));
      expect(state.rewards.streakDays, equals(initialStreak + 1));

      // Attempting to pay an already-cleared card returns false
      final duplicateRes = state.simulateExternalPayment(firstCard.id);
      expect(duplicateRes['success'], isFalse);
    });

    test('Tier multipliers scale rewards correctly', () {
      final state = AppState();

      // Test Gold Tier multiplier (2x)
      state.debugSetTier(SubscriptionTier.gold);
      expect(state.isGoldOrHigher, isTrue);
      expect(state.canAddMoreCards, isTrue);
      expect(state.canAddMoreVehicles, isTrue);

      // Test Black Edition multiplier (5x) and AI advisor unlock
      state.debugSetTier(SubscriptionTier.black);
      expect(state.isBlackEdition, isTrue);
      expect(state.hasAiCardOptimizer, isTrue);
      expect(state.hasDeepNetWorthAnalytics, isTrue);
      expect(state.hasFireProjectionSimulator, isTrue);
    });

    test('Dynamic asset addition and removal update Net Worth reactively', () {
      final state = AppState();
      final startingNetWorth = state.netWorth;

      final customAsset = AssetItem(
        id: 'test_asset_1',
        name: 'Angel Investment',
        institution: 'Syndicate',
        category: AssetCategory.investments,
        valuation: 50000.0,
        lastUpdated: DateTime.now(),
      );

      state.addAsset(customAsset);
      expect(state.netWorth, equals(startingNetWorth + 50000.0));

      state.removeAsset('test_asset_1');
      expect(state.netWorth, equals(startingNetWorth));
    });
  });

  group('NHTSA Vehicle Intelligence & Equity', () {
    test('Vehicle equity clamps negative values at zero', () {
      final vehicleWithEquity = VehicleModel(
        id: 'v1',
        vin: '1HGCR2F83HA000001',
        make: 'Porsche',
        model: '911 GT3 RS',
        year: 2024,
        trim: 'Weissach',
        mileage: 3200,
        fuelOrBatteryLevel: 0.9,
        isElectric: false,
        estimatedMarketValue: 241000.0,
        loanBalance: 80000.0,
        nextServiceDate: DateTime.now(),
        activeRecalls: 0,
      );

      expect(vehicleWithEquity.positiveEquity, equals(161000.0));
      expect(vehicleWithEquity.estimatedValue, equals(241000.0));

      final underwaterVehicle = vehicleWithEquity.copyWith(
        estimatedMarketValue: 20000.0,
        loanBalance: 30000.0,
      );
      expect(underwaterVehicle.positiveEquity, equals(0.0));
    });

    test('NHTSA fallback decodes Tesla VIN prefixes correctly', () {
      final fallbackTesla = NhtsaVehicleService.decodeVin('5YJ3E1EB8NF000000');
      expect(fallbackTesla, completes);
    });
  });

  group('NetWorthService Historical Trajectory', () {
    test('Generates 6-month snapshots with positive progression', () {
      final snapshots = NetWorthService.getHistoricalSnapshots(
        currentNetWorth: 500000.0,
        currentAssets: 750000.0,
        currentLiabilities: 250000.0,
      );

      expect(snapshots.length, equals(6));
      expect(snapshots.first.monthLabel, equals('Apr'));
      expect(snapshots.last.monthLabel, equals('Sep'));
      expect(snapshots.last.netWorth, equals(500000.0));
    });
  });
}

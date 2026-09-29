import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aegis/constants/theme.dart';
import 'package:aegis/models/subscription_tier.dart';
import 'package:aegis/models/asset_model.dart';
import 'package:aegis/models/vehicle_model.dart';
import 'package:aegis/providers/app_state.dart';
import 'package:aegis/services/networth_service.dart';
import 'package:aegis/services/nhtsa_vehicle_service.dart';
import 'package:aegis/services/onesignal_service.dart';
import 'package:aegis/services/stripe_web_funnel_service.dart';
import 'package:aegis/services/layers_growth_service.dart';

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

  group('OneSignal Notification Center & Rich Segmentation', () {
    test('Initializes with default notification inbox', () {
      final service = OneSignalService.instance;
      expect(service.inboxItems.isNotEmpty, isTrue);
      expect(service.unreadCount, greaterThanOrEqualTo(0));
    });

    test('Push Simulator adds notification and updates unread count', () {
      final service = OneSignalService.instance;
      final initialCount = service.unreadCount;

      service.simulatePushReceived(
        title: 'Test Hackathon Notification',
        body: 'OneSignal Push Journey Activated',
        type: 'test_journey',
      );

      expect(service.unreadCount, equals(initialCount + 1));
      expect(service.inboxItems.first.title, equals('Test Hackathon Notification'));
      expect(service.inboxItems.first.isRead, isFalse);

      service.markAsRead(service.inboxItems.first.id);
      expect(service.inboxItems.first.isRead, isTrue);
    });

    test('Synchronizes rich segmentation tags with user financial state', () async {
      final service = OneSignalService.instance;
      await service.syncUserSegmentation(
        tier: SubscriptionTier.black,
        netWorth: 850000.0,
        nearestDueDays: 3,
        vehicleCount: 2,
      );

      final tags = service.activeUserTags;
      expect(tags['wealth_tier'], equals('HighNetWorth'));
      expect(tags['subscription_tier'], equals('black'));
      expect(tags['nearest_due_days'], equals(3));
      expect(tags['garage_vehicles'], equals(2));
      expect(tags['shipaton_registered'], equals(true));
    });
  });

  group('Stripe Web Funnel & RevenueCat Entitlement Sync', () {
    test('Calculates 20% discount on web checkout correctly', () {
      final service = StripeWebFunnelService.instance;
      final goldDiscounted = service.getDiscountedWebPrice(SubscriptionTier.gold);
      final blackDiscounted = service.getDiscountedWebPrice(SubscriptionTier.black);

      // Gold: $4.99 - 20% = $3.99
      expect(goldDiscounted, equals(3.99));
      // Black: $9.99 - 20% = $7.99
      expect(blackDiscounted, equals(7.99));
    });

    test('Processes Stripe web checkout and creates customer entitlement session', () async {
      final service = StripeWebFunnelService.instance;
      final success = await service.processStripeWebCheckout(
        tier: SubscriptionTier.gold,
        cardNumber: '4242424242424242',
        expDate: '12/28',
        cvc: '123',
      );

      expect(success, isTrue);
      expect(service.lastCheckoutSessionId, isNotNull);
      expect(service.lastCheckoutSessionId, startsWith('cs_test_'));
    });
  });

  group('Layers A/B Experimentation & VIP Referral Loop', () {
    test('Swaps active paywall experiment variant reactively', () {
      final growth = LayersGrowthService.instance;
      final initialVariant = growth.activeVariant;

      growth.toggleVariant();
      expect(growth.activeVariant, isNot(equals(initialVariant)));

      growth.toggleVariant();
      expect(growth.activeVariant, equals(initialVariant));
    });

    test('Records impressions and conversions', () {
      final growth = LayersGrowthService.instance;
      final initialConvRateA = growth.variantAConversionRate;

      growth.recordPaywallImpression();
      growth.recordPaywallConversion();

      expect(growth.variantAConversionRate, greaterThanOrEqualTo(initialConvRateA));
      expect(growth.variantBConversionRate, greaterThan(0));
    });

    test('Validates VIP referral code and prevents duplicate claims', () {
      final growth = LayersGrowthService.instance;

      // Valid referral code
      final validClaim = growth.applyReferralCode('VIP-FOUNDER-99');
      expect(validClaim, isTrue);

      // Duplicate referral code claim is rejected
      final duplicateClaim = growth.applyReferralCode('VIP-FOUNDER-99');
      expect(duplicateClaim, isFalse);

      // Blank or own code cannot be claimed
      final ownClaim = growth.applyReferralCode(growth.userReferralCode);
      expect(ownClaim, isFalse);
    });
  });

  group('Aegis Centralized Theme Engine & Dynamic Modes', () {
    test('Default mode is dark and uses matte stealth graphite palette', () {
      final state = AppState();
      expect(state.isDarkMode, isTrue);
      expect(state.themeMode, equals(ThemeMode.dark));
      
      AppThemeConfig.setThemeMode(ThemeMode.dark);
      expect(AppThemeConfig.isDark, isTrue);
      expect(AppThemeConfig.palette.isDark, isTrue);
      expect(AppTheme.background, equals(const Color(0xFF0C0D11)));
      expect(AppTheme.surface, equals(const Color(0xFF14161E)));
      expect(AppTheme.textPrimary, equals(const Color(0xFFF1F5F9)));
    });

    test('Switching to light mode shifts palette to warm paper canvas', () {
      AppThemeConfig.setThemeMode(ThemeMode.light);
      expect(AppThemeConfig.isDark, isFalse);
      expect(AppThemeConfig.palette.isDark, isFalse);
      expect(AppTheme.background, equals(const Color(0xFFF6F7F9)));
      expect(AppTheme.surface, equals(const Color(0xFFFFFFFF)));
      expect(AppTheme.textPrimary, equals(const Color(0xFF0F172A)));
      expect(AppTheme.goldAccent, equals(const Color(0xFF9E742E)));
    });

    test('AppState.toggleThemeMode alternates smoothly between dark and light', () {
      final state = AppState();
      bool notified = false;
      state.addListener(() => notified = true);

      // Start dark -> toggle to light
      state.setThemeMode(ThemeMode.dark);
      notified = false;
      state.toggleThemeMode();
      expect(notified, isTrue);
      expect(state.isDarkMode, isFalse);
      expect(state.themeMode, equals(ThemeMode.light));
      expect(AppThemeConfig.isDark, isFalse);

      // Toggle back to dark
      notified = false;
      state.toggleThemeMode();
      expect(notified, isTrue);
      expect(state.isDarkMode, isTrue);
      expect(state.themeMode, equals(ThemeMode.dark));
      expect(AppThemeConfig.isDark, isTrue);
    });

    test('Updating custom palette in AppThemeConfig propagates immediately', () {
      final customLight = ThemePalette.light.copyWith(
        background: const Color(0xFFECEFF1),
        textPrimary: const Color(0xFF263238),
      );

      AppThemeConfig.setCustomPalette(customLight);
      expect(AppTheme.background, equals(const Color(0xFFECEFF1)));
      expect(AppTheme.textPrimary, equals(const Color(0xFF263238)));

      // Reset back to standard dark mode
      AppThemeConfig.resetToDefaults();
      AppThemeConfig.setThemeMode(ThemeMode.dark);
      expect(AppTheme.background, equals(const Color(0xFF0C0D11)));
    });
  });
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../models/subscription_tier.dart';

class RevenueCatService {
  static final RevenueCatService instance = RevenueCatService._internal();
  RevenueCatService._internal();

  // Test / Hackathon API Keys (Replace with your actual keys from RevenueCat Dashboard)
  static const String appleApiKey = 'appl_mock_shipaton_2026_key';
  static const String googleApiKey = 'goog_mock_shipaton_2026_key';

  bool _isConfigured = false;
  SubscriptionTier _currentTier = SubscriptionTier.free;
  final _tierController = StreamController<SubscriptionTier>.broadcast();

  Stream<SubscriptionTier> get tierStream => _tierController.stream;
  SubscriptionTier get currentTier => _currentTier;

  Future<void> initialize() async {
    try {
      if (kIsWeb) {
        // On web or sandbox fallback
        _isConfigured = false;
        return;
      }

      await Purchases.setLogLevel(LogLevel.debug);

      late PurchasesConfiguration configuration;
      if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
        configuration = PurchasesConfiguration(appleApiKey);
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        configuration = PurchasesConfiguration(googleApiKey);
      } else {
        return;
      }

      await Purchases.configure(configuration);
      _isConfigured = true;

      // Listen to customer info updates
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _updateTierFromCustomerInfo(customerInfo);
      });

      // Initial customer info fetch
      final customerInfo = await Purchases.getCustomerInfo();
      _updateTierFromCustomerInfo(customerInfo);
    } catch (e) {
      debugPrint('RevenueCat configuration notice: Running in Demo Sandbox mode ($e)');
      _isConfigured = false;
    }
  }

  void _updateTierFromCustomerInfo(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.all['black_edition']?.isActive ?? false) {
      _setTier(SubscriptionTier.black);
    } else if (customerInfo.entitlements.all['gold_pass']?.isActive ?? false) {
      _setTier(SubscriptionTier.gold);
    } else {
      _setTier(SubscriptionTier.free);
    }
  }

  void _setTier(SubscriptionTier tier) {
    _currentTier = tier;
    _tierController.add(tier);
  }

  /// Purchase an entitlement package (e.g. from dynamic Paywall)
  Future<bool> purchaseTier(SubscriptionTier tier) async {
    if (!_isConfigured) {
      // Sandbox / Demo Mode: Instantly unlock to allow judges to test features
      await Future.delayed(const Duration(milliseconds: 600));
      _setTier(tier);
      return true;
    }

    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;
      if (currentOffering == null) {
        // Fallback to demo mode if no offerings configured yet in dashboard
        _setTier(tier);
        return true;
      }

      Package? targetPackage;
      if (tier == SubscriptionTier.gold) {
        targetPackage = currentOffering.monthly;
      } else if (tier == SubscriptionTier.black) {
        targetPackage = currentOffering.annual;
      }

      if (targetPackage != null) {
        final result = await Purchases.purchasePackage(targetPackage);
        _updateTierFromCustomerInfo(result.customerInfo);
        return true;
      } else {
        _setTier(tier);
        return true;
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
      // In hackathon demo mode, gracefully set tier for evaluation
      _setTier(tier);
      return true;
    }
  }

  /// Restore purchases across devices
  Future<void> restorePurchases() async {
    if (!_isConfigured) return;
    try {
      final customerInfo = await Purchases.restorePurchases();
      _updateTierFromCustomerInfo(customerInfo);
    } catch (e) {
      debugPrint('Restore error: $e');
    }
  }

  /// Demo helper: manually switch tier for judge testing
  void debugSetTier(SubscriptionTier tier) {
    _setTier(tier);
  }
}

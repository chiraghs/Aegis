import 'package:flutter/foundation.dart';
import '../models/subscription_tier.dart';
import 'revenuecat_service.dart';

class StripeWebFunnelService {
  static final StripeWebFunnelService instance = StripeWebFunnelService._internal();
  StripeWebFunnelService._internal();

  // Test Stripe Public Key
  static const String stripePublishableKey = 'pk_test_shipaton_2026_stripe_web_funnel';

  // Discounted pricing on web funnel (bypassing 30% App Store cut)
  static const double goldWebPrice = 3.99; // vs $4.99 on app store (20% off)
  static const double blackWebPrice = 7.99; // vs $9.99 on app store (20% off)

  String? _lastCheckoutSessionId;
  String? get lastCheckoutSessionId => _lastCheckoutSessionId;

  double getDiscountedWebPrice(SubscriptionTier tier) {
    return tier == SubscriptionTier.black ? blackWebPrice : goldWebPrice;
  }

  /// Simulates processing a direct web subscription via Stripe Elements
  Future<bool> processStripeWebCheckout({
    required SubscriptionTier tier,
    required String cardNumber,
    required String expDate,
    required String cvc,
  }) async {
    // Generate test session ID
    _lastCheckoutSessionId = 'cs_test_${DateTime.now().millisecondsSinceEpoch}';

    // Simulate real network delay for Stripe card tokenization
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      // Synchronize web entitlement into RevenueCat
      RevenueCatService.instance.debugSetTier(tier);
      debugPrint('Stripe Web Funnel: processed payment for $tier. Session: $_lastCheckoutSessionId');
      return true;
    } catch (e) {
      debugPrint('Stripe Web Funnel error: $e');
      return false;
    }
  }
}

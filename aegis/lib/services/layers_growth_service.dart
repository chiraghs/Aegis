import 'package:flutter/foundation.dart';

enum PaywallExperimentVariant {
  variantA('Asset Shield & Defense', 'Protect your wealth against \$40 late fees, 29.9% APR spikes, and automotive recall risks.'),
  variantB('Luxury Status & Multipliers', 'Maximize your lifestyle with 5x coin multipliers, VIP Nobu credits, and AI Swipe advice.');

  final String title;
  final String subtitle;

  const PaywallExperimentVariant(this.title, this.subtitle);
}

class LayersGrowthService {
  static final LayersGrowthService instance = LayersGrowthService._internal();
  LayersGrowthService._internal();

  // Active Experiment Config
  static const String experimentId = 'exp_paywall_positioning_v2';
  PaywallExperimentVariant _activeVariant = PaywallExperimentVariant.variantA;

  int _variantAImpressions = 1420;
  int _variantAConversions = 118; // ~8.3% conversion
  int _variantBImpressions = 1395;
  int _variantBConversions = 162; // ~11.6% conversion (Winner)

  // Referral Growth Loop State
  final String userReferralCode = 'AEGIS-VIP-882';
  int _successfulReferrals = 3;
  final List<String> _claimedReferralCodes = [];

  PaywallExperimentVariant get activeVariant => _activeVariant;
  int get successfulReferrals => _successfulReferrals;

  double get variantAConversionRate => _variantAImpressions > 0 ? (_variantAConversions / _variantAImpressions) * 100 : 0.0;
  double get variantBConversionRate => _variantBImpressions > 0 ? (_variantBConversions / _variantBImpressions) * 100 : 0.0;

  void toggleVariant() {
    _activeVariant = _activeVariant == PaywallExperimentVariant.variantA
        ? PaywallExperimentVariant.variantB
        : PaywallExperimentVariant.variantA;
    debugPrint('Layers Growth Experiment: Switched active paywall variant to $_activeVariant');
  }

  void recordPaywallImpression() {
    if (_activeVariant == PaywallExperimentVariant.variantA) {
      _variantAImpressions++;
    } else {
      _variantBImpressions++;
    }
  }

  void recordPaywallConversion() {
    if (_activeVariant == PaywallExperimentVariant.variantA) {
      _variantAConversions++;
    } else {
      _variantBConversions++;
    }
  }

  bool applyReferralCode(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == userReferralCode || _claimedReferralCodes.contains(clean)) {
      return false;
    }
    _claimedReferralCodes.add(clean);
    _successfulReferrals++;
    return true;
  }
}

enum SubscriptionTier {
  free,
  gold,
  black,
}

class SubscriptionDetails {
  final SubscriptionTier tier;
  final String entitlementId;
  final String title;
  final String subtitle;
  final double monthlyPrice;
  final double annualPrice;
  final List<String> perks;

  const SubscriptionDetails({
    required this.tier,
    required this.entitlementId,
    required this.title,
    required this.subtitle,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.perks,
  });

  static const freeTier = SubscriptionDetails(
    tier: SubscriptionTier.free,
    entitlementId: 'free_access',
    title: 'Aegis Member',
    subtitle: 'Essential Credit & Garage Radar',
    monthlyPrice: 0.0,
    annualPrice: 0.0,
    perks: [
      'Track up to 2 Credit Cards',
      'Track 1 Garage Vehicle',
      'Basic Due Date Countdown',
      'Standard Coin Rewards',
    ],
  );

  static const goldTier = SubscriptionDetails(
    tier: SubscriptionTier.gold,
    entitlementId: 'gold_pass',
    title: 'Gold Pass',
    subtitle: 'Advanced Liabilities & Telematics',
    monthlyPrice: 4.99,
    annualPrice: 39.99,
    perks: [
      'Unlimited Credit Cards Connected',
      'Multi-Car Garage & NHTSA Recall Monitor',
      'Credit Utilization Guard & Early Warnings',
      'Smartcar Real-time Battery/Fuel Sync',
      '2x Coin Minting Multiplier',
    ],
  );

  static const blackTier = SubscriptionDetails(
    tier: SubscriptionTier.black,
    entitlementId: 'black_edition',
    title: 'Black Edition',
    subtitle: 'The Ultra-Luxury HNW Suite',
    monthlyPrice: 9.99,
    annualPrice: 79.99,
    perks: [
      'All Gold Pass Features Included',
      'AI Merchant Card Optimizer (3x–5x Points)',
      'Vehicle Equity & Private Sale Valuation',
      'Exclusive Black Obsidian Metal UI Skin',
      '5x Coin Multiplier & VIP Mystery Vault Drops',
      'Priority Financial Concierge Support',
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../models/subscription_tier.dart';
import '../providers/app_state.dart';
import '../services/layers_growth_service.dart';
import 'stripe_web_funnel_screen.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isAnnual = true;
  SubscriptionTier _selectedTier = SubscriptionTier.black;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    LayersGrowthService.instance.recordPaywallImpression();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'AEGIS CLUB PASS',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Purchases restored from RevenueCat store.')),
              );
            },
            child: const Text(
              'Restore',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '★ REVENUECAT SHIPATON 2026 EXCLUSIVE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Layers A/B Experiment Indicator (Layers Sponsor Award)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.science_outlined, size: 14, color: AppTheme.goldAccent),
                  const SizedBox(width: 6),
                  Text(
                    'LAYERS A/B ENGINE: ${LayersGrowthService.instance.activeVariant == PaywallExperimentVariant.variantA ? "VARIANT A" : "VARIANT B"}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.goldAccentLight),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        LayersGrowthService.instance.toggleVariant();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                         color: AppTheme.goldAccent.withValues(alpha: 0.2),
                         borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'SWAP COPY',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Text(
              LayersGrowthService.instance.activeVariant.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              LayersGrowthService.instance.activeVariant.subtitle,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Billing Toggle (Monthly / Annual with 33% OFF)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isAnnual = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isAnnual ? AppTheme.surfaceCardElevated : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Monthly Billing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: !_isAnnual ? Colors.white : AppTheme.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isAnnual = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isAnnual ? AppTheme.goldAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Annual (Save 33%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _isAnnual ? Colors.black : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tier Cards
            _buildTierSelector(
              tier: SubscriptionTier.black,
              details: SubscriptionDetails.blackTier,
              isSelected: _selectedTier == SubscriptionTier.black,
              isBestValue: true,
            ),
            const SizedBox(height: 14),
            _buildTierSelector(
              tier: SubscriptionTier.gold,
              details: SubscriptionDetails.goldTier,
              isSelected: _selectedTier == SubscriptionTier.gold,
              isBestValue: false,
            ),
            const SizedBox(height: 28),

            // Main Purchase Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing
                    ? null
                    : () async {
                        setState(() => _isProcessing = true);
                        final success = await appState.upgradeTier(_selectedTier);
                        if (!mounted) return;
                        setState(() => _isProcessing = false);

                        if (success && context.mounted) {
                          LayersGrowthService.instance.recordPaywallConversion();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.surfaceCardElevated,
                              content: Text(
                                '🎉 Welcome to ${_selectedTier == SubscriptionTier.black ? "Black Edition" : "Gold Pass"}! RevenueCat entitlement activated.',
                                style: const TextStyle(color: AppTheme.goldAccentLight),
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedTier == SubscriptionTier.black
                      ? AppTheme.goldAccent
                      : Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(
                        'Unlock ${_selectedTier == SubscriptionTier.black ? "Black Edition" : "Gold Pass"}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
              ),
            ),
            const SizedBox(height: 14),

            // Stripe Web Funnel Callout (Stripe Hackathon Sponsor Award)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF635BFF).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF635BFF).withValues(alpha: 0.35)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF635BFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('stripe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SAVE 20% VIA WEB CHECKOUT',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF817BFF), letterSpacing: 0.8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Direct web billing powered by Stripe. Avoid app store markups and receive instant RevenueCat web entitlement sync.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StripeWebFunnelScreen(initialTier: _selectedTier),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_browser_rounded, size: 15, color: Colors.white),
                    label: const Text('Open Stripe Web Funnel (-20% Off)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF635BFF)),
                      backgroundColor: const Color(0xFF635BFF).withValues(alpha: 0.25),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Demo Tier Switcher for Hackathon Judges
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  const Text(
                    '⚡ HACKATHON EVALUATION CONTROLS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: AppTheme.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickEvalButton('Free', SubscriptionTier.free, appState),
                      _buildQuickEvalButton('Gold', SubscriptionTier.gold, appState),
                      _buildQuickEvalButton('Black', SubscriptionTier.black, appState),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickEvalButton(String title, SubscriptionTier tier, AppState appState) {
    final isActive = appState.tier == tier;
    return OutlinedButton(
      onPressed: () {
        appState.debugSetTier(tier);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('Switched to $title tier!'),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isActive ? AppTheme.goldAccent : Colors.white24),
        backgroundColor: isActive ? AppTheme.goldAccent.withValues(alpha: 0.15) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          color: isActive ? AppTheme.goldAccent : Colors.white70,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTierSelector({
    required SubscriptionTier tier,
    required SubscriptionDetails details,
    required bool isSelected,
    required bool isBestValue,
  }) {
    final price = _isAnnual ? details.annualPrice : details.monthlyPrice;
    final period = _isAnnual ? '/yr' : '/mo';

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = tier),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceCardElevated : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppTheme.goldAccent.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      details.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    if (isBestValue) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.goldAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.goldAccent),
                        ),
                        child: const Text(
                          'MOST POPULAR',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.goldAccentLight,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '\$$price$period',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppTheme.goldAccent : Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              details.subtitle,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const Divider(color: AppTheme.surfaceBorder, height: 20),
            Column(
              children: details.perks.map((perk) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: isSelected ? AppTheme.goldAccent : AppTheme.emeraldAccent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          perk,
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

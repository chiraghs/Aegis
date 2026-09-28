import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/reward_model.dart';
import '../providers/app_state.dart';
import '../widgets/glass_container.dart';
import 'paywall_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final List<RewardPerk> _catalog = const [
    RewardPerk(
      id: 'perk_apple_25',
      title: '\$25 Apple Store Card',
      partner: 'Apple',
      description: 'Applicable to App Store, Apple Music, or hardware purchases.',
      costInCoins: 2500,
      category: PerkCategory.tech,
      iconCode: 'apple',
      isExclusiveBlackTier: false,
    ),
    RewardPerk(
      id: 'perk_uber_black',
      title: '50% Off Uber Black Ride',
      partner: 'Uber Luxury',
      description: 'Valid for high-end airport transit in major metropolitan areas.',
      costInCoins: 1800,
      category: PerkCategory.travel,
      iconCode: 'directions_car',
      isExclusiveBlackTier: false,
    ),
    RewardPerk(
      id: 'perk_equinox_pass',
      title: 'Equinox VIP Guest Pass',
      partner: 'Equinox Fitness Club',
      description: 'Complimentary full-day access to tier-3 fitness clubs and spa facilities.',
      costInCoins: 4000,
      category: PerkCategory.lifestyle,
      iconCode: 'fitness_center',
      isExclusiveBlackTier: true,
    ),
    RewardPerk(
      id: 'perk_nobu_voucher',
      title: '\$100 Dining Credit',
      partner: 'Nobu Worldwide',
      description: 'Exclusive chef omakase tasting credit.',
      costInCoins: 8500,
      category: PerkCategory.dining,
      iconCode: 'restaurant',
      isExclusiveBlackTier: true,
    ),
  ];

  void _openMysteryVault(BuildContext context, AppState appState) {
    final randomBonus = (Random().nextInt(3) + 1) * 250;
    appState.addBonusCoins(randomBonus);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCardElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('🎉 MYSTERY VAULT OPENED!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.goldAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars_rounded, size: 48, color: AppTheme.goldAccent),
            const SizedBox(height: 12),
            Text(
              'You unlocked +$randomBonus Bonus Aegis Coins for maintaining your on-time credit streak!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CLAIM COINS', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _handleClaimPerk(BuildContext context, RewardPerk perk, AppState appState) {
    if (perk.isExclusiveBlackTier && !appState.isBlackEdition) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceCardElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('BLACK EDITION EXCLUSIVE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
          content: Text(
            '${perk.title} is reserved for Black Edition members.\n\nUpgrade your tier via RevenueCat to claim ultra-luxury rewards drops.',
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PaywallScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldAccent, foregroundColor: Colors.black),
              child: const Text('Upgrade Tier', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );
      return;
    }

    final success = appState.claimPerk(perk);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Claimed ${perk.title}! Voucher voucher code sent.'),
          backgroundColor: AppTheme.surfaceCardElevated,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient coin balance to claim this perk.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currency = NumberFormat.simpleCurrency();
    final formatter = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'REWARDS & VAULT',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Coin & Streak Header
            GlassContainer(
              backgroundColor: AppTheme.surfaceCardElevated,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AEGIS COINS BALANCE',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.goldGradient),
                                child: const Icon(Icons.monetization_on, size: 20, color: Colors.black),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatter.format(appState.rewards.totalCoins),
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${appState.rewards.streakDays}x Streak',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppTheme.surfaceBorder, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Cleared: ${currency.format(appState.rewards.totalDebtCleared)}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _openMysteryVault(context, appState),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.goldAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.card_giftcard, size: 14),
                        label: const Text('Mystery Box', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Perks Catalog Title
            const Text(
              'CURATED PERKS & DROPS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),

            // Perks List
            Column(
              children: _catalog.map((perk) {
                final isClaimed = appState.rewards.claimedPerkIds.contains(perk.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GlassContainer(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: perk.isExclusiveBlackTier ? AppTheme.goldAccent.withOpacity(0.15) : AppTheme.surfaceCardElevated,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: perk.isExclusiveBlackTier ? AppTheme.goldAccent : AppTheme.surfaceBorder,
                            ),
                          ),
                          child: Icon(
                            perk.isExclusiveBlackTier ? Icons.workspace_premium : Icons.redeem,
                            color: perk.isExclusiveBlackTier ? AppTheme.goldAccent : Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      perk.title,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (perk.isExclusiveBlackTier)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.goldAccent.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'BLACK',
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.goldAccentLight),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                perk.partner,
                                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${formatter.format(perk.costInCoins)} Coins',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.goldAccent),
                                  ),
                                  ElevatedButton(
                                    onPressed: isClaimed ? null : () => _handleClaimPerk(context, perk, appState),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isClaimed ? Colors.grey : Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      minimumSize: Size.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text(
                                      isClaimed ? 'Claimed' : 'Redeem',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

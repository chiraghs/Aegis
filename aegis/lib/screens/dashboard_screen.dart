import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';
import '../widgets/coin_counter.dart';
import '../widgets/glass_container.dart';
import '../widgets/asset_allocation_bar.dart';
import '../widgets/personal_family_insurance_card.dart';
import '../services/onesignal_service.dart';
import '../models/subscription_tier.dart';
import '../widgets/aegis_logo.dart';
import 'paywall_screen.dart';
import 'networth_detail_screen.dart';
import 'notifications_inbox_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const DashboardScreen({super.key, required this.onNavigateToTab});

  void _showPaymentRewardDialog(BuildContext context, Map<String, dynamic> result) {
    final currency = NumberFormat.simpleCurrency();
    final cleared = result['clearedAmount'] as double;
    final coins = result['coins'] as int;
    final multiplier = result['multiplier'] as int;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCardElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.verified_rounded, color: AppTheme.emeraldAccent, size: 28),
            const SizedBox(width: 10),
            const Text(
              'EXTERNAL PAY VERIFIED',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plaid detected that your bank bill of ${currency.format(cleared)} was cleared externally.',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Coins Minted:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Text(
                        '+$coins Coins',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.goldAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${multiplier}x Tier)',
                        style: TextStyle(fontSize: 11, color: AppTheme.goldAccentLight),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('AWESOME', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _showAiSwipeAdvisor(BuildContext context, AppState appState) {
    if (!appState.hasAiCardOptimizer) {
      // Trigger Paywall for Black Edition feature
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PaywallScreen()),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.goldGradient,
                  ),
                  child: const Icon(Icons.auto_awesome, size: 18, color: Colors.black),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AI CARD SWIPE ADVISOR',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Real-Time Merchant Optimization (Black Edition)',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            _buildAdvisorRecommendation('Dining / Restaurants', 'American Express Gold', '4X MR Points (8% effective return)'),
            _buildAdvisorRecommendation('Airlines & Hotels', 'Chase Sapphire Reserve', '3X Points + Trip Delay & Rental CDW'),
            _buildAdvisorRecommendation('General Retail', 'Capital One Venture X', '2X Catch-All Miles on every dollar'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisorRecommendation(String category, String bestCard, String benefit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCardElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(benefit, style: TextStyle(fontSize: 11, color: AppTheme.goldAccentLight)),
            ],
          ),
          Text(bestCard, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currency = NumberFormat.simpleCurrency();
    final nearest = appState.nearestDueCard;

    return Scaffold(
      backgroundColor: AppTheme.background,
       appBar: AppBar(
        titleSpacing: 12,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AegisLogo(size: 24, borderRadius: 6),
            const SizedBox(width: 6),
            Text(
              'AEGIS',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PaywallScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF86EA45), Color(0xFF7DE43A)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7DE43A).withValues(alpha: 0.35),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium, size: 12, color: Color(0xFF1E2818)),
                    const SizedBox(width: 3),
                    Text(
                      appState.isBlackEdition ? 'BLACK' : (appState.tier == SubscriptionTier.gold ? 'GOLD' : 'UPGRADE'),
                      style: const TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Color(0xFF1E2818),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          CoinCounter(
            coins: appState.rewards.totalCoins,
            tier: appState.tier,
            onTap: () => onNavigateToTab(3), // Navigate to Rewards
          ),
          ListenableBuilder(
            listenable: OneSignalService.instance,
            builder: (context, _) {
              final unread = OneSignalService.instance.unreadCount;
              return IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(),
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text('$unread', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  backgroundColor: AppTheme.crimsonAccent,
                  child: Icon(Icons.notifications_none_rounded, color: AppTheme.textPrimary, size: 20),
                ),
                tooltip: 'OneSignal Push Center',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NotificationsInboxScreen()),
                  );
                },
              );
            },
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
            icon: Icon(Icons.settings_outlined, color: AppTheme.textPrimary, size: 21),
            tooltip: 'Profile & Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Due Date Urgent Radar Banner
            if (nearest != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.crimsonAccent.withValues(alpha: 0.15), AppTheme.surfaceCard],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.crimsonAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.crimsonAccent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.timer_outlined, size: 20, color: AppTheme.crimsonAccent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEXT PAYMENT DUE IN ${nearest.daysUntilDue} DAYS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              color: AppTheme.crimsonAccent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${nearest.cardName} • ${currency.format(nearest.statementBalance)}',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final res = appState.simulateExternalPayment(nearest.id);
                        if (res['success'] == true) {
                          _showPaymentRewardDialog(context, res);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.crimsonAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Mark Paid', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),

            // Unified Net Worth Hero Radar Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NetWorthDetailScreen()),
                  );
                },
                child: GlassContainer(
                  borderColor: AppTheme.emeraldAccent.withValues(alpha: 0.35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shield, size: 14, color: AppTheme.emeraldAccent),
                              const SizedBox(width: 6),
                              Text(
                                'UNIFIED NET WORTH',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.trending_up, size: 12, color: AppTheme.emeraldAccent),
                                const SizedBox(width: 3),
                                Text(
                                  '+${appState.monthlyNetWorthChangePercent.toStringAsFixed(1)}% mo',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.emeraldAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                currency.format(appState.netWorth),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Text(
                                'Deep Dive',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.goldAccent,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.goldAccent),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AssetAllocationBar(appState: appState),
                      const SizedBox(height: 12),
                      // Breakdown row: Debt / Limit / Utilization
                      Row(
                        children: [
                          Expanded(
                            child: _buildNetworthStat(
                              label: 'Card Debt',
                              value: '-${currency.format(appState.totalCurrentBalance)}',
                              valueColor: AppTheme.crimsonAccent,
                            ),
                          ),
                          Container(width: 1, height: 28, color: AppTheme.surfaceBorder),
                          Expanded(
                            child: _buildNetworthStat(
                              label: 'Credit Limit',
                              value: currency.format(appState.totalCreditLimit),
                              valueColor: AppTheme.textPrimary,
                            ),
                          ),
                          Container(width: 1, height: 28, color: AppTheme.surfaceBorder),
                          Expanded(
                            child: _buildNetworthStat(
                              label: 'Utilization',
                              value: '${(appState.overallUtilization * 100).toStringAsFixed(1)}%',
                              valueColor: appState.overallUtilization > 0.3
                                  ? AppTheme.crimsonAccent
                                  : AppTheme.emeraldAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // AI Advisor action pill (full width — Garage/Cards via bottom nav)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton.icon(
                onPressed: () => _showAiSwipeAdvisor(context, appState),
                icon: Icon(Icons.auto_awesome, size: 14, color: AppTheme.goldAccent),
                label: Text(
                  appState.hasAiCardOptimizer ? 'AI Swipe Advisor' : 'Unlock AI Advisor 🔒',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.surfaceBorder),
                  backgroundColor: AppTheme.surfaceCard,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            // Personal & Family Insurance Vault Card
            PersonalFamilyInsuranceCard(appState: appState),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworthStat({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

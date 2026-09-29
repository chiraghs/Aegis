import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';
import '../widgets/credit_card_widget.dart';
import '../widgets/coin_counter.dart';
import '../widgets/glass_container.dart';
import '../widgets/asset_allocation_bar.dart';
import '../widgets/referral_growth_loop_widget.dart';
import '../widgets/viral_shield_story_card.dart';
import '../services/onesignal_service.dart';
import 'paywall_screen.dart';
import 'networth_detail_screen.dart';
import 'notifications_inbox_screen.dart';

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
        title: const Row(
          children: [
            Icon(Icons.verified_rounded, color: AppTheme.emeraldAccent, size: 28),
            SizedBox(width: 10),
            Text(
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
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.goldAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${multiplier}x Tier)',
                        style: const TextStyle(fontSize: 11, color: AppTheme.goldAccentLight),
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
            child: const Text('AWESOME', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.w800)),
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
                  decoration: const BoxDecoration(
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
            const Text(
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
              Text(category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 2),
              Text(benefit, style: const TextStyle(fontSize: 11, color: AppTheme.goldAccentLight)),
            ],
          ),
          Text(bestCard, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.goldGradient,
                ),
                child: const Center(
                  child: Text('Æ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'AEGIS',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
            ],
          ),
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
                  child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 4),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.ios_share_rounded, color: AppTheme.cyanAccent, size: 19),
            tooltip: 'Flex Shield Story',
            onPressed: () => ViralShieldStoryModal.show(context, appState),
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.workspace_premium, color: AppTheme.goldAccent, size: 20),
            tooltip: 'Aegis Club Pass',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PaywallScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
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
                      child: const Icon(Icons.timer_outlined, size: 20, color: AppTheme.crimsonAccent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEXT PAYMENT DUE IN ${nearest.daysUntilDue} DAYS',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              color: AppTheme.crimsonAccent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${nearest.cardName} • ${currency.format(nearest.statementBalance)}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
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
                          const Row(
                            children: [
                              Icon(Icons.shield, size: 14, color: AppTheme.emeraldAccent),
                              SizedBox(width: 6),
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
                                const Icon(Icons.trending_up, size: 12, color: AppTheme.emeraldAccent),
                                const SizedBox(width: 3),
                                Text(
                                  '+${appState.monthlyNetWorthChangePercent.toStringAsFixed(1)}% mo',
                                  style: const TextStyle(
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
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Row(
                            children: [
                              Text(
                                'Deep Dive',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.goldAccent,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.goldAccent),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AssetAllocationBar(appState: appState),
                    ],
                  ),
                ),
              ),
            ),

            // Revolving Credit Health Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: GlassContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CARD REVOLVING DEBT',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currency.format(appState.totalCurrentBalance),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total Limit: ${currency.format(appState.totalCreditLimit)}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'UTILIZATION',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(appState.overallUtilization * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: appState.overallUtilization > 0.3
                                ? AppTheme.crimsonAccent
                                : AppTheme.emeraldAccent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appState.overallUtilization < 0.1 ? 'Excellent (<10%)' : 'Good Standing',
                          style: const TextStyle(fontSize: 11, color: AppTheme.emeraldAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Action Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showAiSwipeAdvisor(context, appState),
                      icon: const Icon(Icons.auto_awesome, size: 14, color: AppTheme.goldAccent),
                      label: Text(
                        appState.hasAiCardOptimizer ? 'AI Swipe Advisor' : 'Unlock AI Advisor 🔒',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.surfaceBorder),
                        backgroundColor: AppTheme.surfaceCard,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => onNavigateToTab(2), // Garage
                      icon: const Icon(Icons.directions_car, size: 14, color: AppTheme.cyanAccent),
                      label: const Text(
                        'View Garage',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.surfaceBorder),
                        backgroundColor: AppTheme.surfaceCard,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // VIP Referral Growth Loop (Layers Hackathon Sponsor Award)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ReferralGrowthLoopWidget(appState: appState),
            ),

            // Card Stack Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PORTFOLIO CARDS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppTheme.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => onNavigateToTab(1),
                    child: const Text(
                      'Manage All →',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.goldAccent),
                    ),
                  ),
                ],
              ),
            ),

            // Cards List
            Column(
              children: appState.cards.map((card) {
                return CreditCardWidget(
                  card: card,
                  onSimulatePayment: () {
                    final res = appState.simulateExternalPayment(card.id);
                    if (res['success'] == true) {
                      _showPaymentRewardDialog(context, res);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

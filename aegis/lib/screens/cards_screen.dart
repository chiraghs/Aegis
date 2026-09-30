import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../models/credit_card_model.dart';
import '../providers/app_state.dart';
import '../widgets/credit_card_widget.dart';
import 'paywall_screen.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  // 0: Total Due (Cards Deck/Feed), 1: Recent Spends
  int _selectedTopTab = 0;
  // Active selected card index in the deck
  int _activeCardIndex = 0;
  // Toggle between Stacked Deck and Expanded Scroll Feed
  bool _isStackedMode = true;
  // Expand statement breakdown in header
  bool _isBreakdownExpanded = false;

  void _handleAddCard(BuildContext context, AppState appState) {
    if (!appState.canAddMoreCards) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceCardElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'CARD LIMIT REACHED',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          content: Text(
            'Aegis Member (Free) tier is limited to 2 credit cards.\n\nUpgrade to Gold Pass or Black Edition with RevenueCat to connect unlimited credit accounts.',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PaywallScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Upgrade Pass', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );
      return;
    }

    final newCard = CreditCardModel(
      id: 'card_apple_${DateTime.now().millisecondsSinceEpoch}',
      cardName: 'Apple Card Titanium',
      issuer: 'Goldman Sachs',
      network: CardNetwork.mastercard,
      lastFour: '4419',
      currentBalance: 420.0,
      creditLimit: 12000.0,
      statementBalance: 420.0,
      minimumDue: 25.0,
      dueDate: DateTime.now().add(const Duration(days: 22)),
      apr: 18.24,
      topPerks: ['3% Daily Cash Apple', '2% with Apple Pay', 'No Foreign Fees'],
      themePreset: CardThemePreset.appleTitanium,
      isPaidThisCycle: false,
      transactions: [
        CardTransaction(
          id: 'tx_ap_1',
          merchant: 'Apple Services & iCloud',
          category: 'Digital Goods',
          amount: 9.99,
          date: DateTime.now().subtract(const Duration(days: 2)),
          cashBackOrReward: '+\$0.30 (3%)',
          icon: Icons.apple_rounded,
        ),
      ],
    );

    appState.cards.add(newCard);
    setState(() {
      _activeCardIndex = appState.cards.length - 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connected Apple Card Titanium!')),
    );
  }

  void _showSmartStatement(BuildContext context, CreditCardModel card) {
    final currency = NumberFormat.simpleCurrency();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMART STATEMENT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.goldAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.cardName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'OCT 2026 CYCLE',
                    style: TextStyle(color: AppTheme.emeraldAccent, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatTile('Statement Balance', currency.format(card.statementBalance)),
                _buildStatTile('Minimum Due', currency.format(card.minimumDue)),
                _buildStatTile('APR Saved', '\$142.80'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'SPENDING BREAKDOWN',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 10),
            _buildCategoryRow('Travel & Flights', '\$642.80', 0.52, AppTheme.goldAccent),
            const SizedBox(height: 8),
            _buildCategoryRow('Dining & Groceries', '\$429.70', 0.35, AppTheme.emeraldAccent),
            const SizedBox(height: 8),
            _buildCategoryRow('Rideshare & Transit', '\$68.20', 0.13, Colors.blueAccent),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Official PDF statement downloaded to Files.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Download Official PDF', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentHistory(BuildContext context, CreditCardModel card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'PAYMENT HISTORY',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.goldAccent, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text('Settled Statements for •• ${card.lastFour}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            const Divider(color: Colors.white12, height: 28),
            _buildHistoryItem('Sep 18, 2026', '\$2,840.10', 'CONF-99214-US', true),
            _buildHistoryItem('Aug 19, 2026', '\$3,110.00', 'CONF-88123-US', true),
            _buildHistoryItem('Jul 18, 2026', '\$1,940.50', 'CONF-77641-US', true),
          ],
        ),
      ),
    );
  }

  void _showCardPerks(BuildContext context, CreditCardModel card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'EXCLUSIVE PERKS & APR',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.goldAccent, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text(card.cardName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            const Divider(color: Colors.white12, height: 28),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Standard Purchase APR', style: TextStyle(color: Colors.white, fontSize: 13)),
                  Text('${card.apr}%', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.w800, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...card.topPerks.map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: AppTheme.emeraldAccent, size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(p, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showRecentSpendsModal(BuildContext context, CreditCardModel card) {
    final currency = NumberFormat.simpleCurrency();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'LIVE MERCHANT FEED',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.goldAccent, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text('Recent Spends for ${card.issuer}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            const Divider(color: Colors.white12, height: 28),
            Expanded(
              child: card.transactions.isEmpty
                  ? Center(child: Text('No recent transactions.', style: TextStyle(color: AppTheme.textSecondary)))
                  : ListView.separated(
                      itemCount: card.transactions.length,
                      separatorBuilder: (_, _) => const Divider(color: Colors.white10),
                      itemBuilder: (context, idx) {
                        final tx = card.transactions[idx];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(tx.icon, color: Colors.white, size: 20),
                          ),
                          title: Text(tx.merchant, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                          subtitle: Text(
                            '${tx.category} • ${DateFormat('MMM d').format(tx.date)}',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(currency.format(tx.amount), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(tx.cashBackOrReward, style: TextStyle(color: AppTheme.emeraldAccent, fontWeight: FontWeight.w600, fontSize: 10)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context, CreditCardModel card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'CARD MANAGEMENT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.goldAccent, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text('•• ${card.lastFour} Settings', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            const Divider(color: Colors.white12, height: 28),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline_rounded, color: Colors.white),
              title: const Text('Freeze / Lock Card', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text('Instantly blocks new card-not-present charges', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              trailing: Switch(value: false, onChanged: (v) {}),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.autorenew_rounded, color: Colors.white),
              title: const Text('Autopay Full Balance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text('Auto-debited on due date from primary checking', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              trailing: Switch(value: true, onChanged: (v) {}),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
              title: const Text('Concierge & Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text('Direct US VIP line for cardholders', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              onTap: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connected to VIP Cardholder Concierge.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetailsModal(BuildContext context, CreditCardModel card) {
    final currency = NumberFormat.simpleCurrency();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.issuer.toUpperCase(), style: TextStyle(color: AppTheme.goldAccent, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                    Text(card.cardName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                Text('•• ${card.lastFour}', style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2)),
              ],
            ),
            const Divider(color: Colors.white12, height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatTile('Credit Limit', currency.format(card.creditLimit)),
                _buildStatTile('Current Balance', currency.format(card.currentBalance)),
                _buildStatTile('Utilization', '${(card.utilizationRate * 100).toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: card.utilizationRate,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  card.utilizationRate > 0.3 ? AppTheme.crimsonAccent : AppTheme.emeraldAccent,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 24),
            Text('REWARD MULTIPLIERS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            ...card.topPerks.map((perk) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: AppTheme.goldAccent),
                      const SizedBox(width: 8),
                      Expanded(child: Text(perk, style: const TextStyle(color: Colors.white, fontSize: 13))),
                    ],
                  ),
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close Details', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPayAllDialog(BuildContext context, AppState appState) {
    final currency = NumberFormat.simpleCurrency();
    final unpaidCards = appState.cards.where((c) => !c.isPaidThisCycle).toList();
    final totalDue = unpaidCards.fold(0.0, (acc, c) => acc + c.statementBalance);

    if (unpaidCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All credit cards are already paid this cycle!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCardElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.orange, size: 22),
            const SizedBox(width: 8),
            const Text('SETTLE ALL STATEMENTS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clear total statement balance across ${unpaidCards.length} cards:\n',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            Text(
              currency.format(totalDue),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              '• Chase ACH Clearinghouse auto-connects\n• Avoids ~\$142.80 in revolving interest\n• Earns +250 Aegis Shield Coins',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              for (final c in unpaidCards) {
                appState.simulateExternalPayment(c.id);
              }
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All ${unpaidCards.length} cards settled! +250 Aegis Coins minted.'),
                  backgroundColor: AppTheme.surfaceCardElevated,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text('Confirm Settle', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
      ],
    );
  }

  Widget _buildCategoryRow(String title, String amount, double ratio, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            Text(amount, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String date, String amount, String ref, bool isSettled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              Text(ref, style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
            ],
          ),
          Row(
            children: [
              Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(width: 8),
              Icon(Icons.check_circle_rounded, color: AppTheme.emeraldAccent, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  LinearGradient _getMiniChipGradient(CardThemePreset preset) {
    switch (preset) {
      case CardThemePreset.amexGold:
        return const LinearGradient(colors: [Color(0xFFC6923C), Color(0xFF9E7124)]);
      case CardThemePreset.chaseSapphire:
        return const LinearGradient(colors: [Color(0xFF0F326E), Color(0xFF1B4E9B)]);
      case CardThemePreset.ventureX:
        return const LinearGradient(colors: [Color(0xFF1B2E4B), Color(0xFF2A4365)]);
      case CardThemePreset.appleTitanium:
        return const LinearGradient(colors: [Color(0xFF2B2D30), Color(0xFF141517)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currency = NumberFormat.simpleCurrency();
    final cards = appState.cards;

    if (_activeCardIndex >= cards.length) {
      _activeCardIndex = (cards.length - 1).clamp(0, 999);
    }

    final unpaidCards = cards.where((c) => !c.isPaidThisCycle).toList();
    final totalDue = unpaidCards.fold(0.0, (acc, c) => acc + c.statementBalance);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0E14),
      body: SafeArea(
        child: Column(
          children: [
            // Top Nav Header: % button, [ TOTAL DUE | RECENT SPENDS ], Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular % Button
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Aegis Cash Back Engine: 1.5% auto-yield on all payments.')),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.percent_rounded, size: 18, color: Colors.white),
                    ),
                  ),

                  // Segmented Switch Pill
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TOTAL DUE Tab
                        GestureDetector(
                          onTap: () => setState(() => _selectedTopTab = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: _selectedTopTab == 0 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'TOTAL DUE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedTopTab == 0 ? Colors.black : Colors.white60,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                if (unpaidCards.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE53E3E),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${unpaidCards.length}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // RECENT SPENDS Tab
                        GestureDetector(
                          onTap: () => setState(() => _selectedTopTab = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: _selectedTopTab == 1 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'RECENT SPENDS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: _selectedTopTab == 1 ? Colors.black : Colors.white60,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings Gear
                  InkWell(
                    onTap: () => _handleAddCard(context, appState),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.settings_outlined, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Main Body: Either Cards Deck or Recent Spends Feed
            Expanded(
              child: _selectedTopTab == 0
                  ? _buildCardsDeckView(context, appState, cards, unpaidCards, totalDue, currency)
                  : _buildUnifiedSpendsFeed(context, cards, currency),
            ),

            // Pinned Bottom Card Selector Dock (matching reference dock)
            _buildBottomDock(context, appState, cards),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsDeckView(
    BuildContext context,
    AppState appState,
    List<CreditCardModel> cards,
    List<CreditCardModel> unpaidCards,
    double totalDue,
    NumberFormat currency,
  ) {
    if (cards.isEmpty) {
      return Center(
        child: Text(
          'No credit cards connected.\nTap + to link an account.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
        ),
      );
    }

    final activeCard = cards[_activeCardIndex];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Total Statement Due Headline
          Text(
            'STATEMENT DUE FOR ${unpaidCards.length} ${unpaidCards.length == 1 ? 'CARD' : 'CARDS'}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 4),

          // Large Balance with Dropdown Chevron
          GestureDetector(
            onTap: () => setState(() => _isBreakdownExpanded = !_isBreakdownExpanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currency.format(totalDue),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  _isBreakdownExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white60,
                  size: 24,
                ),
              ],
            ),
          ),

          // Animated Dropdown Breakdown
          if (_isBreakdownExpanded) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: cards.map((c) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${c.issuer} (•• ${c.lastFour})',
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                        ),
                        Text(
                          c.isPaidThisCycle ? 'Paid' : currency.format(c.statementBalance),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: c.isPaidThisCycle ? AppTheme.emeraldAccent : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Black Pill "Pay bill" / "Pay all bills" Button
          ElevatedButton(
            onPressed: () => _showPayAllDialog(context, appState),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text(
              'Pay all bills',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ),

          const SizedBox(height: 14),

          // Incentive / Rewards Pill Banner matching reference
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6AD55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt, size: 12, color: Colors.black),
                ),
                const SizedBox(width: 8),
                Text(
                  'pay bills & unlock 2% auto-cashback.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded, size: 16, color: Colors.white60),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Staggered Stack vs Scroll Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isStackedMode ? 'CARD DECK (SWIPE LEFT FOR ACTIONS)' : 'ALL CARDS FEED',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isStackedMode = !_isStackedMode),
                  child: Row(
                    children: [
                      Icon(
                        _isStackedMode ? Icons.view_agenda_outlined : Icons.layers_outlined,
                        size: 14,
                        color: AppTheme.goldAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isStackedMode ? 'Expand Feed' : 'Stack Deck',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.goldAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Cards Display (Stacked Mode or Expanded Feed)
          if (_isStackedMode) ...[
            // Active Front Card
            CreditCardWidget(
              card: activeCard,
              onSimulatePayment: () {
                final res = appState.simulateExternalPayment(activeCard.id);
                if (res['success'] == true) {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment cleared! Minted ${res['coins']} coins.')),
                  );
                }
              },
              onPayNow: () {
                final res = appState.simulateExternalPayment(activeCard.id);
                if (res['success'] == true) {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment cleared! Minted ${res['coins']} coins.')),
                  );
                }
              },
              onMarkAsPaid: () {
                final res = appState.simulateExternalPayment(activeCard.id);
                if (res['success'] == true) {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Marked as paid! Minted ${res['coins']} coins.')),
                  );
                }
              },
              onSmartStatement: () => _showSmartStatement(context, activeCard),
              onPaymentHistory: () => _showPaymentHistory(context, activeCard),
              onCardPerks: () => _showCardPerks(context, activeCard),
              onRecentSpends: () => _showRecentSpendsModal(context, activeCard),
              onMoreActions: () => _showMoreActions(context, activeCard),
              onViewDetails: () => _showCardDetailsModal(context, activeCard),
            ),

            // Pill "View details >" under active card
            InkWell(
              onTap: () => _showCardDetailsModal(context, activeCard),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View details',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Peeking Cards Behind in the Deck (matching cards landing.jpeg)
            ...cards.asMap().entries.where((e) => e.key != _activeCardIndex).map((entry) {
              final index = entry.key;
              final c = entry.value;

              return GestureDetector(
                onTap: () => setState(() => _activeCardIndex = index),
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: _getMiniChipGradient(c.themePreset),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.credit_card, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            c.issuer.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '•• ${c.lastFour}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (c.isPaidThisCycle) ...[
                            const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF68D391)),
                            const SizedBox(width: 4),
                            Text(
                              currency.format(c.statementBalance),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ] else ...[
                            Text(
                              currency.format(c.statementBalance),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          Icon(Icons.unfold_more_rounded, size: 16, color: Colors.white.withValues(alpha: 0.6)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ] else ...[
            // Expanded Vertical Feed Mode (matching Cards scroll.jpeg)
            ...cards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;

              return Column(
                children: [
                  CreditCardWidget(
                    card: card,
                    onSimulatePayment: () {
                      final res = appState.simulateExternalPayment(card.id);
                      if (res['success'] == true) {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment cleared! Minted ${res['coins']} coins.')),
                        );
                      }
                    },
                    onPayNow: () {
                      final res = appState.simulateExternalPayment(card.id);
                      if (res['success'] == true) {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment cleared! Minted ${res['coins']} coins.')),
                        );
                      }
                    },
                    onMarkAsPaid: () {
                      final res = appState.simulateExternalPayment(card.id);
                      if (res['success'] == true) {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Marked as paid! Minted ${res['coins']} coins.')),
                        );
                      }
                    },
                    onSmartStatement: () => _showSmartStatement(context, card),
                    onPaymentHistory: () => _showPaymentHistory(context, card),
                    onCardPerks: () => _showCardPerks(context, card),
                    onRecentSpends: () => _showRecentSpendsModal(context, card),
                    onMoreActions: () => _showMoreActions(context, card),
                    onViewDetails: () => _showCardDetailsModal(context, card),
                  ),

                  // Pill "View details >"
                  InkWell(
                    onTap: () => _showCardDetailsModal(context, card),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View details',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Pending Action Alert Pill between cards (matching Cards scroll.jpeg)
                  if (index < cards.length - 1) ...[
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE53E3E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.priority_high_rounded, size: 10, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '1 pending action: Autopay due in ${card.daysUntilDue} days',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded, size: 16, color: Colors.white60),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              );
            }),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildUnifiedSpendsFeed(
    BuildContext context,
    List<CreditCardModel> cards,
    NumberFormat currency,
  ) {
    final allTransactions = <Map<String, dynamic>>[];
    for (final c in cards) {
      for (final tx in c.transactions) {
        allTransactions.add({
          'card': c,
          'tx': tx,
        });
      }
    }

    allTransactions.sort((a, b) => (b['tx'] as CardTransaction).date.compareTo((a['tx'] as CardTransaction).date));

    if (allTransactions.isEmpty) {
      return Center(
        child: Text(
          'No recent transactions tracked.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: allTransactions.length,
      separatorBuilder: (_, _) => const Divider(color: Colors.white10),
      itemBuilder: (context, idx) {
        final item = allTransactions[idx];
        final card = item['card'] as CreditCardModel;
        final tx = item['tx'] as CardTransaction;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Icon(tx.icon, color: Colors.white, size: 22),
          ),
          title: Text(
            tx.merchant,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          subtitle: Text(
            '${card.issuer} (•• ${card.lastFour}) • ${DateFormat('MMM d').format(tx.date)}',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currency.format(tx.amount),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                tx.cashBackOrReward,
                style: TextStyle(color: AppTheme.emeraldAccent, fontWeight: FontWeight.w700, fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomDock(BuildContext context, AppState appState, List<CreditCardModel> cards) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F121A),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ALL (N) with Active Indicator
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ALL (${cards.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 24,
                height: 2.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          // Mini Card Thumbnails (Chips)
          Row(
            children: cards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;
              final isSelected = index == _activeCardIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeCardIndex = index;
                    _selectedTopTab = 0;
                  });
                },
                child: Container(
                  width: 44,
                  height: 28,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: _getMiniChipGradient(card.themePreset),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white24,
                      width: isSelected ? 1.8 : 0.8,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.3),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      card.lastFour,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Quick Add Card Button
          InkWell(
            onTap: () => _handleAddCard(context, appState),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 34,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white30, width: 1),
                color: Colors.white.withValues(alpha: 0.05),
              ),
              child: const Icon(Icons.add, size: 18, color: Colors.white),
            ),
          ),

          // FICO Credit Shield / Security Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF68D391),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  '780 FICO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


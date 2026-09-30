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

  // Recent Spends Filters
  final TextEditingController _searchController = TextEditingController();
  String _cardFilter = 'ALL';
  String _categoryFilter = 'ALL';
  String _rangeFilter = 'ALL'; // 'ALL', '7D', '30D', '90D'
  String _typeFilter = 'ALL'; // 'ALL', 'DEBIT', 'CREDIT', 'REWARD'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
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
                  color: AppTheme.surfaceBorder,
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
                        color: AppTheme.textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.cardName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AegisCloudPalette.mintGreen.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'OCT 2026 CYCLE',
                    style: TextStyle(color: Color(0xFF1E2818), fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            Divider(color: AppTheme.surfaceBorder, height: 32),
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
            _buildCategoryRow('Travel & Flights', '\$642.80', 0.52, const Color(0xFF0F326E)),
            const SizedBox(height: 8),
            _buildCategoryRow('Dining & Groceries', '\$429.70', 0.35, AegisCloudPalette.mintGreen),
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
                  backgroundColor: AppTheme.surfaceCardElevated,
                  foregroundColor: AppTheme.textPrimary,
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
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'PAYMENT HISTORY',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text('Settled Statements for •• ${card.lastFour}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            Divider(color: AppTheme.surfaceBorder, height: 28),
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
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'EXCLUSIVE PERKS & APR',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text(card.cardName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            Divider(color: AppTheme.surfaceBorder, height: 28),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Standard Purchase APR', style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('${card.apr}%', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...card.topPerks.map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(p, style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
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
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'LIVE MERCHANT FEED',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text('Recent Spends for ${card.issuer}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            Divider(color: AppTheme.surfaceBorder, height: 28),
            Expanded(
              child: card.transactions.isEmpty
                  ? Center(child: Text('No recent transactions.', style: TextStyle(color: AppTheme.textSecondary)))
                  : ListView.separated(
                      itemCount: card.transactions.length,
                      separatorBuilder: (_, _) => Divider(color: AppTheme.surfaceBorder),
                      itemBuilder: (context, idx) {
                        final tx = card.transactions[idx];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.surfaceBorder),
                            ),
                            child: Icon(tx.icon, color: AppTheme.textPrimary, size: 20),
                          ),
                          title: Text(tx.merchant, style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                          subtitle: Text(
                            '${tx.category} • ${DateFormat('MMM d').format(tx.date)}',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(currency.format(tx.amount), style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(tx.cashBackOrReward, style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w700, fontSize: 10)),
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
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'CARD MANAGEMENT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.5),
            ),
            const SizedBox(height: 4),
            Text('•• ${card.lastFour} Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            Divider(color: AppTheme.surfaceBorder, height: 28),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.lock_outline_rounded, color: AppTheme.textPrimary),
              title: Text('Freeze / Lock Card', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: Text('Instantly blocks new card-not-present charges', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              trailing: Switch(
                value: false,
                onChanged: (v) {},
                activeTrackColor: AegisCloudPalette.mintGreen,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.autorenew_rounded, color: AppTheme.textPrimary),
              title: Text('Autopay Full Balance', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
              subtitle: Text('Auto-debited on due date from primary checking', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              trailing: Switch(
                value: true,
                onChanged: (v) {},
                activeTrackColor: AegisCloudPalette.mintGreen,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone_in_talk_rounded, color: AppTheme.textPrimary),
              title: Text('Concierge & Support', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
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
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.issuer.toUpperCase(), style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                    Text(card.cardName, style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                Text('•• ${card.lastFour}', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2)),
              ],
            ),
            Divider(color: AppTheme.surfaceBorder, height: 28),
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
                backgroundColor: AppTheme.background,
                valueColor: AlwaysStoppedAnimation<Color>(
                  card.utilizationRate > 0.3 ? AppTheme.crimsonAccent : AegisCloudPalette.mintGreen,
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
                      const Icon(Icons.star_rounded, size: 16, color: AegisCloudPalette.mintGreen),
                      const SizedBox(width: 8),
                      Expanded(child: Text(perk, style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
                    ],
                  ),
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceCardElevated,
                  foregroundColor: AppTheme.textPrimary,
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
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.bolt, color: AegisCloudPalette.mintGreen, size: 22),
            SizedBox(width: 8),
            Text(
              'SETTLE ALL STATEMENTS',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1, color: AppTheme.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clear total statement balance across all cards:\n',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            Text(
              currency.format(totalDue),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
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
              backgroundColor: AppTheme.surfaceCardElevated,
              foregroundColor: AppTheme.textPrimary,
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
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildCategoryRow(String title, String amount, double ratio, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
            Text(amount, style: TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: AppTheme.background,
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
              Text(date, style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
              Text(ref, style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
            ],
          ),
          Row(
            children: [
              Text(amount, style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 16),
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
      case CardThemePreset.mintGreen:
        return const LinearGradient(colors: [Color(0xFF8AEF47), Color(0xFF7DE43A)]);
      case CardThemePreset.charcoal:
        return const LinearGradient(colors: [Color(0xFF383838), Color(0xFF2B2B2B)]);
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
      backgroundColor: AppTheme.background,
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
                        const SnackBar(content: Text('Aegis Cash Back Engine: Auto-yield rewards on all card bill payments.')),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surface,
                        border: Border.all(color: AppTheme.surfaceBorder, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.percent_rounded, size: 18, color: AppTheme.textPrimary),
                    ),
                  ),

                  // Segmented Switch Pill
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBorder,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.surfaceBorder),
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
                              color: _selectedTopTab == 0 ? AppTheme.surface : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: _selectedTopTab == 0
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'TOTAL DUE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedTopTab == 0 ? AppTheme.textPrimary : AppTheme.textSecondary,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                if (unpaidCards.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AegisCloudPalette.mintGreen,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${unpaidCards.length}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1E2818),
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
                              color: _selectedTopTab == 1 ? AppTheme.surface : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: _selectedTopTab == 1
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              'RECENT SPENDS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: _selectedTopTab == 1 ? AppTheme.textPrimary : AppTheme.textSecondary,
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
                        color: AppTheme.surface,
                        border: Border.all(color: AppTheme.surfaceBorder, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.settings_outlined, size: 18, color: AppTheme.textPrimary),
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
              color: AppTheme.textSecondary,
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
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  _isBreakdownExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.textSecondary,
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
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surfaceBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                          style: TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          c.isPaidThisCycle ? 'Paid' : currency.format(c.statementBalance),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: c.isPaidThisCycle ? const Color(0xFF2E7D32) : AppTheme.textPrimary,
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

          // Solid Charcoal Pill "Pay bills" Button matching reference
          ElevatedButton(
            onPressed: () => _showPayAllDialog(context, appState),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.surfaceCardElevated,
              foregroundColor: AppTheme.textPrimary,
              elevation: 3,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text(
              'Pay bills',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ),

          const SizedBox(height: 14),

          // Incentive / Rewards Pill Banner matching reference
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AegisCloudPalette.mintGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt, size: 12, color: Color(0xFF1E2818)),
                ),
                const SizedBox(width: 8),
                Text(
                  'pay bills & earn rewards',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right_rounded, size: 16, color: AppTheme.textSecondary),
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
                        color: AppTheme.textPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isStackedMode ? 'Expand Feed' : 'Stack Deck',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View details',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppTheme.textSecondary,
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
              final isMint = c.themePreset == CardThemePreset.mintGreen;
              final chipTextColor = isMint ? const Color(0xFF1E2818) : Colors.white;

              return GestureDetector(
                onTap: () => setState(() => _activeCardIndex = index),
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: _getMiniChipGradient(c.themePreset),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isMint ? Colors.black.withValues(alpha: 0.12) : Colors.white24,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card, size: 16, color: chipTextColor),
                          const SizedBox(width: 8),
                          Text(
                            c.issuer.toUpperCase(),
                            style: TextStyle(
                              color: chipTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '•• ${c.lastFour}',
                            style: TextStyle(
                              color: chipTextColor.withValues(alpha: 0.75),
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (c.isPaidThisCycle) ...[
                            Icon(Icons.check_circle_rounded, size: 14, color: isMint ? const Color(0xFF1E2818) : const Color(0xFF68D391)),
                            const SizedBox(width: 4),
                            Text(
                              currency.format(c.statementBalance),
                              style: TextStyle(
                                color: chipTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ] else ...[
                            Text(
                              currency.format(c.statementBalance),
                              style: TextStyle(
                                color: chipTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          Icon(Icons.unfold_more_rounded, size: 16, color: chipTextColor.withValues(alpha: 0.7)),
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
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View details',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppTheme.textSecondary,
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
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.surfaceBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.chevron_right_rounded, size: 16, color: AppTheme.textSecondary),
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

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.textPrimary : AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AppTheme.textPrimary : AppTheme.surfaceBorder,
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isActive ? AegisCloudPalette.mintGreen : AppTheme.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? AppTheme.surface : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: isActive ? Colors.white70 : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showCardFilterSheet(BuildContext context, List<CreditCardModel> cards) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'FILTER BY CARD',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.credit_card_rounded, color: AppTheme.textPrimary),
              title: Text('All Connected Cards', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
              trailing: _cardFilter == 'ALL' ? const Icon(Icons.check_circle_rounded, color: AegisCloudPalette.mintGreen) : null,
              onTap: () {
                setState(() => _cardFilter = 'ALL');
                Navigator.of(ctx).pop();
              },
            ),
            Divider(color: AppTheme.surfaceBorder, height: 1),
            ...cards.map((card) {
              final isSelected = _cardFilter == card.id;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 32,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: _getMiniChipGradient(card.themePreset),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(card.cardName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary)),
                subtitle: Text('${card.issuer} •• ${card.lastFour}', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AegisCloudPalette.mintGreen) : null,
                onTap: () {
                  setState(() => _cardFilter = card.id);
                  Navigator.of(ctx).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilterSheet(BuildContext context, List<String> categories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'FILTER BY CATEGORY',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.category_rounded, color: AppTheme.textPrimary),
              title: Text('All Categories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
              trailing: _categoryFilter == 'ALL' ? const Icon(Icons.check_circle_rounded, color: AegisCloudPalette.mintGreen) : null,
              onTap: () {
                setState(() => _categoryFilter = 'ALL');
                Navigator.of(ctx).pop();
              },
            ),
            Divider(color: AppTheme.surfaceBorder, height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, _) => Divider(color: AppTheme.surfaceBorder, height: 1),
                itemBuilder: (context, idx) {
                  final cat = categories[idx];
                  final isSelected = _categoryFilter == cat;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(cat, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textPrimary)),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AegisCloudPalette.mintGreen) : null,
                    onTap: () {
                      setState(() => _categoryFilter = cat);
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRangeFilterSheet(BuildContext context) {
    final ranges = [
      {'key': 'ALL', 'label': 'All Time', 'sub': 'All recorded transactions'},
      {'key': '7D', 'label': 'Past 7 Days', 'sub': 'Last 1 week activity'},
      {'key': '30D', 'label': 'Past 30 Days', 'sub': 'Current billing cycle'},
      {'key': '90D', 'label': 'Past 90 Days', 'sub': 'Quarterly spend history'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'FILTER BY DATE RANGE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            ...ranges.map((r) {
              final isSelected = _rangeFilter == r['key'];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(r['label']!, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
                subtitle: Text(r['sub']!, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AegisCloudPalette.mintGreen) : null,
                onTap: () {
                  setState(() => _rangeFilter = r['key']!);
                  Navigator.of(ctx).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showTypeFilterSheet(BuildContext context) {
    final types = [
      {'key': 'ALL', 'label': 'All Types', 'icon': Icons.swap_vert_rounded, 'sub': 'Purchases, refunds & rewards'},
      {'key': 'DEBIT', 'label': 'Debits (Purchases)', 'icon': Icons.arrow_outward_rounded, 'sub': 'Card swipes and charges'},
      {'key': 'CREDIT', 'label': 'Credits (Refunds)', 'icon': Icons.replay_rounded, 'sub': 'Merchant returns and credits'},
      {'key': 'REWARD', 'label': 'Rewards & Cash Back', 'icon': Icons.bolt_rounded, 'sub': 'Aegis yield and bonus points'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.surfaceBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'FILTER BY TRANSACTION TYPE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            ...types.map((t) {
              final isSelected = _typeFilter == t['key'];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(t['icon'] as IconData, color: AppTheme.textPrimary),
                title: Text(t['label'] as String, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
                subtitle: Text(t['sub'] as String, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AegisCloudPalette.mintGreen) : null,
                onTap: () {
                  setState(() => _typeFilter = t['key'] as String);
                  Navigator.of(ctx).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildUnifiedSpendsFeed(
    BuildContext context,
    List<CreditCardModel> cards,
    NumberFormat currency,
  ) {
    // 1. Collect all transactions with their originating card
    final rawTransactions = <Map<String, dynamic>>[];
    final categoriesSet = <String>{};

    for (final c in cards) {
      for (final tx in c.transactions) {
        rawTransactions.add({
          'card': c,
          'tx': tx,
        });
        if (tx.category.isNotEmpty) {
          categoriesSet.add(tx.category);
        }
      }
    }

    final categoriesList = categoriesSet.toList()..sort();
    final searchQuery = _searchController.text.trim().toLowerCase();

    // 2. Apply filters: Card, Category, Date Range, Type, and Search query
    final now = DateTime.now();
    final filteredTransactions = rawTransactions.where((item) {
      final card = item['card'] as CreditCardModel;
      final tx = item['tx'] as CardTransaction;

      // Card filter
      if (_cardFilter != 'ALL' && card.id != _cardFilter) {
        return false;
      }

      // Category filter
      if (_categoryFilter != 'ALL' && tx.category != _categoryFilter) {
        return false;
      }

      // Date Range filter
      if (_rangeFilter == '7D' && tx.date.isBefore(now.subtract(const Duration(days: 7)))) {
        return false;
      } else if (_rangeFilter == '30D' && tx.date.isBefore(now.subtract(const Duration(days: 30)))) {
        return false;
      } else if (_rangeFilter == '90D' && tx.date.isBefore(now.subtract(const Duration(days: 90)))) {
        return false;
      }

      // Type filter
      if (_typeFilter == 'DEBIT' && tx.type != 'debit') {
        return false;
      } else if (_typeFilter == 'CREDIT' && tx.type != 'credit') {
        return false;
      } else if (_typeFilter == 'REWARD' && tx.type != 'reward') {
        return false;
      }

      // Search option
      if (searchQuery.isNotEmpty) {
        final matchMerchant = tx.merchant.toLowerCase().contains(searchQuery);
        final matchCat = tx.category.toLowerCase().contains(searchQuery);
        final matchAmount = tx.amount.abs().toString().contains(searchQuery);
        final matchIssuer = card.issuer.toLowerCase().contains(searchQuery);
        final matchCardName = card.cardName.toLowerCase().contains(searchQuery);
        if (!matchMerchant && !matchCat && !matchAmount && !matchIssuer && !matchCardName) {
          return false;
        }
      }

      return true;
    }).toList();

    filteredTransactions.sort((a, b) => (b['tx'] as CardTransaction).date.compareTo((a['tx'] as CardTransaction).date));

    final isAnyFilterActive = _cardFilter != 'ALL' ||
        _categoryFilter != 'ALL' ||
        _rangeFilter != 'ALL' ||
        _typeFilter != 'ALL' ||
        searchQuery.isNotEmpty;

    // Selected labels for chips
    String selectedCardLabel = 'Cards: All';
    if (_cardFilter != 'ALL') {
      final matched = cards.where((c) => c.id == _cardFilter).toList();
      selectedCardLabel = matched.isNotEmpty ? matched.first.issuer : '1 Card';
    }

    String selectedRangeLabel = 'Range: All';
    if (_rangeFilter == '7D') selectedRangeLabel = 'Range: 7D';
    if (_rangeFilter == '30D') selectedRangeLabel = 'Range: 30D';
    if (_rangeFilter == '90D') selectedRangeLabel = 'Range: 90D';

    String selectedTypeLabel = 'Type: All';
    if (_typeFilter == 'DEBIT') selectedTypeLabel = 'Type: Debits';
    if (_typeFilter == 'CREDIT') selectedTypeLabel = 'Type: Credits';
    if (_typeFilter == 'REWARD') selectedTypeLabel = 'Type: Rewards';

    String selectedCatLabel = _categoryFilter == 'ALL' ? 'Category: All' : _categoryFilter;
    if (selectedCatLabel.length > 18) {
      selectedCatLabel = '${selectedCatLabel.substring(0, 16)}...';
    }

    final totalSpend = filteredTransactions.fold(0.0, (acc, item) {
      final tx = item['tx'] as CardTransaction;
      return acc + (tx.type == 'debit' ? tx.amount : 0.0);
    });

    return Column(
      children: [
        // 1. Search Box
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppTheme.surfaceBorder, width: 1.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Search merchant, category, amount...',
                hintStyle: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppTheme.textPrimary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close_rounded, size: 16, color: AppTheme.textPrimary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),

        // 2. Top-Level Filter Row: Cards, Category, Range(date), Type, + Reset
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              // Cards Filter
              _buildFilterChip(
                icon: Icons.credit_card_rounded,
                label: selectedCardLabel,
                isActive: _cardFilter != 'ALL',
                onTap: () => _showCardFilterSheet(context, cards),
              ),

              // Category Filter
              _buildFilterChip(
                icon: Icons.category_outlined,
                label: selectedCatLabel,
                isActive: _categoryFilter != 'ALL',
                onTap: () => _showCategoryFilterSheet(context, categoriesList),
              ),

              // Range (Date) Filter
              _buildFilterChip(
                icon: Icons.calendar_today_rounded,
                label: selectedRangeLabel,
                isActive: _rangeFilter != 'ALL',
                onTap: () => _showRangeFilterSheet(context),
              ),

              // Type Filter
              _buildFilterChip(
                icon: Icons.swap_vert_rounded,
                label: selectedTypeLabel,
                isActive: _typeFilter != 'ALL',
                onTap: () => _showTypeFilterSheet(context),
              ),

              // Reset Button
              if (isAnyFilterActive)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _cardFilter = 'ALL';
                      _categoryFilter = 'ALL';
                      _rangeFilter = 'ALL';
                      _typeFilter = 'ALL';
                      _searchController.clear();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: AegisCloudPalette.mintGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AegisCloudPalette.mintGreen),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restart_alt_rounded, size: 14, color: Color(0xFF1E2818)),
                        SizedBox(width: 4),
                        Text(
                          'Reset',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1E2818)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 3. Status Count & Total
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredTransactions.length} ${filteredTransactions.length == 1 ? 'TRANSACTION' : 'TRANSACTIONS'}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              if (filteredTransactions.isNotEmpty)
                Text(
                  'Total Spend: ${currency.format(totalSpend)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
            ],
          ),
        ),

        Divider(color: AppTheme.surfaceBorder, height: 10),

        // 4. Transactions List or Empty State
        Expanded(
          child: filteredTransactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: Icon(Icons.search_off_rounded, size: 28, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No transactions match your filters.',
                        style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try searching for another merchant or resetting filters.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _cardFilter = 'ALL';
                            _categoryFilter = 'ALL';
                            _rangeFilter = 'ALL';
                            _typeFilter = 'ALL';
                            _searchController.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.surfaceCardElevated,
                          foregroundColor: AppTheme.textPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Reset All Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredTransactions.length,
                  separatorBuilder: (_, _) => Divider(color: AppTheme.surfaceBorder),
                  itemBuilder: (context, idx) {
                    final item = filteredTransactions[idx];
                    final card = item['card'] as CreditCardModel;
                    final tx = item['tx'] as CardTransaction;
                    final isCredit = tx.type == 'credit';
                    final isReward = tx.type == 'reward';

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isReward
                              ? AegisCloudPalette.mintGreen.withValues(alpha: 0.2)
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isReward ? AegisCloudPalette.mintGreen : AppTheme.surfaceBorder,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          tx.icon,
                          color: isReward
                              ? const Color(0xFF1E2818)
                              : (isCredit ? const Color(0xFF2E7D32) : AppTheme.textPrimary),
                          size: 22,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              tx.merchant,
                              style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCredit || isReward) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: isReward
                                    ? AegisCloudPalette.mintGreen
                                    : const Color(0xFF2E7D32).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isReward ? 'REWARD' : 'CREDIT',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: isReward ? const Color(0xFF1E2818) : const Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '${card.issuer} (•• ${card.lastFour}) • ${DateFormat('MMM d').format(tx.date)} • ${tx.category}',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isCredit || isReward
                                ? '+${currency.format(tx.amount.abs())}'
                                : currency.format(tx.amount),
                            style: TextStyle(
                              color: isCredit || isReward ? const Color(0xFF2E7D32) : AppTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tx.cashBackOrReward,
                            style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w700, fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBottomDock(BuildContext context, AppState appState, List<CreditCardModel> cards) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.surfaceBorder, width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
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
                style: TextStyle(
                  color: AppTheme.textPrimary,
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
                  color: AegisCloudPalette.mintGreen,
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
              final isMint = card.themePreset == CardThemePreset.mintGreen;

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
                      color: isSelected ? AppTheme.textPrimary : AppTheme.surfaceBorder,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      card.lastFour,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: isMint ? const Color(0xFF1E2818) : Colors.white,
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
                border: Border.all(color: AppTheme.surfaceBorder, width: 1.2),
                color: AppTheme.background,
              ),
              child: Icon(Icons.add, size: 18, color: AppTheme.textPrimary),
            ),
          ),

          // FICO Credit Shield / Security Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AegisCloudPalette.mintGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '780 FICO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
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


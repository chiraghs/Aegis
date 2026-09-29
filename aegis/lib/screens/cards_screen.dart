import 'package:flutter/material.dart';
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
  int _selectedFilter = 0; // 0: All, 1: Unpaid, 2: Cleared

  void _handleAddCard(BuildContext context, AppState appState) {
    if (!appState.canAddMoreCards) {
      // Free tier card limit reached! Show RevenueCat Paywall
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceCardElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('CARD LIMIT REACHED', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
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

    // Add demo card
    final newCard = CreditCardModel(
      id: 'card_bilt_${DateTime.now().millisecondsSinceEpoch}',
      cardName: 'Bilt World Elite Mastercard',
      issuer: 'Wells Fargo',
      network: CardNetwork.mastercard,
      lastFour: '5012',
      currentBalance: 750.0,
      creditLimit: 15000.0,
      statementBalance: 750.0,
      minimumDue: 25.0,
      dueDate: DateTime.now().add(const Duration(days: 18)),
      apr: 21.49,
      topPerks: ['1x Rent with Zero Fees', '3x Dining', '2x Travel'],
      themePreset: CardThemePreset.appleTitanium,
      isPaidThisCycle: false,
    );

    appState.cards.add(newCard);
    // Trigger update
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connected Bilt World Elite Mastercard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    List<CreditCardModel> filteredCards = appState.cards;
    if (_selectedFilter == 1) {
      filteredCards = appState.cards.where((c) => !c.isPaidThisCycle).toList();
    } else if (_selectedFilter == 2) {
      filteredCards = appState.cards.where((c) => c.isPaidThisCycle).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'CREDIT PORTFOLIO',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppTheme.goldAccent),
            onPressed: () => _handleAddCard(context, appState),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All Cards (${appState.cards.length})', 0),
                const SizedBox(width: 8),
                _buildFilterChip('Action Due', 1),
                const SizedBox(width: 8),
                _buildFilterChip('Cleared', 2),
              ],
            ),
          ),

          // Cards List
          Expanded(
            child: filteredCards.isEmpty
                ? Center(
                    child: Text(
                      'No cards in this category.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: filteredCards.length,
                    itemBuilder: (context, index) {
                      final card = filteredCards[index];
                      return CreditCardWidget(
                        card: card,
                        onSimulatePayment: () {
                          final res = appState.simulateExternalPayment(card.id);
                          if (res['success'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('External pay cleared! Minted ${res['coins']} coins.'),
                                backgroundColor: AppTheme.surfaceCardElevated,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.black : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

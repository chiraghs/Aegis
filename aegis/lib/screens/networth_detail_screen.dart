import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/asset_model.dart';
import '../providers/app_state.dart';
import '../widgets/glass_container.dart';
import '../widgets/networth_chart_widget.dart';
import '../widgets/asset_allocation_bar.dart';
import 'paywall_screen.dart';

class NetWorthDetailScreen extends StatelessWidget {
  const NetWorthDetailScreen({super.key});

  void _showAddAssetSheet(BuildContext context, AppState appState) {
    final nameCtrl = TextEditingController();
    final instCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    AssetCategory selectedCategory = AssetCategory.investments;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ADD WEALTH ASSET',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppTheme.textMuted),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Category selector chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: AssetCategory.values.where((c) => c != AssetCategory.vehicles).map((cat) {
                    final isSel = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat.label.split('&').first.trim()),
                        selected: isSel,
                        selectedColor: cat.color.withValues(alpha: 0.25),
                        backgroundColor: AppTheme.surface,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSel ? cat.color : AppTheme.textSecondary,
                        ),
                        side: BorderSide(color: isSel ? cat.color : AppTheme.surfaceBorder),
                        onSelected: (val) {
                          if (val) setModalState(() => selectedCategory = cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Asset Name (e.g. S&P 500 Index / HYSA)',
                  labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: instCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Institution (e.g. Vanguard, Chase, Robinhood)',
                  labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Current Valuation (\$ USD)',
                  labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final val = double.tryParse(valueCtrl.text.replaceAll(',', ''));
                    if (nameCtrl.text.trim().isEmpty || val == null || val <= 0) return;

                    final newAsset = AssetItem(
                      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      institution: instCtrl.text.trim().isEmpty ? 'Connected Asset' : instCtrl.text.trim(),
                      category: selectedCategory,
                      valuation: val,
                      lastUpdated: DateTime.now(),
                      monthlyChangePercent: 2.5,
                    );

                    appState.addAsset(newAsset);
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${newAsset.name} to Unified Net Worth!'),
                        backgroundColor: AppTheme.emeraldAccent,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.emeraldAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('SAVE TO RADAR', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currency = NumberFormat.simpleCurrency();
    final compact = NumberFormat.compactSimpleCurrency();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'UNIFIED NET WORTH',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.emeraldAccent),
            tooltip: 'Add Asset',
            onPressed: () => _showAddAssetSheet(context, appState),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Net Worth Card
            GlassContainer(
              borderColor: AppTheme.emeraldAccent.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'TOTAL AGGREGATE NET WORTH',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.emeraldAccent.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          '+${currency.format(appState.monthlyNetWorthChange)} (+${appState.monthlyNetWorthChangePercent.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.emeraldAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currency.format(appState.netWorth),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.surfaceBorder, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL ASSETS',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currency.format(appState.totalAssetValue),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 28, color: AppTheme.surfaceBorder),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL LIABILITIES',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currency.format(appState.totalLiabilityValue),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.crimsonAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 6-Month Trajectory Chart
            NetWorthChartWidget(history: appState.netWorthHistory),

            const SizedBox(height: 16),

            // Asset Allocation Breakdown
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PORTFOLIO ASSET ALLOCATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AssetAllocationBar(appState: appState),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // RevenueCat Gated Insights / Wealth Health
            _buildWealthIntelligenceCard(context, appState),

            const SizedBox(height: 24),

            // Connected Assets Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'VALUED ASSETS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppTheme.textSecondary),
                ),
                Text(
                  compact.format(appState.totalAssetValue),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Vehicles from Garage
            ...appState.vehicles.map((v) => _buildVehicleAssetTile(v, currency)),

            // Manual & Plaid Assets
            ...appState.assets.map((a) => _buildAssetTile(context, a, appState, currency)),

            const SizedBox(height: 24),

            // Liabilities Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ACTIVE LIABILITIES & DEBT',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppTheme.textSecondary),
                ),
                Text(
                  compact.format(appState.totalLiabilityValue),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.crimsonAccent),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Credit Cards Summary
            _buildLiabilitiesCard(
              title: 'Revolving Credit Cards (${appState.cards.length})',
              subtitle: 'Statement debt across linked Visa, Amex, Mastercard',
              amount: appState.totalCurrentBalance,
              color: AppTheme.crimsonAccent,
              currency: currency,
            ),

            // Fixed Loans (Mortgage, Auto)
            ...appState.fixedLiabilities.map((l) => _buildFixedLiabilityTile(l, currency)),
          ],
        ),
      ),
    );
  }

  Widget _buildWealthIntelligenceCard(BuildContext context, AppState appState) {
    final currency = NumberFormat.compactSimpleCurrency();

    if (!appState.hasDeepNetWorthAnalytics) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF241C0E), Color(0xFF131008)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.workspace_premium, color: AppTheme.goldAccent, size: 20),
                SizedBox(width: 8),
                Text(
                  'AEGIS WEALTH INTELLIGENCE',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.goldAccent, letterSpacing: 1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlock Real-Time Zillow & KBB Sync, Liquidity Runway ratio, and Monte Carlo FI/RE projections with Gold Pass.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PaywallScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('UPGRADE TO GOLD PASS (\$4.99/mo)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      );
    }

    final debtToAsset = appState.totalAssetValue > 0
        ? (appState.totalLiabilityValue / appState.totalAssetValue) * 100
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppTheme.goldAccent, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'WEALTH RUNWAY & HEALTH AUDIT',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.goldAccent, letterSpacing: 1),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.goldAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  appState.isBlackEdition ? 'BLACK EDITION' : 'GOLD PASS',
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.goldAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  'LIQUID RUNWAY',
                  '${appState.liquidityRunwayMonths.toStringAsFixed(1)} Mo',
                  'Cash: ${currency.format(appState.cashAssets)}',
                  AppTheme.emeraldAccent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  'DEBT-TO-ASSET',
                  '${debtToAsset.toStringAsFixed(1)}%',
                  debtToAsset < 40 ? 'Healthy (<40%)' : 'Leveraged',
                  debtToAsset < 40 ? AppTheme.cyanAccent : AppTheme.crimsonAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, String subtext, Color accent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.textMuted)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: accent)),
          const SizedBox(height: 2),
          Text(subtext, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildVehicleAssetTile(dynamic vehicle, NumberFormat currency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AssetCategory.vehicles.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(AssetCategory.vehicles.icon, color: AssetCategory.vehicles.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.year} ${vehicle.make} ${vehicle.model}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 2),
                const Text(
                  'NHTSA Verified Garage Asset',
                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          Text(
            currency.format(vehicle.estimatedValue),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetTile(BuildContext context, AssetItem asset, AppState appState, NumberFormat currency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: asset.category.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(asset.category.icon, color: asset.category.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  asset.institution,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currency.format(asset.valuation),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                '+${asset.monthlyChangePercent.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.emeraldAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiabilitiesCard({
    required String title,
    required String subtitle,
    required double amount,
    required Color color,
    required NumberFormat currency,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.credit_card, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Text(
            currency.format(amount),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedLiabilityTile(LiabilityItem liability, NumberFormat currency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: liability.category.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(liability.category.icon, color: liability.category.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(liability.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text(
                  '${liability.lender} • ${liability.interestRateApr}% APR',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          Text(
            currency.format(liability.balance),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.crimsonAccent),
          ),
        ],
      ),
    );
  }
}

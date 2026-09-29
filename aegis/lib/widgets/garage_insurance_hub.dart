import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../models/garage_extras_model.dart';
import '../providers/app_state.dart';

class GarageInsuranceHub extends StatelessWidget {
  final AppState appState;

  const GarageInsuranceHub({
    super.key,
    required this.appState,
  });

  void _showPolicyDetails(BuildContext context, InsurancePolicyModel policy) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildProviderLogo(policy.provider),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.provider,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                        ),
                        Text(
                          '${policy.coverageType.toUpperCase()} • ACTIVE',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.emeraldAccent),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Policy Number', policy.policyNumber),
                  const Divider(height: 16),
                  _buildDetailRow('Insured Declared Value (IDV)', '₹${policy.idv.toInt()}'),
                  const Divider(height: 16),
                  _buildDetailRow('Annual Premium', '₹${policy.annualPremium.toInt()}'),
                  const Divider(height: 16),
                  _buildDetailRow('Valid Until', '${policy.expiryDate.day}/${policy.expiryDate.month}/${policy.expiryDate.year}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading digital insurance certificate PDF...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Download Policy PDF', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellOrBuyInsuranceMarketplace(BuildContext context) {
    String selectedCoverage = 'Comprehensive';
    String selectedProvider = 'Royal Sundaram';
    double selectedPrice = 1850.0;
    bool isAgentSellingMode = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.goldAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.verified_user_outlined, color: AppTheme.goldAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'INSURANCE MARKETPLACE',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Compare certified insurance quotes for ${appState.activeVehicle.year} ${appState.activeVehicle.make} ${appState.activeVehicle.model}.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),

              // Agent Selling Switcher vs Personal Purchase
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCardElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => isAgentSellingMode = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isAgentSellingMode ? AppTheme.goldAccent : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Sell Insurance (Earn ₹1,500)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isAgentSellingMode ? Colors.black : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => isAgentSellingMode = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !isAgentSellingMode ? AppTheme.goldAccent : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Buy for Myself',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: !isAgentSellingMode ? Colors.black : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Coverage Tier Choice Chips
              const Text(
                'COVERAGE TYPE',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildCoverageChip('Comprehensive', selectedCoverage, (val) {
                    setModalState(() {
                      selectedCoverage = val;
                      selectedPrice = 1850.0;
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildCoverageChip('Zero Dep', selectedCoverage, (val) {
                    setModalState(() {
                      selectedCoverage = val;
                      selectedPrice = 2450.0;
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildCoverageChip('Third Party', selectedCoverage, (val) {
                    setModalState(() {
                      selectedCoverage = val;
                      selectedPrice = 850.0;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Insurance Provider Quote Cards
              _buildQuoteOption(
                'Royal Sundaram General',
                'Zero-paperwork cashless repair at 4,800+ authorized workshops',
                '₹${selectedPrice.toInt()}',
                selectedProvider == 'Royal Sundaram',
                () => setModalState(() => selectedProvider = 'Royal Sundaram'),
              ),
              _buildQuoteOption(
                'Digit Insurance',
                'Instant self-inspection via smartphone with 98.7% claim settlement',
                '₹${(selectedPrice * 0.95).toInt()}',
                selectedProvider == 'Digit Insurance',
                () => setModalState(() => selectedProvider = 'Digit Insurance'),
              ),
              _buildQuoteOption(
                'Acko Drive',
                'Direct-to-consumer digital policy with zero broker commission',
                '₹${(selectedPrice * 0.90).toInt()}',
                selectedProvider == 'Acko Drive',
                () => setModalState(() => selectedProvider = 'Acko Drive'),
              ),
              const SizedBox(height: 16),

              // Issue / Sell Policy CTA Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final newPolicy = InsurancePolicyModel(
                      id: 'pol_${DateTime.now().millisecondsSinceEpoch}',
                      provider: selectedProvider,
                      providerLogo: 'shield',
                      policyNumber: 'POL-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
                      coverageType: selectedCoverage.toLowerCase(),
                      annualPremium: selectedPrice,
                      expiryDate: DateTime.now().add(const Duration(days: 365)),
                      isActive: true,
                      vehicleId: appState.activeVehicle.id,
                      idv: appState.activeVehicle.estimatedMarketValue,
                    );

                    appState.purchaseOrSellInsurancePolicy(newPolicy, isSelling: isAgentSellingMode);
                    Navigator.of(ctx).pop();

                    final rewardMsg = isAgentSellingMode
                        ? 'Policy sold! ₹1,500 commission + 1,500 Aegis Coins credited to your Vault!'
                        : 'New policy issued! ₹750 cashback + 750 Aegis Coins minted!';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(rewardMsg)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isAgentSellingMode ? 'SELL POLICY & EARN ₹1,500 COMMISSION' : 'ISSUE POLICY NOW',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverageChip(String label, String current, Function(String) onSelect) {
    final isSelected = label == current;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceCardElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.black : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteOption(String name, String perk, String price, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldAccent.withValues(alpha: 0.1) : AppTheme.surfaceCardElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Text(perk, style: TextStyle(fontSize: 10, color: AppTheme.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              price,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildProviderLogo(String provider) {
    final lower = provider.toLowerCase();
    if (lower.contains('royal')) {
      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF003366),
          border: Border.all(color: Colors.amberAccent),
        ),
        child: const Icon(Icons.shield, color: Colors.amberAccent, size: 20),
      );
    }
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(color: Colors.white24),
      ),
      child: const Center(
        child: Text('digit', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final policies = appState.insurancePolicies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: "2 INSURANCE POLICIES"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${policies.length} INSURANCE POLICIES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: AppTheme.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => _showSellOrBuyInsuranceMarketplace(context),
                child: Text(
                  '+ Sell / Buy Policy',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.goldAccent,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal Policy Cards List
        SizedBox(
          height: 85,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: policies.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index < policies.length) {
                final policy = policies[index];
                return Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.surfaceBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: appState.isDarkMode ? 0.3 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildProviderLogo(policy.provider),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              policy.provider,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${policy.coverageType} • active',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.emeraldAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showPolicyDetails(context, policy),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                );
              }

              // Sell / Buy Card at end of carousel
              return GestureDetector(
                onTap: () => _showSellOrBuyInsuranceMarketplace(context),
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.goldAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart, color: AppTheme.goldAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Sell & Earn ₹1,500',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.goldAccent),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
                  _buildDetailRow('Stated Insured Value', '\$${policy.idv.toInt()}'),
                  const Divider(height: 16),
                  _buildDetailRow('Annual Premium', '\$${policy.annualPremium.toInt()} (\$${(policy.annualPremium / 12).toStringAsFixed(0)}/mo)'),
                  const Divider(height: 16),
                  _buildDetailRow('Valid Until', '${policy.expiryDate.month}/${policy.expiryDate.day}/${policy.expiryDate.year}'),
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
                    const SnackBar(content: Text('Downloading digital proof of insurance card (PDF)...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Download Insurance ID Card (PDF)', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellOrBuyInsuranceMarketplace(BuildContext context) {
    String selectedCoverage = 'Comprehensive & Collision';
    String selectedProvider = 'GEICO Auto';
    double selectedPrice = 1380.0;
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
                        'US AUTO INSURANCE HUB',
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
                'Compare certified US carrier quotes for ${appState.activeVehicle.year} ${appState.activeVehicle.make} ${appState.activeVehicle.model}.',
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
                              'Sell Insurance (Earn \$200)',
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
                              'Buy for Myself (\$100 Back)',
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCoverageChip('Comprehensive & Collision', selectedCoverage, (val) {
                      setModalState(() {
                        selectedCoverage = val;
                        selectedPrice = 1380.0;
                      });
                    }),
                    const SizedBox(width: 8),
                    _buildCoverageChip('Full Coverage + Roadside', selectedCoverage, (val) {
                      setModalState(() {
                        selectedCoverage = val;
                        selectedPrice = 1680.0;
                      });
                    }),
                    const SizedBox(width: 8),
                    _buildCoverageChip('State Liability (100k/300k)', selectedCoverage, (val) {
                      setModalState(() {
                        selectedCoverage = val;
                        selectedPrice = 720.0;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Insurance Provider Quote Cards
              _buildQuoteOption(
                'GEICO Auto',
                '15 minutes could save you 15% or more. Cashless repair at 3,200+ Auto Repair Xpress shops.',
                '\$${selectedPrice.toInt()}/yr',
                '\$${(selectedPrice / 12).toStringAsFixed(0)}/mo',
                selectedProvider == 'GEICO Auto',
                () => setModalState(() => selectedProvider = 'GEICO Auto'),
              ),
              _buildQuoteOption(
                'Progressive Premier',
                'Snapshot telematics discount with OEM replacement parts guarantee and 24/7 roadside assist.',
                '\$${(selectedPrice * 1.08).toInt()}/yr',
                '\$${((selectedPrice * 1.08) / 12).toStringAsFixed(0)}/mo',
                selectedProvider == 'Progressive Premier',
                () => setModalState(() => selectedProvider = 'Progressive Premier'),
              ),
              _buildQuoteOption(
                'State Farm Drive Safe',
                'Ranked #1 for claims satisfaction by J.D. Power with safe-driving beacon discount.',
                '\$${(selectedPrice * 0.92).toInt()}/yr',
                '\$${((selectedPrice * 0.92) / 12).toStringAsFixed(0)}/mo',
                selectedProvider == 'State Farm Drive Safe',
                () => setModalState(() => selectedProvider = 'State Farm Drive Safe'),
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
                      policyNumber: 'US-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
                      coverageType: selectedCoverage,
                      annualPremium: selectedPrice,
                      expiryDate: DateTime.now().add(const Duration(days: 365)),
                      isActive: true,
                      vehicleId: appState.activeVehicle.id,
                      idv: appState.activeVehicle.estimatedMarketValue,
                    );

                    appState.purchaseOrSellInsurancePolicy(newPolicy, isSelling: isAgentSellingMode);
                    Navigator.of(ctx).pop();

                    final rewardMsg = isAgentSellingMode
                        ? 'Policy sold! \$200 commission + 2,000 Aegis Coins credited to your Vault!'
                        : 'New policy issued! \$100 cashback + 1,000 Aegis Coins minted!';

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
                    isAgentSellingMode ? 'SELL POLICY & EARN \$200 COMMISSION' : 'BIND POLICY & GET \$100 BACK',
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

  Widget _buildQuoteOption(String name, String perk, String priceYear, String priceMo, bool isSelected, VoidCallback onTap) {
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
          children: [
            _buildProviderLogo(name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    perk,
                    style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  priceMo,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.goldAccent),
                ),
                Text(
                  priceYear,
                  style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                ),
              ],
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
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
      ],
    );
  }

  Widget _buildProviderLogo(String provider) {
    final p = provider.toLowerCase();
    Color bgColor = const Color(0xFF1E3A8A);
    String initials = 'US';

    if (p.contains('geico')) {
      bgColor = const Color(0xFF15803D);
      initials = 'G';
    } else if (p.contains('progressive')) {
      bgColor = const Color(0xFF0284C7);
      initials = 'PGR';
    } else if (p.contains('state farm')) {
      bgColor = const Color(0xFFDC2626);
      initials = 'SF';
    } else if (p.contains('allstate')) {
      bgColor = const Color(0xFF1D4ED8);
      initials = 'ALL';
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
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
                                fontSize: 10,
                                color: AppTheme.emeraldAccent,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                  width: 190,
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
                        'Sell & Earn \$200',
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

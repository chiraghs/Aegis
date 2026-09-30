import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../models/garage_extras_model.dart';
import '../providers/app_state.dart';

class GarageInsuranceHub extends StatefulWidget {
  final AppState appState;

  const GarageInsuranceHub({
    super.key,
    required this.appState,
  });

  @override
  State<GarageInsuranceHub> createState() => _GarageInsuranceHubState();
}

class _GarageInsuranceHubState extends State<GarageInsuranceHub> {
  bool _showTrackingView = true;

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
                  _buildDetailRow('Annual Premium', '\$${policy.annualPremium.toInt()} (\$${policy.monthlyPremium.toStringAsFixed(0)}/mo)'),
                  const Divider(height: 16),
                  _buildDetailRow('Continuous Coverage', '${policy.continuousCoverageYears} Years Streak (Tier 1 Rate)'),
                  const Divider(height: 16),
                  _buildDetailRow('Comprehensive Ded.', '\$${policy.comprehensiveDeductible.toInt()}'),
                  const Divider(height: 16),
                  _buildDetailRow('Collision Ded.', '\$${policy.collisionDeductible.toInt()}'),
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

  void _showFileRapidClaimModal(BuildContext context, InsurancePolicyModel policy) {
    final titleController = TextEditingController(text: 'Windshield Stone Chip Repair');
    final shopController = TextEditingController(text: 'Safelite AutoGlass Certified Center');
    final costController = TextEditingController(text: '350');

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
                        child: Icon(Icons.flash_on, color: AppTheme.goldAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'FILE RAPID INSURANCE CLAIM',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.1),
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
                'Direct claim filing with ${policy.provider} for ${widget.appState.activeVehicle.year} ${widget.appState.activeVehicle.make} ${widget.appState.activeVehicle.model}.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Incident Description',
                  labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  filled: true,
                  fillColor: AppTheme.surfaceCardElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: shopController,
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Preferred Repair Center / Body Shop',
                  labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  filled: true,
                  fillColor: AppTheme.surfaceCardElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Estimated Repair Cost (USD)',
                  labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  filled: true,
                  fillColor: AppTheme.surfaceCardElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final shop = shopController.text.trim();
                    final cost = double.tryParse(costController.text.trim()) ?? 350.0;
                    if (title.isEmpty) return;

                    widget.appState.fileVehicleInsuranceClaim(
                      policyId: policy.id,
                      title: title,
                      shop: shop,
                      estimatedCost: cost,
                    );

                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppTheme.emeraldAccent,
                        content: Text('Rapid claim submitted to ${policy.provider}! Adjuster assigned in-app.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Submit Claim to Adjuster', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
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
                'Compare certified US carrier quotes for ${widget.appState.activeVehicle.year} ${widget.appState.activeVehicle.make} ${widget.appState.activeVehicle.model}.',
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
                        selectedPrice = 1620.0;
                      });
                    }),
                    const SizedBox(width: 8),
                    _buildCoverageChip('State Minimum Liability', selectedCoverage, (val) {
                      setModalState(() {
                        selectedCoverage = val;
                        selectedPrice = 640.0;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Carrier Quotes
              const Text(
                'AVAILABLE US CARRIERS',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              _buildQuoteOption(
                provider: 'GEICO Auto',
                logoTag: 'shield',
                annualCost: selectedPrice,
                features: 'DriveEasy telematics discount eligible • 24/7 Mechanical Breakdown',
                isSelected: selectedProvider == 'GEICO Auto',
                onSelect: () => setModalState(() => selectedProvider = 'GEICO Auto'),
              ),
              const SizedBox(height: 8),
              _buildQuoteOption(
                provider: 'Progressive Premier',
                logoTag: 'pgr',
                annualCost: selectedPrice * 1.08,
                features: 'Snapshot mobile tracking included • Pet Injury coverage included',
                isSelected: selectedProvider == 'Progressive Premier',
                onSelect: () => setModalState(() => selectedProvider = 'Progressive Premier'),
              ),
              const SizedBox(height: 8),
              _buildQuoteOption(
                provider: 'State Farm Drive Safe',
                logoTag: 'state farm',
                annualCost: selectedPrice * 0.94,
                features: 'Drive Safe & Save beacon sync • OEM Replacement Glass Guarantee',
                isSelected: selectedProvider == 'State Farm Drive Safe',
                onSelect: () => setModalState(() => selectedProvider = 'State Farm Drive Safe'),
              ),
              const SizedBox(height: 20),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final newPolicy = InsurancePolicyModel(
                      id: 'pol_${DateTime.now().millisecondsSinceEpoch}',
                      provider: selectedProvider,
                      providerLogo: selectedProvider.contains('Progressive') ? 'pgr' : 'shield',
                      policyNumber: '${selectedProvider.substring(0, 3).toUpperCase()}-US-${DateTime.now().millisecond}',
                      coverageType: selectedCoverage,
                      annualPremium: selectedPrice,
                      expiryDate: DateTime.now().add(const Duration(days: 365)),
                      isActive: true,
                      vehicleId: widget.appState.activeVehicle.id,
                      idv: widget.appState.activeVehicle.estimatedMarketValue,
                      telematics: const VehicleTelematicsTracking(
                        safeDriverScore: 94,
                        discountPercent: 24.0,
                        smoothBrakingScore: 96.0,
                        speedComplianceScore: 92.0,
                        safeCorneringScore: 94.0,
                        phoneFreeScore: 100.0,
                        daytimeDrivingScore: 92.0,
                        annualMilesLogged: 2400,
                        annualMilesLimit: 10000,
                        tierGrade: 'Tier A Elite',
                      ),
                    );

                    widget.appState.purchaseOrSellInsurancePolicy(newPolicy, isSelling: isAgentSellingMode);
                    Navigator.of(ctx).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppTheme.emeraldAccent,
                        content: Text(
                          isAgentSellingMode
                              ? 'Success! Policy referral registered. \$200 commission (+2,000 Aegis Coins) minted!'
                              : 'Success! Policy activated for ${widget.appState.activeVehicle.make}. \$100 cashback (+1,000 Coins) added!',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isAgentSellingMode ? 'Bind Policy & Collect \$200 Commission' : 'Activate Policy & Claim \$100 Cashback',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverageChip(String label, String currentSelected, Function(String) onSelect) {
    final isSelected = label == currentSelected;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceCardElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.black : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteOption({
    required String provider,
    required String logoTag,
    required double annualCost,
    required String features,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCardElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.goldAccent : AppTheme.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _buildProviderLogo(provider),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.textPrimary)),
                  Text(features, style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${annualCost.toInt()}/yr', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.textPrimary)),
                Text('\$${(annualCost / 12).toStringAsFixed(0)}/mo', style: TextStyle(fontSize: 11, color: AppTheme.goldAccent)),
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
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildProviderLogo(String provider) {
    final p = provider.toLowerCase();
    Color bgColor = const Color(0xFF003865);
    String initials = 'GEICO';

    if (p.contains('progressive')) {
      bgColor = const Color(0xFF0072CE);
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
    final policies = widget.appState.insurancePolicies;
    final activePolicy = widget.appState.activeVehicleInsurancePolicy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: Switcher between Live Tracking vs Policies
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GARAGE INSURANCE & TELEMATICS',
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

        // Subheader Toggle Pills
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showTrackingView = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _showTrackingView ? AppTheme.goldAccent.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: _showTrackingView ? Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.5)) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.speed, size: 14, color: _showTrackingView ? AppTheme.goldAccent : AppTheme.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            'Live Telematics & Tracking',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _showTrackingView ? AppTheme.goldAccent : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showTrackingView = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !_showTrackingView ? AppTheme.goldAccent.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: !_showTrackingView ? Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.5)) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 14, color: !_showTrackingView ? AppTheme.goldAccent : AppTheme.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            'All Policies (${policies.length})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: !_showTrackingView ? AppTheme.goldAccent : AppTheme.textSecondary,
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
        ),

        const SizedBox(height: 8),

        // Main Body View
        if (_showTrackingView && activePolicy != null) ...[
          _buildLiveTrackingDashboard(context, activePolicy),
        ] else ...[
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
                          color: Colors.black.withValues(alpha: widget.appState.isDarkMode ? 0.3 : 0.04),
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
      ],
    );
  }

  Widget _buildLiveTrackingDashboard(BuildContext context, InsurancePolicyModel policy) {
    final telematics = policy.telematics;
    final claims = policy.claims;
    final activeVehicle = widget.appState.activeVehicle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.surfaceBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: widget.appState.isDarkMode ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Policy Header & Renewal Countdown
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
                          '${policy.provider} • ${activeVehicle.year} ${activeVehicle.model}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                        ),
                        Text(
                          'POLICY #${policy.policyNumber}',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.emeraldAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: AppTheme.emeraldAccent, shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Text(
                        '${policy.daysUntilRenewal}d to renewal',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Continuous Coverage & Autopay Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield, size: 14, color: AppTheme.goldAccent),
                      const SizedBox(width: 6),
                      Text(
                        '${policy.continuousCoverageYears} Yrs Continuous Streak',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                  Text(
                    'Autopay \$${policy.monthlyPremium.toStringAsFixed(0)} due Oct 15',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Telematics & Safe Driver Tracker (UBI)
            if (telematics != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.goldAccent.withValues(alpha: 0.12),
                      AppTheme.surfaceCardElevated,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.speed, color: AppTheme.goldAccent, size: 18),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TELEMATICS DRIVER SCORE',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.goldAccent),
                                ),
                                Text(
                                  '${telematics.safeDriverScore} / 100 • ${telematics.tierGrade}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.goldAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${telematics.discountPercent.toInt()}% DISCOUNT',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🎉 You are currently saving \$${((policy.annualPremium * telematics.discountPercent) / 100).toStringAsFixed(0)}/yr based on your driving metrics.',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.emeraldAccent),
                    ),
                    const SizedBox(height: 12),

                    // Metrics Bars
                    _buildDrivingMetricBar('Smooth Braking', telematics.smoothBrakingScore / 100, '98%'),
                    const SizedBox(height: 6),
                    _buildDrivingMetricBar('Speed Compliance', telematics.speedComplianceScore / 100, '95%'),
                    const SizedBox(height: 6),
                    _buildDrivingMetricBar('Phone-Free Driving', telematics.phoneFreeScore / 100, '100%'),
                    const SizedBox(height: 10),

                    // Mileage cap tracker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Annual Mileage Logged:', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                        Text(
                          '${telematics.annualMilesLogged} / ${telematics.annualMilesLimit} MI (Under Cap ✓)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // 3. Claims Pipeline Tracker
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, color: AppTheme.emeraldAccent, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'CLAIMS STATUS TRACKER',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      Text(
                        '${claims.length} Active / Past',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (claims.isNotEmpty) ...[
                    ...claims.map((clm) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.surfaceBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(clm.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      clm.status.toUpperCase(),
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${clm.claimNumber} • ${clm.repairShop} • \$${clm.payoutAmount.toInt()} Paid (\$${clm.deductiblePaid.toInt()} Ded.)',
                                style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                              ),
                              const SizedBox(height: 8),

                              // Pipeline Steps
                              Row(
                                children: [
                                  _buildPipelineStep('Filed', isPassed: true),
                                  _buildPipelineConnector(isPassed: true),
                                  _buildPipelineStep('Review', isPassed: true),
                                  _buildPipelineConnector(isPassed: true),
                                  _buildPipelineStep('Approved', isPassed: true),
                                  _buildPipelineConnector(isPassed: clm.currentStep >= 3),
                                  _buildPipelineStep('Paid', isPassed: clm.currentStep >= 3),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ] else ...[
                    Text('No open claims on this vehicle.', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  ],

                  const SizedBox(height: 8),

                  // Claim and Roadside Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showFileRapidClaimModal(context, policy),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.goldAccent.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: Icon(Icons.add_circle_outline, size: 14, color: AppTheme.goldAccent),
                          label: Text('+ File Rapid Claim', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.goldAccent)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dispatching 24/7 Roadside Assistance to your current GPS coordinates...'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.surfaceBorder),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.call, size: 14, color: Colors.blueAccent),
                          label: const Text('24/7 Towing / Assist', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.blueAccent)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 4. Coverage Summary Pills
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildCoverageSummaryPill('Comp Ded: \$${policy.comprehensiveDeductible.toInt()}'),
                _buildCoverageSummaryPill('Coll Ded: \$${policy.collisionDeductible.toInt()}'),
                _buildCoverageSummaryPill('Bodily Injury: ${policy.bodilyInjuryLimit}'),
                _buildCoverageSummaryPill('Property: ${policy.propertyDamageLimit}'),
                _buildCoverageSummaryPill('Roadside: 24/7 Unlimited'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageSummaryPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCardElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
      ),
    );
  }

  Widget _buildDrivingMetricBar(String label, double value, String percentageText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
            Text(percentageText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: AppTheme.surfaceBorder,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.goldAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineStep(String label, {required bool isPassed}) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed ? AppTheme.emeraldAccent : AppTheme.surfaceBorder,
          ),
          child: Center(
            child: Icon(Icons.check, size: 9, color: isPassed ? Colors.black : Colors.transparent),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isPassed ? FontWeight.w800 : FontWeight.w500,
            color: isPassed ? AppTheme.textPrimary : AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineConnector({required bool isPassed}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 12),
        color: isPassed ? AppTheme.emeraldAccent : AppTheme.surfaceBorder,
      ),
    );
  }
}

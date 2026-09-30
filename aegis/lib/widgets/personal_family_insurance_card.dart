import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../models/family_insurance_model.dart';
import '../providers/app_state.dart';

class PersonalFamilyInsuranceCard extends StatelessWidget {
  final AppState appState;

  const PersonalFamilyInsuranceCard({
    super.key,
    required this.appState,
  });

  void _showFamilyVaultModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _FamilyInsuranceVaultSheet(appState: appState),
    );
  }

  @override
  Widget build(BuildContext context) {
    final healthPolicy = appState.primaryHealthPolicy;
    final lifePolicy = appState.primaryLifePolicy;
    final homePolicy = appState.primaryHomePolicy;

    final deductibleMet = healthPolicy?.familyDeductibleMet ?? 1450.0;
    final deductibleTotal = healthPolicy?.familyDeductibleTotal ?? 3000.0;
    final deductiblePercent = (deductibleMet / deductibleTotal).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: () => _showFamilyVaultModal(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.surfaceCard,
                AppTheme.surfaceCardElevated,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.surfaceBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: appState.isDarkMode ? 0.3 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.cyanAccent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.family_restroom, color: AppTheme.cyanAccent, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FAMILY & PERSONAL INSURANCE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: AppTheme.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Health • Life • Property Vault',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.goldAccent,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.goldAccent),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Coverage Highlights Grid
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCardElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.surfaceBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TERM LIFE PROTECTION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.textMuted)),
                          const SizedBox(height: 2),
                          Text('\$${(lifePolicy?.lifeFaceValue ?? 1000000).toInt()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                          Text(lifePolicy?.provider ?? 'Northwestern Mutual', style: TextStyle(fontSize: 10, color: AppTheme.emeraldAccent), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCardElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.surfaceBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('HOME & PROPERTY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.textMuted)),
                          const SizedBox(height: 2),
                          Text('\$${(homePolicy?.dwellingCoverage ?? 650000).toInt()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                          Text(homePolicy?.provider ?? 'Lemonade HO-3', style: TextStyle(fontSize: 10, color: AppTheme.emeraldAccent), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Health Deductible Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.local_hospital_outlined, size: 14, color: AppTheme.crimsonAccent),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'BCBS Family Deductible:',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${deductibleMet.toInt()} / \$${deductibleTotal.toInt()} Met',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.goldAccent),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: deductiblePercent,
                  minHeight: 6,
                  backgroundColor: AppTheme.surfaceBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.goldAccent),
                ),
              ),

              const SizedBox(height: 12),

              // Covered Family Members Avatars
              Row(
                children: [
                  Text(
                    'Covered:',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildMemberChip('Alex (Self)'),
                          const SizedBox(width: 4),
                          _buildMemberChip('Sarah'),
                          const SizedBox(width: 4),
                          _buildMemberChip('Emma'),
                          const SizedBox(width: 4),
                          _buildMemberChip('Noah'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCardElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Text(
        name,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
      ),
    );
  }
}

class _FamilyInsuranceVaultSheet extends StatefulWidget {
  final AppState appState;

  const _FamilyInsuranceVaultSheet({required this.appState});

  @override
  State<_FamilyInsuranceVaultSheet> createState() => _FamilyInsuranceVaultSheetState();
}

class _FamilyInsuranceVaultSheetState extends State<_FamilyInsuranceVaultSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final health = widget.appState.primaryHealthPolicy;
    final life = widget.appState.primaryLifePolicy;
    final home = widget.appState.primaryHomePolicy;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.cyanAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.family_restroom, color: AppTheme.cyanAccent, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PERSONAL & FAMILY INSURANCE VAULT',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.1, color: AppTheme.textPrimary),
                      ),
                      Text(
                        'Active US Carrier Policies & Live Claims',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.goldAccent,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.goldAccent,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            tabs: const [
              Tab(text: 'HEALTH & RX'),
              Tab(text: 'TERM LIFE'),
              Tab(text: 'HOMEOWNERS'),
            ],
          ),

          const SizedBox(height: 12),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Health & Dental Tab
                _buildHealthTab(context, health),

                // 2. Term Life Tab
                _buildLifeTab(context, life),

                // 3. Homeowners Tab
                _buildHomeTab(context, home),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTab(BuildContext context, FamilyInsurancePolicyModel? policy) {
    if (policy == null) return const Center(child: Text('No active health policy.'));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan overview card
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
                    Text(policy.provider, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('ACTIVE PPO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent)),
                    ),
                  ],
                ),
                Text(policy.planName, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const Divider(height: 16),
                _buildDetailRow('Policy / Member Group', policy.policyNumber),
                _buildDetailRow('Annual Premium', '\$${policy.annualPremium.toInt()} (\$${policy.monthlyPremium.toInt()}/mo)'),
                _buildDetailRow('Family Deductible Met', '\$${policy.familyDeductibleMet?.toInt()} / \$${policy.familyDeductibleTotal?.toInt()}'),
                _buildDetailRow('Out-of-Pocket Max Met', '\$${policy.outOfPocketMet?.toInt()} / \$${policy.outOfPocketMax?.toInt()}'),
                _buildDetailRow('HSA / FSA Balance', '\$${policy.hsaFsaBalance?.toInt()}', valueColor: AppTheme.emeraldAccent),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Covered Family Members
          Text('COVERED FAMILY MEMBERS & DEDUCTIBLES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          ...policy.coveredMembers.map((mem) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCardElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.cyanAccent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(mem.name.substring(0, 1), style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.cyanAccent)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mem.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                          Text('${mem.relation} • ID: ${mem.memberId}', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${mem.individualDeductibleMet.toInt()} / \$${mem.individualDeductibleLimit.toInt()}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                        Text('Deductible Met', style: TextStyle(fontSize: 9, color: AppTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 14),

          // Claims History
          Text('RECENT HEALTHCARE CLAIMS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          ...policy.claims.map((clm) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCardElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(clm.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: clm.statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(clm.statusDisplay, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: clm.statusColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${clm.provider} • Member: ${clm.memberName}', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    Text('Claimed: \$${clm.amountClaimed.toInt()} | Insurer Paid: \$${clm.amountCovered.toInt()} | You Paid: \$${clm.memberResponsibility.toInt()}', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
              )),

          const SizedBox(height: 12),

          // File Health Claim Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAddFamilyClaimDialog(context, policy),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.goldAccent.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(Icons.add, size: 16, color: AppTheme.goldAccent),
              label: Text('Submit Healthcare / Rx Claim', style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.goldAccent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifeTab(BuildContext context, FamilyInsurancePolicyModel? policy) {
    if (policy == null) return const Center(child: Text('No active life policy.'));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
                    Text(policy.provider, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('20-YR LEVEL TERM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent)),
                    ),
                  ],
                ),
                Text(policy.planName, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const Divider(height: 20),
                _buildDetailRow('Face Value / Death Benefit', '\$${policy.lifeFaceValue?.toInt()}', valueColor: AppTheme.goldAccent),
                _buildDetailRow('Term Remaining', '${policy.termYearsRemaining} Years (Protected thru 2040)'),
                _buildDetailRow('Annual Premium', '\$${policy.annualPremium.toInt()} (\$${policy.monthlyPremium.toInt()}/mo)'),
                _buildDetailRow('Policy Number', policy.policyNumber),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text('DESIGNATED BENEFICIARIES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          ...policy.beneficiaries.map((b) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCardElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                        Text(b.relation, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      ],
                    ),
                    Text(
                      '${b.percentage.toInt()}% Allocation',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.goldAccent),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context, FamilyInsurancePolicyModel? policy) {
    if (policy == null) return const Center(child: Text('No active homeowners policy.'));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
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
                    Text(policy.provider, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('ACTIVE HO-3', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent)),
                    ),
                  ],
                ),
                Text(policy.planName, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const Divider(height: 20),
                _buildDetailRow('Dwelling Coverage', '\$${policy.dwellingCoverage?.toInt()}'),
                _buildDetailRow('Personal Property', '\$${policy.personalPropertyCoverage?.toInt()}'),
                _buildDetailRow('Personal Liability', '\$${policy.liabilityCoverage?.toInt()}'),
                _buildDetailRow('Deductible', '\$${policy.propertyDeductible?.toInt()}'),
                _buildDetailRow('Annual Premium', '\$${policy.annualPremium.toInt()} (\$${policy.monthlyPremium.toInt()}/mo)'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text('PAST PROPERTY CLAIMS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          ...policy.claims.map((clm) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCardElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(clm.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
                        Text(clm.statusDisplay, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: clm.statusColor)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(clm.notes, style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showAddFamilyClaimDialog(BuildContext context, FamilyInsurancePolicyModel policy) {
    final titleCtrl = TextEditingController(text: 'Specialist Consultation');
    final amountCtrl = TextEditingController(text: '280');
    String member = 'Alex Vance';

    showDialog(
      context: context,
      builder: (dCtx) => StatefulBuilder(
        builder: (dCtx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          title: Text('Submit Healthcare Claim', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Service / Visit Title',
                  labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Billed Amount (USD)',
                  labelStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dCtx).pop(),
              child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 200.0;
                widget.appState.fileFamilyClaim(
                  policyId: policy.id,
                  title: title,
                  memberName: member,
                  amount: amt,
                  notes: 'Direct EOB claim submitted for in-network medical processing.',
                );
                Navigator.of(dCtx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Healthcare claim submitted for EOB adjudication!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldAccent, foregroundColor: Colors.black),
              child: const Text('Submit Claim', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: valueColor ?? AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

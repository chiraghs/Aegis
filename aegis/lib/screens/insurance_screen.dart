import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';
import '../widgets/garage_insurance_hub.dart';
import '../widgets/personal_family_insurance_card.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  int _selectedFilter = 0; // 0: All, 1: Auto, 2: Health & Life, 3: Home & Property

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: Text(
          'INSURANCE VAULT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: AppTheme.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.surfaceBorder, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('All Policies', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('Auto & Mobility', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('Health & Term Life', 2),
                  const SizedBox(width: 8),
                  _buildFilterChip('Home & Umbrella', 3),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Vehicle Insurance Hub (Active Policies + Commission Marketplace)
            if (_selectedFilter == 0 || _selectedFilter == 1) ...[
              GarageInsuranceHub(appState: appState),
              const SizedBox(height: 20),
            ],

            // Personal & Family Insurance Vault (Health, Life, Home, Disability)
            if (_selectedFilter == 0 || _selectedFilter == 2 || _selectedFilter == 3) ...[
              PersonalFamilyInsuranceCard(appState: appState),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7DE43A) : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF7DE43A) : AppTheme.surfaceBorder,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7DE43A).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isSelected ? const Color(0xFF2B2B2B) : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/theme.dart';
import 'dashboard_screen.dart';
import 'cards_screen.dart';
import 'garage_screen.dart';
import 'networth_detail_screen.dart';
import 'insurance_screen.dart';
import 'rewards_screen.dart';

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildFoldableCompanionDetail(int index) {
    switch (index) {
      case 0:
        return const NetWorthDetailScreen();
      case 1:
        return const RewardsScreen(); // Companion Rewards & Coin Vault for Cards
      case 2:
        return const GarageScreen();
      case 3:
        return const InsuranceScreen();
      default:
        return const NetWorthDetailScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(onNavigateToTab: (idx) => setState(() => _currentIndex = idx)),
      const CardsScreen(),
      const GarageScreen(),
      const InsuranceScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDualPane = constraints.maxWidth >= 720;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: isDualPane
              ? Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: IndexedStack(
                        index: _currentIndex,
                        children: screens,
                      ),
                    ),
                    Container(width: 1, color: AppTheme.surfaceBorder),
                    Expanded(
                      flex: 6,
                      child: _buildFoldableCompanionDetail(_currentIndex),
                    ),
                  ],
                )
              : IndexedStack(
                  index: _currentIndex,
                  children: screens,
                ),
          bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF14161E),        // Always dark nav bar
          border: Border(
            top: BorderSide(color: Color(0xFF2A2E3D), width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
                _buildNavItem(icon: Icons.credit_card_rounded, label: 'Cards', index: 1),
                _buildNavItem(icon: Icons.directions_car_rounded, label: 'Garage', index: 2),
                _buildNavItem(icon: Icons.shield_rounded, label: 'Insurance', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  },
);
}


  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF222820) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? const Color(0xFF7DE43A) : const Color(0xFF64748B),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF7DE43A) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


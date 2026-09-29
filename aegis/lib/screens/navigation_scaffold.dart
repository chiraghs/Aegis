import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../models/subscription_tier.dart';
import '../providers/app_state.dart';
import 'dashboard_screen.dart';
import 'cards_screen.dart';
import 'garage_screen.dart';
import 'rewards_screen.dart';
import 'paywall_screen.dart';

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    if (index == 4) {
      // Direct club pass paywall
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PaywallScreen()),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final List<Widget> screens = [
      DashboardScreen(onNavigateToTab: (idx) => setState(() => _currentIndex = idx)),
      const CardsScreen(),
      const GarageScreen(),
      const RewardsScreen(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(icon: Icons.radar, label: 'Radar', index: 0),
                _buildNavItem(icon: Icons.credit_card, label: 'Cards', index: 1),
                _buildNavItem(icon: Icons.directions_car, label: 'Garage', index: 2),
                _buildNavItem(icon: Icons.stars, label: 'Rewards', index: 3),
                _buildClubNavItem(appState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppTheme.goldAccent : AppTheme.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? AppTheme.goldAccent : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubNavItem(AppState appState) {
    final isBlack = appState.isBlackEdition;
    final isGold = appState.tier == SubscriptionTier.gold;

    return GestureDetector(
      onTap: () => _onTabSelected(4),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isBlack
              ? AppTheme.goldAccent.withValues(alpha: 0.2)
              : (isGold ? AppTheme.goldAccent.withValues(alpha: 0.1) : AppTheme.surfaceCard),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isBlack || isGold ? AppTheme.goldAccent : AppTheme.surfaceBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium,
              size: 16,
              color: isBlack || isGold ? AppTheme.goldAccent : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              isBlack ? 'BLACK' : (isGold ? 'GOLD' : 'UPGRADE'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isBlack || isGold ? AppTheme.goldAccentLight : Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

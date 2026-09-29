import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/subscription_tier.dart';

class CoinCounter extends StatelessWidget {
  final int coins;
  final SubscriptionTier tier;
  final VoidCallback? onTap;

  const CoinCounter({
    super.key,
    required this.coins,
    required this.tier,
    this.onTap,
  });

  String _getMultiplier() {
    switch (tier) {
      case SubscriptionTier.black:
        return '5X';
      case SubscriptionTier.gold:
        return '2X';
      case SubscriptionTier.free:
        return '1X';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: tier == SubscriptionTier.black
                ? AppTheme.goldAccent
                : AppTheme.surfaceBorder,
            width: 1,
          ),
          boxShadow: [
            if (tier == SubscriptionTier.black)
              BoxShadow(
                color: AppTheme.goldAccent.withValues(alpha: 0.2),
                blurRadius: 10,
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
                shape: BoxShape.circle,
                gradient: AppTheme.goldGradient,
              ),
              child: const Icon(Icons.monetization_on, size: 14, color: Colors.black),
            ),
            const SizedBox(width: 8),
            Text(
              formatter.format(coins),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.goldAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _getMultiplier(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.goldAccentLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

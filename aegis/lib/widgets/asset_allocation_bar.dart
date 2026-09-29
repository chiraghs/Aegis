import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/asset_model.dart';
import '../providers/app_state.dart';

class AssetAllocationBar extends StatelessWidget {
  final AppState appState;

  const AssetAllocationBar({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.compactSimpleCurrency();
    final total = appState.totalAssetValue;
    if (total <= 0) return const SizedBox.shrink();

    final slices = [
      _AllocationSlice(AssetCategory.investments, appState.investmentAssets),
      _AllocationSlice(AssetCategory.realEstate, appState.realEstateAssets),
      _AllocationSlice(AssetCategory.vehicles, appState.vehicleAssets),
      _AllocationSlice(AssetCategory.cash, appState.cashAssets),
      _AllocationSlice(AssetCategory.retirement, appState.retirementAssets),
      _AllocationSlice(AssetCategory.crypto, appState.cryptoAssets),
    ].where((s) => s.amount > 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Proportional Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            child: Row(
              children: slices.map((slice) {
                final flex = ((slice.amount / total) * 1000).round();
                return Expanded(
                  flex: flex > 0 ? flex : 1,
                  child: Container(
                    color: slice.category.color,
                    margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Legend Grid
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: slices.map((slice) {
            final pct = (slice.amount / total) * 100;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: slice.category.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  slice.category.label.split('&').first.trim(),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${pct.toStringAsFixed(0)}% (${currency.format(slice.amount)})',
                  style: TextStyle(
                    fontSize: 10,
                    color: slice.category.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AllocationSlice {
  final AssetCategory category;
  final double amount;

  _AllocationSlice(this.category, this.amount);
}

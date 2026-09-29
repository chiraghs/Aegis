import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/garage_extras_model.dart';
import '../providers/app_state.dart';

class GarageRewardsMeter extends StatefulWidget {
  final AppState appState;

  const GarageRewardsMeter({
    super.key,
    required this.appState,
  });

  @override
  State<GarageRewardsMeter> createState() => _GarageRewardsMeterState();
}

class _GarageRewardsMeterState extends State<GarageRewardsMeter> {
  bool _claimedSeptemberDrop = false;

  void _claimSeptemberDrop() {
    if (_claimedSeptemberDrop) return;

    setState(() {
      _claimedSeptemberDrop = true;
    });

    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = widget.appState.isDarkMode;

        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF161922) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.electric_bolt, color: AppTheme.accentEmerald, size: 28),
              const SizedBox(width: 10),
              const Text(
                'YOU WON!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shell EV Free 22kW Turbo Charging Session',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Congratulations on crossing ₹2,500 spends in September! Your voucher code has been added to your vault.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF222634) : const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.accentEmerald.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SHELL-SEP-FREE-26',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Icon(Icons.check_circle, color: AppTheme.accentEmerald, size: 20),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('AWESOME', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  void _showAddSpendDialog(BuildContext context) {
    final merchantCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = 'FUEL';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.appState.isDarkMode ? const Color(0xFF161922) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isDark = widget.appState.isDarkMode;

          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LOG VEHICLE SPEND',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Earn 5% instant cashback in Aegis Coins on verified fuel, service, and toll receipts.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 20),

                // Category chips
                Wrap(
                  spacing: 8,
                  children: ['FUEL', 'SERVICE', 'TOLLS', 'OTHERS'].map((cat) {
                    final isSel = category == cat;
                    return ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isSel ? Colors.black : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                      selected: isSel,
                      selectedColor: AppTheme.accentGold,
                      backgroundColor: isDark ? const Color(0xFF222634) : const Color(0xFFECEFF6),
                      onSelected: (val) {
                        if (val) setSheetState(() => category = cat);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Merchant
                TextField(
                  controller: merchantCtrl,
                  decoration: InputDecoration(
                    labelText: 'Merchant / Station Name',
                    hintText: 'e.g. Shell EV / HPCL / VFM Honda',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF222634) : const Color(0xFFF4F6FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Amount
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (₹)',
                    hintText: 'e.g. 500',
                    prefixText: '₹ ',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF222634) : const Color(0xFFF4F6FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
                      final merchant = merchantCtrl.text.trim();
                      if (amt <= 0 || merchant.isEmpty) return;

                      final newSpend = VehicleSpendItem(
                        id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
                        category: category,
                        merchant: merchant,
                        amount: amt,
                        date: DateTime.now(),
                        icon: category == 'FUEL'
                            ? Icons.local_gas_station
                            : category == 'SERVICE'
                                ? Icons.build
                                : Icons.more_horiz,
                      );

                      widget.appState.vehicleSpends.insert(0, newSpend);
                      Navigator.pop(ctx);
                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logged ₹$amt spend! Earned ${(amt * 0.05).toInt()} Aegis Coins.'),
                          backgroundColor: AppTheme.accentEmerald,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'ADD SPEND & CLAIM COINS',
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkMode;
    final totalSpend = widget.appState.totalSeptemberSpend;
    final spends = widget.appState.vehicleSpends;
    final currencyFormatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    // Milestones for the September Rewards Meter
    const double targetSpend = 5000.0;
    final progress = (totalSpend / targetSpend).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'september rewards meter',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontFamily: 'serif',
              letterSpacing: 0.2,
              color: isDark ? Colors.white : const Color(0xFF161922),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'WIN REWARDS ON EVERY VEHICLE SPEND',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 18),

          // Segmented Metallic Battery Meter Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161922) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? const Color(0xFF282C3D) : const Color(0xFFE2E6EF),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Spend Progress Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL SPENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      'GOAL: ₹5,000',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      currencyFormatter.format(totalSpend),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF12141C),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.accentEmerald.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}% COMPLETED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.accentEmerald,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Segmented Progress Bar (Battery Style)
                Stack(
                  children: [
                    // Background track
                    Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232736) : const Color(0xFFEDF0F7),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    // Animated Fill
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
                          ),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00C853).withValues(alpha: 0.45),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Checkpoints Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMilestonePill('₹500', isReached: totalSpend >= 500, isDark: isDark),
                    _buildMilestonePill('₹1,500', isReached: totalSpend >= 1500, isDark: isDark),
                    _buildMilestonePill('₹2,500', isReached: totalSpend >= 2500, isDark: isDark),
                    _buildMilestonePill('₹5,000', isReached: totalSpend >= 5000, isDark: isDark),
                  ],
                ),
                const SizedBox(height: 20),

                // YOU WON Drop Card (Exact match to screenshot)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF222634), const Color(0xFF1A1D27)]
                          : [const Color(0xFFF7F8FC), const Color(0xFFEDF1F8)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF33384B) : const Color(0xFFD6DBE8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accentEmerald,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'YOU WON',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            'UNLOCKED AT ₹2,500',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Shell EV Free 22kW Turbo Charging Session',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF141720),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Valid at all 450+ Shell EV fast chargers across India.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Claim Button
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _claimedSeptemberDrop ? null : _claimSeptemberDrop,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _claimedSeptemberDrop
                                ? (isDark ? const Color(0xFF2B2F3D) : const Color(0xFFDDE1EB))
                                : (isDark ? Colors.white : Colors.black),
                            foregroundColor: _claimedSeptemberDrop
                                ? (isDark ? Colors.white38 : Colors.black38)
                                : (isDark ? Colors.black : Colors.white),
                            elevation: _claimedSeptemberDrop ? 0 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _claimedSeptemberDrop ? 'REWARD CLAIMED ✓' : 'CLAIM REWARD',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Next Reward Teaser
                      Row(
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: AppTheme.accentGold),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'NEXT REWARD: ₹1,000 Fuel voucher at ₹5,000 spend',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF444444),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Spends Section Header (Matching reference)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SPENDS IN SEP 2026',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  color: isDark ? Colors.white70 : const Color(0xFF252A37),
                ),
              ),
              InkWell(
                onTap: () => _showAddSpendDialog(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline, size: 16, color: AppTheme.accentGold),
                      const SizedBox(width: 4),
                      Text(
                        'LOG SPEND',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppTheme.accentGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Itemized Spend List Container (Matching reference items)
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161922) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF282C3D) : const Color(0xFFE2E6EF),
                width: 1.5,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: spends.length,
              separatorBuilder: (ctx, i) => Divider(
                height: 1,
                color: isDark ? const Color(0xFF252938) : const Color(0xFFEAEFF8),
              ),
              itemBuilder: (ctx, i) {
                final spend = spends[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF232736) : const Color(0xFFF1F3F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          spend.icon,
                          size: 20,
                          color: isDark ? Colors.white70 : const Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spend.merchant,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF12141A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spend.category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currencyFormatter.format(spend.amount),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF12141A),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonePill(String label, {required bool isReached, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isReached
            ? AppTheme.accentEmerald.withValues(alpha: 0.15)
            : (isDark ? const Color(0xFF202330) : const Color(0xFFEDF0F7)),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isReached ? AppTheme.accentEmerald : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isReached ? Icons.check : Icons.card_giftcard,
            size: 12,
            color: isReached ? AppTheme.accentEmerald : AppTheme.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isReached
                  ? AppTheme.accentEmerald
                  : (isDark ? Colors.white54 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

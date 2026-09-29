import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';
import '../services/layers_growth_service.dart';
import 'glass_container.dart';

class ReferralGrowthLoopWidget extends StatefulWidget {
  final AppState appState;

  const ReferralGrowthLoopWidget({super.key, required this.appState});

  @override
  State<ReferralGrowthLoopWidget> createState() => _ReferralGrowthLoopWidgetState();
}

class _ReferralGrowthLoopWidgetState extends State<ReferralGrowthLoopWidget> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _showEnterCodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCardElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('REDEEM VIP REFERRAL CODE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter a friend’s Aegis VIP code to unlock an instant 500 Aegis Coins bonus.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, letterSpacing: 2),
              decoration: InputDecoration(
                hintText: 'e.g. AEGIS-VIP-771',
                hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CANCEL', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              final code = _codeController.text.trim();
              if (code.isEmpty) return;

              final success = LayersGrowthService.instance.applyReferralCode(code);
              Navigator.of(ctx).pop();

              if (success) {
                widget.appState.addBonusCoins(500);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('🎉 VIP code applied! +500 Aegis Coins added to your vault!'),
                    backgroundColor: AppTheme.emeraldAccent,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Invalid or already claimed referral code.'),
                    backgroundColor: AppTheme.crimsonAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldAccent,
              foregroundColor: Colors.black,
            ),
            child: const Text('CLAIM +500', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = LayersGrowthService.instance.userReferralCode;
    final referrals = LayersGrowthService.instance.successfulReferrals;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassContainer(
        borderColor: const Color(0xFF64B5F6).withValues(alpha: 0.35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.loop, size: 14, color: Color(0xFF64B5F6)),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'GROWTH LOOP VIP PASS',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64B5F6), letterSpacing: 1.2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF64B5F6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+${referrals * 500} COINS',
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF64B5F6)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Give 500 coins to fellow cardholders, earn 500 coins when they clear their first external statement.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(code, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1, color: AppTheme.textPrimary)),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('VIP Referral Code copied to clipboard!')),
                            );
                          },
                          child: Icon(Icons.copy, size: 14, color: AppTheme.goldAccent),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _showEnterCodeDialog,
                  child: Text('Enter Code', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.goldAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

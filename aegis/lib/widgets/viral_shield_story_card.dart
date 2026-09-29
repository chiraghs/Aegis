import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';

class ViralShieldStoryModal extends StatefulWidget {
  final AppState appState;

  const ViralShieldStoryModal({super.key, required this.appState});

  static void show(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ViralShieldStoryModal(appState: appState),
    );
  }

  @override
  State<ViralShieldStoryModal> createState() => _ViralShieldStoryModalState();
}

class _ViralShieldStoryModalState extends State<ViralShieldStoryModal> {
  bool _maskValues = false;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.compactSimpleCurrency();
    final appState = widget.appState;
    final topVehicle = appState.vehicles.isNotEmpty ? appState.vehicles.first : null;
    final topCard = appState.cards.isNotEmpty ? appState.cards.first : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FLEX YOUR SHIELD STORY',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                ),
                Row(
                  children: [
                    Text(_maskValues ? 'Masked' : 'Public', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    Switch(
                      value: !_maskValues,
                      activeThumbColor: AppTheme.goldAccent,
                      activeTrackColor: AppTheme.goldAccent.withValues(alpha: 0.4),
                      onChanged: (val) => setState(() => _maskValues = !val),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                // 9:16 Vertical Story Aspect Container
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B1B26), Color(0xFF0D0D15), Color(0xFF07070A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Story Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppTheme.goldGradient,
                                  ),
                                  child: const Center(
                                    child: Text('Æ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('AEGIS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 2)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.goldAccent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                appState.isBlackEdition ? 'BLACK EDITION' : 'CENTURION TIER',
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.goldAccent),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Centerpiece: Shield Score & Status
                        const Text(
                          'FINANCIAL RADAR SHIELD',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textMuted, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '840',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.emeraldAccent, letterSpacing: -1),
                        ),
                        const Text(
                          'Top 2% Credit Discipline in the US',
                          style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 20),

                        // Stats Grid
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.surfaceBorder),
                          ),
                          child: Column(
                            children: [
                              _buildStoryRow(
                                'On-Time Streak',
                                '${appState.rewards.streakDays} Cycles Clear',
                                Icons.local_fire_department,
                                const Color(0xFFFF9100),
                              ),
                              const Divider(color: AppTheme.surfaceBorder, height: 16),
                              _buildStoryRow(
                                'Net Asset Radar',
                                _maskValues ? '••••••••' : currency.format(appState.netWorth),
                                Icons.shield,
                                AppTheme.emeraldAccent,
                              ),
                              if (topVehicle != null) ...[
                                const Divider(color: AppTheme.surfaceBorder, height: 16),
                                _buildStoryRow(
                                  'Garage Anchor',
                                  '${topVehicle.year} ${topVehicle.model}',
                                  Icons.directions_car,
                                  AppTheme.cyanAccent,
                                ),
                              ],
                              if (topCard != null) ...[
                                const Divider(color: AppTheme.surfaceBorder, height: 16),
                                _buildStoryRow(
                                  'Primary Card',
                                  topCard.cardName,
                                  Icons.credit_card,
                                  AppTheme.goldAccent,
                                ),
                              ],
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Footer watermark
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('shipaton.aegis.finance', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                            Text('#Shipaton2026', style: TextStyle(fontSize: 10, color: AppTheme.goldAccent.withValues(alpha: 0.8), fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Action: Share to Socials
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    const ClipboardData(
                      text: 'Check out my Aegis Wealth & Garage Shield (Score: 840)! 🛡️ Track credit liabilities without moving funds: https://github.com/chiraghs/Aegis #Shipaton #BuildInPublic #AegisFintech',
                    ),
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('📱 Viral Story link & text copied! Ready to post to Instagram, X, or TikTok.'),
                      backgroundColor: AppTheme.emeraldAccent,
                    ),
                  );
                },
                icon: const Icon(Icons.share, size: 18),
                label: const Text('SHARE TO INSTAGRAM / X / TIKTOK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
      ],
    );
  }
}

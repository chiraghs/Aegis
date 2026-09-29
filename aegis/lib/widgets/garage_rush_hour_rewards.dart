import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../models/garage_extras_model.dart';
import '../providers/app_state.dart';

class GarageRushHourRewards extends StatefulWidget {
  final AppState appState;

  const GarageRushHourRewards({
    super.key,
    required this.appState,
  });

  @override
  State<GarageRushHourRewards> createState() => _GarageRushHourRewardsState();
}

class _GarageRushHourRewardsState extends State<GarageRushHourRewards> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleClaim(RushHourRewardModel reward) {
    if (reward.isClaimed) return;

    final success = widget.appState.claimRushHourReward(reward.id);
    if (!success) return;

    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = widget.appState.isDarkMode;
        final voucherCode = 'AEGIS-${reward.id.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF161922) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.stars, color: AppTheme.accentGold, size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'REWARD UNLOCKED!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reward.title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Awarded +500 Aegis Coins to your vault. Here is your official partner redemption voucher code:',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF222634) : const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.accentGold.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      voucherCode,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: voucherCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voucher code copied to clipboard!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('DONE', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkMode;
    final rewards = widget.appState.rushHourRewards;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE5A93C), Color(0xFFFFD56B)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'RUSH HOUR REWARDS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: isDark ? Colors.white : const Color(0xFF11141D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'unlocks every day at peak traffic hours. 6pm.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF202330) : const Color(0xFFE8EBF2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: AppTheme.accentGold),
                      const SizedBox(width: 4),
                      Text(
                        '6:00 PM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Podium Carousel
          SizedBox(
            height: 290,
            child: PageView.builder(
              controller: _pageController,
              itemCount: rewards.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final reward = rewards[index];
                final isSelected = index == _currentPage;

                return AnimatedScale(
                  scale: isSelected ? 1.0 : 0.94,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: _buildPodiumRewardCard(reward, isDark),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Carousel Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(rewards.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? (isDark ? Colors.white : Colors.black)
                      : (isDark ? Colors.white24 : Colors.black12),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumRewardCard(RushHourRewardModel reward, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171922) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF282C3D) : const Color(0xFFE2E6EF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle radiant spotlight
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentGold.withValues(alpha: isDark ? 0.12 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag & Value Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232838) : const Color(0xFFECEFF6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        reward.categoryTag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: isDark ? const Color(0xFFFFC043) : const Color(0xFF996500),
                        ),
                      ),
                    ),
                    Text(
                      reward.valueText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white70 : const Color(0xFF444444),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Center Icon / 3D Podium Graphic Representation
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF2C3246), const Color(0xFF191C26)]
                            : [const Color(0xFFF2F4F8), const Color(0xFFDFE4EE)],
                      ),
                      border: Border.all(
                        color: isDark ? const Color(0xFF3F465F) : const Color(0xFFCCD2E0),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGold.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      reward.icon,
                      size: 36,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),

                const Spacer(),

                // Reward Title
                Text(
                  reward.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: isDark ? Colors.white : const Color(0xFF12141A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reward.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // 3D Futuristic Claim Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: reward.isClaimed ? null : () => _handleClaim(reward),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: reward.isClaimed
                          ? (isDark ? const Color(0xFF252936) : const Color(0xFFE0E3EA))
                          : (isDark ? Colors.white : Colors.black),
                      foregroundColor: reward.isClaimed
                          ? (isDark ? Colors.white38 : Colors.black38)
                          : (isDark ? Colors.black : Colors.white),
                      elevation: reward.isClaimed ? 0 : 4,
                      shadowColor: isDark ? Colors.white24 : Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (reward.isClaimed) ...[
                          const Icon(Icons.check_circle, size: 16),
                          const SizedBox(width: 8),
                          const Text(
                            'CLAIMED',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ] else ...[
                          const Text(
                            'CLAIM NOW',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

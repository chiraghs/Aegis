import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../services/onesignal_service.dart';

class NotificationsInboxScreen extends StatefulWidget {
  const NotificationsInboxScreen({super.key});

  @override
  State<NotificationsInboxScreen> createState() => _NotificationsInboxScreenState();
}

class _NotificationsInboxScreenState extends State<NotificationsInboxScreen> {
  void _triggerSamplePush() {
    OneSignalService.instance.simulateIncomingPush(
      title: '⚡ 3-DAY RADAR: AMEX DUE SOON',
      body: 'External statement balance detected. Avoid late fees & mint double coins by clearing before Oct 2nd.',
      type: OneSignalNotificationType.dueAlert,
    );
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Simulated incoming OneSignal push notification!'),
        backgroundColor: AppTheme.emeraldAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inbox = OneSignalService.instance.inbox;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'ONESIGNAL RADAR INBOX',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                OneSignalService.instance.markAllAsRead();
              });
            },
            child: Text('Mark Read', style: TextStyle(color: AppTheme.goldAccent, fontSize: 11, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner explaining OneSignal Keep Them Coming Back integration
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE54B4B).withValues(alpha: 0.15),
                  AppTheme.surfaceCard,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE54B4B).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE54B4B).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active, color: Color(0xFFE54B4B), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ONESIGNAL RETENTION ENGINE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFE54B4B), letterSpacing: 1),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'App ID: ${OneSignalService.appId.substring(0, 8)}... • Automated 3-day radar push journeys enabled.',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: _triggerSamplePush,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE54B4B)),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Test Push', style: TextStyle(color: Color(0xFFE54B4B), fontSize: 10, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),

          // Notification List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: inbox.length,
              itemBuilder: (ctx, i) {
                final item = inbox[i];
                final timeStr = DateFormat.jm().format(item.timestamp);

                Color typeColor;
                IconData typeIcon;
                switch (item.type) {
                  case OneSignalNotificationType.dueAlert:
                    typeColor = AppTheme.crimsonAccent;
                    typeIcon = Icons.timer_outlined;
                    break;
                  case OneSignalNotificationType.rewardDrop:
                    typeColor = AppTheme.goldAccent;
                    typeIcon = Icons.stars;
                    break;
                  case OneSignalNotificationType.safetyBulletin:
                    typeColor = AppTheme.cyanAccent;
                    typeIcon = Icons.shield_outlined;
                    break;
                  case OneSignalNotificationType.growthDrop:
                    typeColor = const Color(0xFFB388FF);
                    typeIcon = Icons.auto_awesome;
                    break;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: item.isRead ? AppTheme.surfaceCard : AppTheme.surfaceCardElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: item.isRead ? AppTheme.surfaceBorder : typeColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(typeIcon, color: typeColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: item.isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                Text(
                                  timeStr,
                                  style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.body,
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35),
                            ),
                          ],
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
}

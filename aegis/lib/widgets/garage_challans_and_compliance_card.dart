import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';

class GarageChallansAndComplianceCard extends StatelessWidget {
  final AppState appState;

  const GarageChallansAndComplianceCard({
    super.key,
    required this.appState,
  });

  void _showCitationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final unpaid = appState.challans.where((c) => !c.isPaid).toList();

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.crimsonAccent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.receipt_long, color: AppTheme.crimsonAccent, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'TRAFFIC & PARKING CITATIONS',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Connected to Municipal Automated Camera & Parking Network for ${appState.activeVehicle.licensePlate}.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 16),

                if (unpaid.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.emeraldAccent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.emeraldAccent, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CLEAN DRIVING RECORD',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Zero pending municipal citations or camera tickets.',
                                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...unpaid.map((citation) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCardElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.crimsonAccent.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  citation.violationType,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                ),
                              ),
                              Text(
                                '\$${citation.amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.crimsonAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                              const SizedBox(width: 4),
                              Text(citation.location, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Citation #: ${citation.citationNumber}',
                            style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontFamily: 'monospace'),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {
                                appState.payChallan(citation.id);
                                setModalState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Citation paid! Earned ${(citation.amount * 2).toInt()} Aegis Coins.'),
                                    backgroundColor: AppTheme.emeraldAccent,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.goldAccent,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                'PAY NOW • EARN ${(citation.amount * 2).toInt()} COINS',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDmvAndRecallsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.verified, color: AppTheme.emeraldAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'DMV REGISTRATION & SMOG',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Registration Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Icon(Icons.directions_car, color: AppTheme.cyanAccent, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('State DMV Registration', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          'Valid thru March 2027 • Plate ${appState.activeVehicle.licensePlate}',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.emeraldAccent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Smog / Safety Inspection Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Icon(Icons.eco, color: AppTheme.emeraldAccent, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Smog & Safety Inspection', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          'BAR Certified • Valid thru Sep 2027',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'PASSED',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.emeraldAccent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // NHTSA Safety Recalls Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: appState.activeVehicle.recalls.isNotEmpty
                      ? AppTheme.crimsonAccent.withValues(alpha: 0.4)
                      : AppTheme.surfaceBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: appState.activeVehicle.recalls.isNotEmpty ? AppTheme.crimsonAccent : AppTheme.goldAccent,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('US NHTSA Safety Recalls', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(
                              'Live from api.nhtsa.gov for ${appState.activeVehicle.make} ${appState.activeVehicle.model} (${appState.activeVehicle.year})',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: appState.activeVehicle.recalls.isNotEmpty
                              ? AppTheme.crimsonAccent.withValues(alpha: 0.15)
                              : AppTheme.emeraldAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          appState.activeVehicle.recalls.isNotEmpty
                              ? '${appState.activeVehicle.recalls.length} RECALLS'
                              : 'CLEAR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: appState.activeVehicle.recalls.isNotEmpty ? AppTheme.crimsonAccent : AppTheme.emeraldAccent,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // If real recalls returned from official US NHTSA API, render each campaign!
                  if (appState.activeVehicle.recalls.isNotEmpty) ...[
                    const Divider(height: 20),
                    ...appState.activeVehicle.recalls.take(4).map((rec) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Campaign: ${rec.campaignNumber}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.goldAccent,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.goldAccent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'FREE REMEDY',
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rec.component,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rec.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10, color: AppTheme.textSecondary, height: 1.3),
                            ),
                            if (rec.remedy.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Remedy: ${rec.remedy}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10, color: AppTheme.emeraldAccent, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Button to Re-Check NHTSA Live
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await appState.refreshActiveVehicleNhtsaData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Refreshed live from official US NHTSA servers!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  foregroundColor: AppTheme.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.sync, size: 16),
                label: const Text('Live NHTSA Re-Check', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unpaidCount = appState.unpaidChallansCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Citations Dual Card
          Expanded(
            child: GestureDetector(
              onTap: () => _showCitationsModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.surfaceBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: appState.isDarkMode ? 0.3 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: unpaidCount > 0
                            ? AppTheme.crimsonAccent.withValues(alpha: 0.12)
                            : AppTheme.surfaceCardElevated,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt,
                        size: 24,
                        color: unpaidCount > 0 ? AppTheme.crimsonAccent : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      appState.activeVehicle.make.toLowerCase().contains('honda') || appState.activeVehicle.licensePlate.startsWith('KA')
                          ? 'challans'
                          : 'citations',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unpaidCount > 0 ? '$unpaidCount UNPAID' : 'CHECK NOW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: unpaidCount > 0 ? AppTheme.crimsonAccent : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // DMV & Smog / PUCC Dual Card
          Expanded(
            child: GestureDetector(
              onTap: () => _showDmvAndRecallsModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.surfaceBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: appState.isDarkMode ? 0.3 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCardElevated,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        appState.activeVehicle.make.toLowerCase().contains('honda') || appState.activeVehicle.licensePlate.startsWith('KA')
                            ? Icons.tire_repair
                            : Icons.verified_outlined,
                        size: 24,
                        color: appState.activeVehicle.make.toLowerCase().contains('honda') || appState.activeVehicle.licensePlate.startsWith('KA')
                            ? AppTheme.textSecondary
                            : AppTheme.emeraldAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      appState.activeVehicle.make.toLowerCase().contains('honda') || appState.activeVehicle.licensePlate.startsWith('KA')
                          ? 'PUCC'
                          : 'DMV & smog',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appState.activeVehicle.make.toLowerCase().contains('honda') || appState.activeVehicle.licensePlate.startsWith('KA')
                          ? 'NOT AVAILABLE'
                          : 'VALID THRU 2027',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: appState.activeVehicle.make.toLowerCase().contains('honda') || appState.activeVehicle.licensePlate.startsWith('KA')
                            ? AppTheme.textMuted
                            : AppTheme.emeraldAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

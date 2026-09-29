import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';

class GarageChallansAndComplianceCard extends StatelessWidget {
  final AppState appState;

  const GarageChallansAndComplianceCard({
    super.key,
    required this.appState,
  });

  void _showChallansModal(BuildContext context) {
    final currency = appState.isDarkMode ? '₹' : '₹';

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
                          'TRAFFIC CHALLANS & CITATIONS',
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
                  'Connected to State Transport Automated Camera Network for ${appState.activeVehicle.licensePlate}.',
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
                                'CLEAN TRAFFIC RECORD',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Zero pending violations or traffic fines recorded.',
                                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...unpaid.map((challan) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCardElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.crimsonAccent.withValues(alpha: 0.3)),
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
                                  color: AppTheme.crimsonAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  challan.citationNumber,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.crimsonAccent),
                                ),
                              ),
                              Text(
                                '$currency${challan.amount.toInt()}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.crimsonAccent),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            challan.violationType,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${challan.location}',
                            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mints 2X (+${(challan.amount * 2).toInt()}) Aegis Coins',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.goldAccent),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  appState.payChallan(challan.id);
                                  setModalState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Fine settled! +${(challan.amount * 2).toInt()} Aegis Coins minted!'),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.goldAccent,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Settle Fine', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPuccAndRecallsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                      child: Icon(Icons.verified_user, color: AppTheme.emeraldAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'SAFETY & EMISSIONS COMPLIANCE',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PUCC EMISSIONS CERTIFICATE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'VALID',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'National Green Tribunal BS-VI compliant. Valid till 31 Dec 2026.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCardElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'US NHTSA SAFETY RECALL AUDIT',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '0 RECALLS',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'VIN: ${appState.activeVehicle.vin}\nVerified against NHTSA safety defect database. Zero outstanding open safety recalls.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
          // Challans Dual Card
          Expanded(
            child: GestureDetector(
              onTap: () => _showChallansModal(context),
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
                      'challans',
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

          // PUCC / Compliance Dual Card
          Expanded(
            child: GestureDetector(
              onTap: () => _showPuccAndRecallsModal(context),
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
                        Icons.donut_large,
                        size: 24,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'PUCC',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'VALID TILL DEC',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppTheme.emeraldAccent,
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

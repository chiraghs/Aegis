import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';

class GarageGloveboxCard extends StatelessWidget {
  final AppState appState;

  const GarageGloveboxCard({
    super.key,
    required this.appState,
  });

  void _showGloveboxModal(BuildContext context) {
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
                        color: AppTheme.cyanAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.folder_shared_outlined, color: AppTheme.cyanAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'DIGITAL GLOVEBOX VAULT',
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
            const SizedBox(height: 8),
            Text(
              'Encrypted cloud synchronization with DigiLocker & National Transport Registry.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),

            ...appState.gloveboxDocs.map((doc) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCardElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.goldAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getDocIcon(doc.docType), color: AppTheme.goldAccent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                doc.title,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                              ),
                              const SizedBox(width: 6),
                              if (doc.isDigiLockerVerified)
                                const Icon(Icons.verified, size: 14, color: Color(0xFF10B981)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${doc.docNumber} • ${doc.issuingAuthority}',
                            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening verified copy of ${doc.title}...')),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  IconData _getDocIcon(String docType) {
    switch (docType) {
      case 'RC':
        return Icons.directions_car;
      case 'DL':
        return Icons.badge;
      case 'Insurance':
        return Icons.security;
      case 'PUCC':
        return Icons.eco;
      default:
        return Icons.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = appState.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header: "YOUR GLOVEBOX"
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'YOUR GLOVEBOX',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // Glovebox Card (Exact match with reference image Link Docs.jpeg)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RC, DL, policy docs:\nstore them all in a\ndigital glovebox',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Dots indicator
                          Row(
                            children: [
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: AppTheme.textPrimary, borderRadius: BorderRadius.circular(2))),
                              const SizedBox(width: 4),
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: AppTheme.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
                              const SizedBox(width: 4),
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: AppTheme.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Document stack graphic with DigiLocker badge
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.surfaceCardElevated : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.folder_copy, size: 48, color: AppTheme.textSecondary.withValues(alpha: 0.7)),
                          Positioned(
                            bottom: 8,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFF7C3AED),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.priority_high, color: Colors.white, size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Link to DigiLocker Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _showGloveboxModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cloud_done_outlined, size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Link to digilocker  →',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5),
                        ),
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

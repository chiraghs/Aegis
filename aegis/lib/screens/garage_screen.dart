import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../providers/app_state.dart';
import '../widgets/garage_vehicle_3d_stage.dart';
import '../widgets/garage_challans_and_compliance_card.dart';
import '../widgets/garage_insurance_hub.dart';
import '../widgets/garage_glovebox_card.dart';
import '../widgets/garage_rush_hour_rewards.dart';
import 'paywall_screen.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  final TextEditingController _vinController = TextEditingController();
  bool _isLoadingVin = false;

  void _showAddVehicleModal(BuildContext context, AppState appState) {
    if (!appState.canAddMoreVehicles) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'GARAGE LIMIT REACHED',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          content: Text(
            'Aegis Member (Free) tier includes up to 5 vehicles in your garage.\n\nUpgrade to Gold Pass or Black Edition with RevenueCat to unlock unlimited vehicle tracking, real-time telematics, and NHTSA safety recall alerts.',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PaywallScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                foregroundColor: Colors.black,
              ),
              child: const Text('Upgrade Pass', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );
      return;
    }

    final isDark = appState.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ADD VEHICLE TO GARAGE',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Enter 17-digit VIN for instant NHTSA government specification lookup and valuation.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _vinController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'e.g. 5YJ3E1EB8KF194821',
                  hintStyle: TextStyle(color: AppTheme.textSecondary, letterSpacing: 1),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF222634) : const Color(0xFFF3F5FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.directions_car, color: AppTheme.accentGold),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ActionChip(
                    label: const Text('Tesla Model 3', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    onPressed: () => _vinController.text = '5YJ3E1EB8KF194821',
                  ),
                  ActionChip(
                    label: const Text('Porsche Taycan 4S', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    onPressed: () => _vinController.text = 'WP0AB2Y14MSA83921',
                  ),
                  ActionChip(
                    label: const Text('Ford Mustang GT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    onPressed: () => _vinController.text = '1FA6P8CF5L5100000',
                  ),
                  ActionChip(
                    label: const Text('BMW 330e EV', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    onPressed: () => _vinController.text = 'WBA8E1C55JKA00000',
                  ),
                  ActionChip(
                    label: const Text('Rivian R1T Truck', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    onPressed: () => _vinController.text = '7FCTGAAA3NN000000',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoadingVin
                      ? null
                      : () async {
                          final vin = _vinController.text.trim();
                          if (vin.length < 5) return;

                          setModalState(() => _isLoadingVin = true);
                          await appState.addVehicleByVin(vin);
                          if (!mounted) return;
                          setModalState(() => _isLoadingVin = false);

                          if (ctx.mounted) {
                            Navigator.of(ctx).pop();
                          }
                          _vinController.clear();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Vehicle decoded via NHTSA and added to Garage!')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoadingVin
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text(
                          'DECODE & ADD VEHICLE',
                          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Aegis US Garage 3D Rotatable Playground Stage
              GarageVehicle3DStage(
                appState: appState,
                onAddVehiclePressed: () => _showAddVehicleModal(context, appState),
              ),

              const SizedBox(height: 12),

              // 2. Traffic Challans ("CHECK NOW") & PUCC Dual-Card Grid
              GarageChallansAndComplianceCard(appState: appState),

              // 3. Insurance Hub (Active Policies + Sell & Buy Commission Marketplace)
              GarageInsuranceHub(appState: appState),

              // 4. Digital Glovebox Card (RC, DL, Policy docs linked to DigiLocker)
              GarageGloveboxCard(appState: appState),

              // 5. RUSH HOUR REWARDS Podium Carousel (Peak Traffic Hour Drops)
              GarageRushHourRewards(appState: appState),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

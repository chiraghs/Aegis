import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/vehicle_model.dart';
import '../providers/app_state.dart';
import '../widgets/glass_container.dart';
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
          backgroundColor: AppTheme.surfaceCardElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('GARAGE LIMIT REACHED', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
          content: const Text(
            'Aegis Member (Free) tier includes 1 vehicle in the garage.\n\nUpgrade to Gold Pass or Black Edition with RevenueCat to unlock unlimited vehicle tracking, real-time telematics, and NHTSA safety recall alerts.',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PaywallScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldAccent, foregroundColor: Colors.black),
              child: const Text('Upgrade Pass', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
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
                  const Text(
                    'ADD VEHICLE TO GARAGE',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
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
                  hintStyle: const TextStyle(color: AppTheme.textMuted, letterSpacing: 1),
                  filled: true,
                  fillColor: AppTheme.surfaceCardElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                  prefixIcon: const Icon(Icons.directions_car, color: AppTheme.cyanAccent),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Tesla Model 3 VIN', style: TextStyle(fontSize: 10)),
                    onPressed: () => _vinController.text = '5YJ3E1EB8KF194821',
                  ),
                  ActionChip(
                    label: const Text('Porsche 911 VIN', style: TextStyle(fontSize: 10)),
                    onPressed: () => _vinController.text = 'WP0AB2Y14MSA83921',
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
                          setModalState(() => _isLoadingVin = false);

                          if (mounted) {
                            Navigator.of(ctx).pop();
                            _vinController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Vehicle decoded via NHTSA and added to Garage!')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cyanAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoadingVin
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text('Decode & Add Vehicle', style: TextStyle(fontWeight: FontWeight.w800)),
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
    final currency = NumberFormat.simpleCurrency();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'AEGIS GARAGE',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.cyanAccent),
            onPressed: () => _showAddVehicleModal(context, appState),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Garage Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cyanAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.electric_car, size: 28, color: AppTheme.cyanAccent),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AUTOMOTIVE TELEMATICS & EQUITY',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, color: AppTheme.cyanAccent),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'NHTSA Recalls, Loan Equity & Service Tracker',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vehicle Cards
            Column(
              children: appState.vehicles.map((car) {
                return _buildVehicleCard(car, currency);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleModel car, NumberFormat currency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${car.year} ${car.make} ${car.model}'.toUpperCase(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      car.trim,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: car.activeRecalls == 0 ? AppTheme.emeraldAccent.withOpacity(0.15) : AppTheme.crimsonAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: car.activeRecalls == 0 ? AppTheme.emeraldAccent : AppTheme.crimsonAccent,
                    ),
                  ),
                  child: Text(
                    car.activeRecalls == 0 ? '✓ 0 RECALLS' : '${car.activeRecalls} RECALLS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: car.activeRecalls == 0 ? AppTheme.emeraldAccent : AppTheme.crimsonAccent,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.surfaceBorder, height: 24),

            // Metrics Grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('MARKET VALUE', style: TextStyle(fontSize: 9, color: AppTheme.textSecondary, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text(currency.format(car.estimatedMarketValue), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NET EQUITY', style: TextStyle(fontSize: 9, color: AppTheme.textSecondary, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text(
                        currency.format(car.positiveEquity),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(car.isElectric ? 'BATTERY' : 'FUEL', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text(
                        '${(car.fuelOrBatteryLevel * 100).toInt()}%',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.cyanAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // VIN & Service Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'VIN: ${car.vin.substring(0, 11)}••••••',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, letterSpacing: 1),
                ),
                Text(
                  'Service Due: ${DateFormat('MMM yyyy').format(car.nextServiceDate)}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.goldAccentLight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

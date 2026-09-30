import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../models/vehicle_model.dart';
import '../providers/app_state.dart';

class GarageVehicle3DStage extends StatefulWidget {
  final AppState appState;
  final VoidCallback onAddVehiclePressed;
  final VoidCallback onSettingsPressed;

  const GarageVehicle3DStage({
    super.key,
    required this.appState,
    required this.onAddVehiclePressed,
    required this.onSettingsPressed,
  });

  @override
  State<GarageVehicle3DStage> createState() => _GarageVehicle3DStageState();
}

class _GarageVehicle3DStageState extends State<GarageVehicle3DStage> with SingleTickerProviderStateMixin {
  double _rotationAngle = 0.15; // Initial slight angle
  double _tiltAngle = 0.05;
  late AnimationController _animController;
  Animation<double>? _resetAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _rotateToAngle(double targetAngle) {
    _resetAnimation = Tween<double>(begin: _rotationAngle, end: targetAngle).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    )..addListener(() {
        setState(() {
          _rotationAngle = _resetAnimation!.value;
        });
      });
    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.appState.activeVehicle;
    final isDark = widget.appState.isDarkMode;

    return Column(
      children: [
        // Top Bar: Back, Brand Emblem, Settings
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 24),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              _buildBrandEmblem(vehicle.make),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: AppTheme.textPrimary, size: 22),
                onPressed: widget.onSettingsPressed,
              ),
            ],
          ),
        ),

        // Vehicle Title: Editorial Serif (Exact match with reference)
        const SizedBox(height: 4),
        Text(
          '${_formatBrandTitle(vehicle.make)} ${vehicle.model}',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: AppTheme.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        // License Plate Badge (US State Plate)
        _buildLicensePlateBadge(vehicle.licensePlate, isDark),
        const SizedBox(height: 8),

        // Live US Government NHTSA VPIC Verification Badge
        GestureDetector(
          onTap: () => _showNhtsaSpecsModal(context, vehicle),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2230) : const Color(0xFFEDF0F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF2E344A) : const Color(0xFFD6DBE8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, size: 12, color: Color(0xFF10B981)),
                const SizedBox(width: 5),
                Text(
                  'NHTSA VERIFIED • ${vehicle.vin.substring(0, 8)}...  →',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Interactive 3D Playground Stage
        SizedBox(
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vehicle Switcher Thumbnails on Left
              Positioned(
                left: 16,
                top: 20,
                bottom: 20,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.appState.vehicles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final v = entry.value;
                      final isSelected = index == widget.appState.selectedVehicleIndex;
                      return GestureDetector(
                        onTap: () => widget.appState.selectGarageVehicle(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? const Color(0xFF222634) : const Color(0xFFE5E7EB))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppTheme.goldAccent : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  _getVehicleAsset(v),
                                  width: isSelected ? 34 : 26,
                                  height: isSelected ? 24 : 18,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    _getVehicleIcon(v),
                                    size: isSelected ? 20 : 16,
                                    color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
                                  ),

                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 16,
                                  height: 2,
                                  margin: const EdgeInsets.only(top: 4),
                                  color: AppTheme.goldAccent,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // 3D Center Stage with Drag-to-Rotate Gesture
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _rotationAngle += details.delta.dx * 0.015;
                    _tiltAngle = (_tiltAngle - details.delta.dy * 0.005).clamp(-0.15, 0.25);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.74,
                  height: 250,
                  color: Colors.transparent,
                  child: Center(
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012) // 3D Perspective
                        ..rotateY(_rotationAngle)
                        ..rotateX(_tiltAngle),
                      child: _build3DVehicleRepresentation(vehicle, isDark, _rotationAngle),
                    ),
                  ),
                ),
              ),


              // Add Vehicle "+" Circle Button on Right
              Positioned(
                right: 20,
                bottom: 30,
                child: GestureDetector(
                  onTap: widget.onAddVehiclePressed,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppTheme.surfaceCardElevated : Colors.white,
                      border: Border.all(color: AppTheme.surfaceBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, color: AppTheme.textPrimary, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3D Quick-Angle Selector Pills
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnglePill('360° Drag', () {}, isActive: true),
              const SizedBox(width: 8),
              _buildAnglePill('Front', () => _rotateToAngle(0.0)),
              const SizedBox(width: 8),
              _buildAnglePill('Side', () => _rotateToAngle(math.pi / 2)),
              const SizedBox(width: 8),
              _buildAnglePill('Rear', () => _rotateToAngle(math.pi)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatBrandTitle(String make) {
    if (make.isEmpty) return '';
    return make[0].toUpperCase() + make.substring(1).toLowerCase();
  }

  Widget _buildBrandEmblem(String make) {
    final lower = make.toLowerCase();
    Color emblemColor = Colors.redAccent;
    IconData emblemIcon = Icons.two_wheeler;
    String brandText = make.toUpperCase();

    if (lower.contains('honda')) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFCC0000),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.two_wheeler, size: 16, color: Colors.white),
          ),
          const SizedBox(height: 3),
          const Text(
            'HONDA',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: Color(0xFFCC0000),
            ),
          ),
        ],
      );
    } else if (lower.contains('tesla')) {
      emblemColor = const Color(0xFFE82127);
      emblemIcon = Icons.electric_car;
      brandText = 'TESLA';
    } else if (lower.contains('porsche')) {
      emblemColor = const Color(0xFFD4AF37);
      emblemIcon = Icons.sports_score;
      brandText = 'PORSCHE';
    } else if (lower.contains('ford')) {
      emblemColor = const Color(0xFF003478);
      emblemIcon = Icons.directions_car;
      brandText = 'FORD';
    } else if (lower.contains('bmw')) {
      emblemColor = const Color(0xFF0066B1);
      emblemIcon = Icons.adjust;
      brandText = 'BMW';
    } else if (lower.contains('rivian')) {
      emblemColor = const Color(0xFFE5A93C);
      emblemIcon = Icons.navigation;
      brandText = 'RIVIAN';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(emblemIcon, size: 24, color: emblemColor),
        const SizedBox(height: 2),
        Text(
          brandText,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: emblemColor,
          ),
        ),
      ],
    );
  }


  Widget _buildLicensePlateBadge(String plateNumber, bool isDark) {
    // Check if plate matches Indian HSRP registration format (e.g. KA13EW7454 or KA 13 EW 7454)
    final clean = plateNumber.replaceAll(' ', '').replaceAll('•', '').trim();
    final isIndianFormat = clean.toUpperCase().startsWith('IND') ||
        RegExp(r'^[A-Z]{2}\d{1,2}[A-Z]{0,3}\d{4}$', caseSensitive: false).hasMatch(clean);

    if (isIndianFormat) {
      final formattedNumber = clean.toUpperCase().replaceAll('IND', '');
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFD),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // High Security IND Blue Band
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0038A8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE5A93C), width: 1),
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'IND',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formattedNumber,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      );
    }

    // Otherwise render US State Plate
    String stateName = 'CALIFORNIA';
    String displayNumber = plateNumber;

    if (plateNumber.contains('•')) {
      final parts = plateNumber.split('•');
      final code = parts[0].trim().toUpperCase();
      displayNumber = parts[1].trim();
      stateName = switch (code) {
        'CA' => 'CALIFORNIA',
        'NY' => 'NEW YORK',
        'TX' => 'TEXAS',
        'WA' => 'WASHINGTON',
        'FL' => 'FLORIDA',
        _ => code,
      };
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // US State Header
          Text(
            stateName,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: Color(0xFFB91C1C), // Classic US state red header
            ),
          ),
          const SizedBox(height: 2),
          // Embossed Plate Digits
          Text(
            displayNumber.toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnglePill(String label, VoidCallback onTap, {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.goldAccent.withValues(alpha: 0.15) : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppTheme.goldAccent : AppTheme.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isActive ? AppTheme.goldAccent : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  IconData _getVehicleIcon(VehicleModel v) {
    if (v.make.toLowerCase().contains('honda')) return Icons.two_wheeler;
    if (v.isElectric) return Icons.electric_car;
    return Icons.directions_car;
  }

  String _getVehicleAsset(VehicleModel v) {
    if (v.imageUrl.isNotEmpty) return v.imageUrl;
    final lower = v.make.toLowerCase();
    final lowerModel = v.model.toLowerCase();
    if (lower.contains('honda') || v.vehicleType.toLowerCase().contains('motorcycle') || v.bodyClass.toLowerCase().contains('scooter')) {
      return 'assets/vehicles/honda_activa.png';
    } else if (lower.contains('porsche') || lowerModel.contains('taycan')) {
      return 'assets/vehicles/porsche_taycan.png';
    } else if (lower.contains('ford') || lowerModel.contains('mustang')) {
      return 'assets/vehicles/ford_mustang.png';
    }
    return 'assets/vehicles/tesla_model_3.png';
  }

  Widget _build3DVehicleRepresentation(VehicleModel vehicle, bool isDark, double angle) {
    final isTwoWheeler = vehicle.make.toLowerCase().contains('honda') ||
        vehicle.vehicleType.toLowerCase().contains('motorcycle') ||
        vehicle.bodyClass.toLowerCase().contains('scooter');
    final assetPath = _getVehicleAsset(vehicle);

    // Calculate dynamic 3D lighting & shadow shifts based on rotation angle
    final shadowScaleX = 1.0 + (math.cos(angle).abs() * 0.18);
    final shadowOffsetX = math.sin(angle) * 14.0;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 1. Realistic Dynamic Ground Contact Shadow (Soft Radial Ellipse)
        Positioned(
          bottom: isTwoWheeler ? 14 : 10,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(shadowScaleX, 0.35, 1.0)
              ..setTranslationRaw(shadowOffsetX, 0.0, 0.0),
            child: Container(



              width: isTwoWheeler ? 160 : 230,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(isTwoWheeler ? 80 : 115, 24)),
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: isDark ? 0.75 : 0.40),
                    Colors.black.withValues(alpha: isDark ? 0.35 : 0.18),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
        ),

        // 2. Realistic 3D Vehicle Model Render
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: isTwoWheeler ? 195 : 155,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    assetPath,
                    height: isTwoWheeler ? 195 : 155,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        isTwoWheeler ? Icons.two_wheeler : Icons.directions_car,
                        size: 96,
                        color: AppTheme.textPrimary,
                      );
                    },
                  ),

                  // 3. Dynamic Specular Light Flare sweeping across vehicle body on rotation
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-2.0 + math.sin(angle) * 2.0, -1.0),
                            end: Alignment(2.0 + math.sin(angle) * 2.0, 1.0),
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: (0.15 * math.cos(angle).abs()).clamp(0.0, 0.18)),
                              Colors.transparent,
                            ],
                            stops: const [0.35, 0.5, 0.65],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // 4. Telematics Live Floating HUD Overlay (Battery or Fuel Gauge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2230) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: (vehicle.isElectric ? AppTheme.cyanAccent : AppTheme.goldAccent).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: vehicle.isElectric ? const Color(0xFF10B981) : Colors.amberAccent,
                      boxShadow: [
                        BoxShadow(
                          color: vehicle.isElectric ? const Color(0xFF10B981) : Colors.amberAccent,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    vehicle.isElectric ? Icons.bolt : Icons.local_gas_station,
                    size: 12,
                    color: vehicle.isElectric ? AppTheme.cyanAccent : AppTheme.goldAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(vehicle.fuelOrBatteryLevel * 100).toInt()}% • ${vehicle.mileage} ${isTwoWheeler ? "KM" : "MI"}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  void _showNhtsaSpecsModal(BuildContext context, VehicleModel vehicle) {
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
                        color: AppTheme.goldAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.verified, color: AppTheme.goldAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'OFFICIAL US NHTSA VPIC SPECS',
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
              'Fetched live from the United States Department of Transportation (DOT) National Highway Traffic Safety Administration vPIC REST API.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
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
                children: [
                  _buildSpecRow('VIN', vehicle.vin),
                  const Divider(height: 16),
                  _buildSpecRow('Manufacturer', vehicle.manufacturer),
                  const Divider(height: 16),
                  _buildSpecRow('Assembly Plant', '${vehicle.plantCity.isNotEmpty ? '${vehicle.plantCity}, ' : ''}${vehicle.plantState}, ${vehicle.plantCountry}'),
                  const Divider(height: 16),
                  _buildSpecRow('Vehicle Type', vehicle.vehicleType),
                  const Divider(height: 16),
                  _buildSpecRow('Body Class', vehicle.bodyClass),
                  const Divider(height: 16),
                  _buildSpecRow('Drive Type', vehicle.driveType),
                  const Divider(height: 16),
                  _buildSpecRow('Fuel / Powertrain', '${vehicle.fuelTypePrimary} (${vehicle.electrificationLevel})'),
                  const Divider(height: 16),
                  _buildSpecRow('Active Recalls', '${vehicle.activeRecalls} Open Campaigns (api.nhtsa.gov)'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  foregroundColor: AppTheme.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('DONE', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}

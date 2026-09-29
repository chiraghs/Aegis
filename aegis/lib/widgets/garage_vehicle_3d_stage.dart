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
          '${vehicle.make} ${vehicle.model}',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // License Plate Badge (Exact match: IND | KA13EW7454)
        _buildLicensePlateBadge(vehicle.licensePlate, isDark),
        const SizedBox(height: 16),

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
                          padding: const EdgeInsets.all(6),
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
                              Icon(
                                _getVehicleIcon(v),
                                size: isSelected ? 22 : 18,
                                color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
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
                  width: MediaQuery.of(context).size.width * 0.72,
                  height: 240,
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

  Widget _buildBrandEmblem(String make) {
    final lower = make.toLowerCase();
    Color emblemColor = Colors.redAccent;
    IconData emblemIcon = Icons.two_wheeler;
    String brandText = make.toUpperCase();

    if (lower.contains('honda')) {
      emblemColor = const Color(0xFFCC0000);
      emblemIcon = Icons.two_wheeler;
      brandText = 'HONDA';
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
    // Parse US state prefix if present, e.g. "CA • 8TSL921" or "NY • TAY-442"
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

  Widget _build3DVehicleRepresentation(VehicleModel vehicle, bool isDark, double angle) {
    final isTwoWheeler = vehicle.make.toLowerCase().contains('honda');
    final isPlaidOrSports = vehicle.make.toLowerCase().contains('porsche') || vehicle.make.toLowerCase().contains('tesla');

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ground Radial Shadow (moves dynamically with angle)
        Positioned(
          bottom: 15,
          child: Container(
            width: 200,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),

        // 3D Isometric Vehicle Render with Dynamic Lighting
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isTwoWheeler ? 160 : 210,
              height: isTwoWheeler ? 170 : 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isTwoWheeler
                      ? [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)]
                      : isPlaidOrSports
                          ? [const Color(0xFF2C3E50), const Color(0xFF000000)]
                          : [const Color(0xFF334155), const Color(0xFF0F172A)],
                  begin: Alignment(math.sin(angle), -math.cos(angle)),
                  end: Alignment(-math.sin(angle), math.cos(angle)),
                ),
                border: Border.all(
                  color: AppTheme.goldAccent.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.goldAccent.withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Vehicle Silhouette / Headlight glow
                  Positioned(
                    top: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 14,
                          height: 6,
                          decoration: BoxDecoration(
                            color: vehicle.isElectric ? const Color(0xFF00F0FF) : Colors.amberAccent,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: vehicle.isElectric ? const Color(0xFF00F0FF) : Colors.amberAccent,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 14,
                          height: 6,
                          decoration: BoxDecoration(
                            color: vehicle.isElectric ? const Color(0xFF00F0FF) : Colors.amberAccent,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: vehicle.isElectric ? const Color(0xFF00F0FF) : Colors.amberAccent,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center Model Graphic
                  Icon(
                    isTwoWheeler ? Icons.two_wheeler : Icons.directions_car,
                    size: isTwoWheeler ? 96 : 84,
                    color: isTwoWheeler
                        ? const Color(0xFF1E293B)
                        : (isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF0F172A)),
                  ),

                  // Telematics Live Overlay (Battery or Fuel Gauge)
                  Positioned(
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            vehicle.isElectric ? Icons.bolt : Icons.local_gas_station,
                            size: 11,
                            color: vehicle.isElectric ? AppTheme.cyanAccent : AppTheme.goldAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(vehicle.fuelOrBatteryLevel * 100).toInt()}% • ${vehicle.mileage} MI',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
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
      ],
    );
  }
}

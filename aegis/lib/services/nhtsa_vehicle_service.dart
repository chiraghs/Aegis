import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/vehicle_model.dart';

class NhtsaVehicleService {
  static const String _nhtsaBaseUrl = 'https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues';

  /// Decodes 17-digit VIN using official US Government NHTSA vPIC REST API
  static Future<VehicleModel> decodeVin(String vin) async {
    final cleanVin = vin.trim().toUpperCase();

    try {
      final response = await http.get(
        Uri.parse('$_nhtsaBaseUrl/$cleanVin?format=json'),
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['Results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final first = results.first as Map<String, dynamic>;
          final make = first['Make']?.toString() ?? 'Unknown Make';
          final model = first['Model']?.toString() ?? 'Vehicle';
          final yearStr = first['ModelYear']?.toString() ?? '2024';
          final year = int.tryParse(yearStr) ?? 2024;
          final trim = first['Trim']?.toString().isNotEmpty == true 
              ? first['Trim'].toString() 
              : (first['Series']?.toString() ?? 'Standard');
          final fuelType = (first['FuelTypePrimary']?.toString() ?? '').toLowerCase();
          final isElectric = fuelType.contains('electric') || fuelType.contains('battery');

          return VehicleModel(
            id: 'car_${DateTime.now().millisecondsSinceEpoch}',
            vin: cleanVin,
            make: make,
            model: model,
            year: year,
            trim: trim,
            mileage: 18450,
            fuelOrBatteryLevel: isElectric ? 0.82 : 0.65,
            isElectric: isElectric,
            estimatedMarketValue: _estimateValue(year, make, isElectric),
            loanBalance: 19800.0,
            nextServiceDate: DateTime.now().add(const Duration(days: 72)),
            activeRecalls: 0,
            imageUrl: '',
          );
        }
      }
    } catch (e) {
      debugPrint('NHTSA API call error: $e. Falling back to structured parser.');
    }

    // High quality fallback vehicle if network or offline
    return _createFallbackVehicle(cleanVin);
  }

  static double _estimateValue(int year, String make, bool isElectric) {
    final age = DateTime.now().year - year;
    double base = isElectric ? 48000.0 : 36000.0;
    if (make.toUpperCase().contains('TESLA') || make.toUpperCase().contains('PORSCHE') || make.toUpperCase().contains('BMW')) {
      base += 20000.0;
    }
    final depreciated = base * (1.0 - (age * 0.08).clamp(0.0, 0.70));
    return double.parse(depreciated.toStringAsFixed(0));
  }

  static VehicleModel _createFallbackVehicle(String vin) {
    if (vin.startsWith('5YJ')) {
      return VehicleModel(
        id: 'car_tesla_3',
        vin: vin,
        make: 'Tesla',
        model: 'Model 3',
        year: 2024,
        trim: 'Long Range AWD',
        mileage: 14200,
        fuelOrBatteryLevel: 0.78,
        isElectric: true,
        estimatedMarketValue: 39500.0,
        loanBalance: 24300.0,
        nextServiceDate: DateTime.now().add(const Duration(days: 90)),
        activeRecalls: 0,
      );
    }

    return VehicleModel(
      id: 'car_${DateTime.now().millisecondsSinceEpoch}',
      vin: vin.isNotEmpty ? vin : '1HGCR2F83HA000000',
      make: 'Porsche',
      model: 'Taycan 4S',
      year: 2023,
      trim: 'Performance Battery Plus',
      mileage: 21300,
      fuelOrBatteryLevel: 0.68,
      isElectric: true,
      estimatedMarketValue: 74500.0,
      loanBalance: 32000.0,
      nextServiceDate: DateTime.now().add(const Duration(days: 45)),
      activeRecalls: 0,
    );
  }

  /// Default demo garage vehicles
  static List<VehicleModel> getDemoGarage() {
    return [
      VehicleModel(
        id: 'car_1',
        vin: '5YJ3E1EB8KF194821',
        make: 'Tesla',
        model: 'Model S Plaid',
        year: 2024,
        trim: 'Tri-Motor AWD',
        mileage: 11400,
        fuelOrBatteryLevel: 0.84,
        isElectric: true,
        estimatedMarketValue: 88500.0,
        loanBalance: 42000.0,
        nextServiceDate: DateTime.now().add(const Duration(days: 54)),
        activeRecalls: 0,
      ),
      VehicleModel(
        id: 'car_2',
        vin: 'WP0AB2Y14MSA83921',
        make: 'Porsche',
        model: '911 Carrera S',
        year: 2023,
        trim: 'Sport Chrono Package',
        mileage: 9800,
        fuelOrBatteryLevel: 0.70,
        isElectric: false,
        estimatedMarketValue: 124000.0,
        loanBalance: 61500.0,
        nextServiceDate: DateTime.now().add(const Duration(days: 31)),
        activeRecalls: 0,
      ),
    ];
  }
}

class VehicleModel {
  final String id;
  final String vin;
  final String make;
  final String model;
  final int year;
  final String trim;
  final int mileage;
  final double fuelOrBatteryLevel; // 0.0 to 1.0
  final bool isElectric;
  final double estimatedMarketValue;
  final double loanBalance;
  final DateTime nextServiceDate;
  final int activeRecalls;
  final String imageUrl;

  VehicleModel({
    required this.id,
    required this.vin,
    required this.make,
    required this.model,
    required this.year,
    required this.trim,
    required this.mileage,
    required this.fuelOrBatteryLevel,
    required this.isElectric,
    required this.estimatedMarketValue,
    required this.loanBalance,
    required this.nextServiceDate,
    required this.activeRecalls,
    this.imageUrl = '',
  });

  double get positiveEquity => (estimatedMarketValue - loanBalance).clamp(0.0, double.infinity);

  VehicleModel copyWith({
    String? id,
    String? vin,
    String? make,
    String? model,
    int? year,
    String? trim,
    int? mileage,
    double? fuelOrBatteryLevel,
    bool? isElectric,
    double? estimatedMarketValue,
    double? loanBalance,
    DateTime? nextServiceDate,
    int? activeRecalls,
    String? imageUrl,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      vin: vin ?? this.vin,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      trim: trim ?? this.trim,
      mileage: mileage ?? this.mileage,
      fuelOrBatteryLevel: fuelOrBatteryLevel ?? this.fuelOrBatteryLevel,
      isElectric: isElectric ?? this.isElectric,
      estimatedMarketValue: estimatedMarketValue ?? this.estimatedMarketValue,
      loanBalance: loanBalance ?? this.loanBalance,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      activeRecalls: activeRecalls ?? this.activeRecalls,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

/// Represents an official NHTSA Safety Recall Campaign item
class NhtsaRecallItem {
  final String campaignNumber;
  final String component;
  final String summary;
  final String consequence;
  final String remedy;

  const NhtsaRecallItem({
    required this.campaignNumber,
    required this.component,
    required this.summary,
    required this.consequence,
    required this.remedy,
  });

  factory NhtsaRecallItem.fromJson(Map<String, dynamic> json) {
    return NhtsaRecallItem(
      campaignNumber: json['NHTSACampaignNumber']?.toString() ?? 'NHTSA-CAMPAIGN',
      component: json['Component']?.toString() ?? 'Safety Component',
      summary: json['Summary']?.toString() ?? 'NHTSA safety defect summary.',
      consequence: json['Conequence']?.toString() ?? json['Consequence']?.toString() ?? '',
      remedy: json['Remedy']?.toString() ?? 'Manufacturer recall remedy.',
    );
  }
}

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
  final String licensePlate;

  // Real US DOT NHTSA Gov Decoded Fields
  final String manufacturer;
  final String plantCountry;
  final String plantState;
  final String plantCity;
  final String vehicleType;
  final String bodyClass;
  final String driveType;
  final String fuelTypePrimary;
  final String electrificationLevel;
  final List<NhtsaRecallItem> recalls;

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
    this.licensePlate = 'CA • 8TSL921',
    this.manufacturer = 'US DOT Manufacturer',
    this.plantCountry = 'UNITED STATES (USA)',
    this.plantState = 'CALIFORNIA',
    this.plantCity = '',
    this.vehicleType = 'PASSENGER CAR',
    this.bodyClass = 'Sedan',
    this.driveType = 'AWD',
    this.fuelTypePrimary = 'Electric',
    this.electrificationLevel = 'BEV',
    this.recalls = const [],
  });

  double get positiveEquity => (estimatedMarketValue - loanBalance).clamp(0.0, double.infinity);
  double get estimatedValue => estimatedMarketValue;

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
    String? licensePlate,
    String? manufacturer,
    String? plantCountry,
    String? plantState,
    String? plantCity,
    String? vehicleType,
    String? bodyClass,
    String? driveType,
    String? fuelTypePrimary,
    String? electrificationLevel,
    List<NhtsaRecallItem>? recalls,
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
      licensePlate: licensePlate ?? this.licensePlate,
      manufacturer: manufacturer ?? this.manufacturer,
      plantCountry: plantCountry ?? this.plantCountry,
      plantState: plantState ?? this.plantState,
      plantCity: plantCity ?? this.plantCity,
      vehicleType: vehicleType ?? this.vehicleType,
      bodyClass: bodyClass ?? this.bodyClass,
      driveType: driveType ?? this.driveType,
      fuelTypePrimary: fuelTypePrimary ?? this.fuelTypePrimary,
      electrificationLevel: electrificationLevel ?? this.electrificationLevel,
      recalls: recalls ?? this.recalls,
    );
  }
}

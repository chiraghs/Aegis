import 'package:flutter/material.dart';

/// Represents an active or quotable automotive insurance policy
class InsurancePolicyModel {
  final String id;
  final String provider;
  final String providerLogo;
  final String policyNumber;
  final String coverageType; // 'Comprehensive', 'Zero Depreciation', 'Third Party'
  final double annualPremium;
  final DateTime expiryDate;
  final bool isActive;
  final String vehicleId;
  final double idv; // Insured Declared Value

  const InsurancePolicyModel({
    required this.id,
    required this.provider,
    required this.providerLogo,
    required this.policyNumber,
    required this.coverageType,
    required this.annualPremium,
    required this.expiryDate,
    required this.isActive,
    required this.vehicleId,
    required this.idv,
  });

  InsurancePolicyModel copyWith({
    String? id,
    String? provider,
    String? providerLogo,
    String? policyNumber,
    String? coverageType,
    double? annualPremium,
    DateTime? expiryDate,
    bool? isActive,
    String? vehicleId,
    double? idv,
  }) {
    return InsurancePolicyModel(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      providerLogo: providerLogo ?? this.providerLogo,
      policyNumber: policyNumber ?? this.policyNumber,
      coverageType: coverageType ?? this.coverageType,
      annualPremium: annualPremium ?? this.annualPremium,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      vehicleId: vehicleId ?? this.vehicleId,
      idv: idv ?? this.idv,
    );
  }
}

/// Represents an automotive traffic violation / citation
class ChallanModel {
  final String id;
  final String violationType;
  final String location;
  final DateTime date;
  final double amount;
  final bool isPaid;
  final String citationNumber;
  final String? cameraImageUrl;

  const ChallanModel({
    required this.id,
    required this.violationType,
    required this.location,
    required this.date,
    required this.amount,
    required this.isPaid,
    required this.citationNumber,
    this.cameraImageUrl,
  });

  ChallanModel copyWith({
    String? id,
    String? violationType,
    String? location,
    DateTime? date,
    double? amount,
    bool? isPaid,
    String? citationNumber,
    String? cameraImageUrl,
  }) {
    return ChallanModel(
      id: id ?? this.id,
      violationType: violationType ?? this.violationType,
      location: location ?? this.location,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      citationNumber: citationNumber ?? this.citationNumber,
      cameraImageUrl: cameraImageUrl ?? this.cameraImageUrl,
    );
  }
}

/// Categorized automotive expenditure item
class VehicleSpendItem {
  final String id;
  final String category; // 'Fuel', 'Service', 'Tolls', 'Others'
  final String merchant;
  final double amount;
  final DateTime date;
  final IconData icon;

  const VehicleSpendItem({
    required this.id,
    required this.category,
    required this.merchant,
    required this.amount,
    required this.date,
    required this.icon,
  });
}

/// Verified document in the digital glovebox
class GloveboxDocModel {
  final String id;
  final String title;
  final String docType; // 'RC', 'DL', 'Insurance', 'PUCC'
  final String docNumber;
  final String issuingAuthority;
  final DateTime validUntil;
  final bool isDigiLockerVerified;

  const GloveboxDocModel({
    required this.id,
    required this.title,
    required this.docType,
    required this.docNumber,
    required this.issuingAuthority,
    required this.validUntil,
    this.isDigiLockerVerified = true,
  });
}

/// Peak traffic hour drop / reward
class RushHourRewardModel {
  final String id;
  final String categoryTag; // 'MEGA JACKPOT', 'RECHARGE FASTAG', 'SHELL DROP'
  final String title;
  final String subtitle;
  final String valueText;
  final IconData icon;
  final bool isClaimed;

  const RushHourRewardModel({
    required this.id,
    required this.categoryTag,
    required this.title,
    required this.subtitle,
    required this.valueText,
    required this.icon,
    this.isClaimed = false,
  });

  RushHourRewardModel copyWith({
    String? id,
    String? categoryTag,
    String? title,
    String? subtitle,
    String? valueText,
    IconData? icon,
    bool? isClaimed,
  }) {
    return RushHourRewardModel(
      id: id ?? this.id,
      categoryTag: categoryTag ?? this.categoryTag,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      valueText: valueText ?? this.valueText,
      icon: icon ?? this.icon,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }
}

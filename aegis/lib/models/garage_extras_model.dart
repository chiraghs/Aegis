import 'package:flutter/material.dart';

/// Telematics & Usage-Based Insurance (UBI) tracking data
class VehicleTelematicsTracking {
  final int safeDriverScore; // 0-100 (e.g. 96)
  final double discountPercent; // e.g. 28.0%
  final double smoothBrakingScore; // 0-100 (e.g. 98)
  final double speedComplianceScore; // 0-100 (e.g. 95)
  final double safeCorneringScore; // 0-100 (e.g. 96)
  final double phoneFreeScore; // 0-100 (e.g. 100)
  final double daytimeDrivingScore; // 0-100 (e.g. 94)
  final int annualMilesLogged; // e.g. 4210
  final int annualMilesLimit; // e.g. 10000
  final String tierGrade; // 'Tier A+ Elite'

  const VehicleTelematicsTracking({
    required this.safeDriverScore,
    required this.discountPercent,
    required this.smoothBrakingScore,
    required this.speedComplianceScore,
    required this.safeCorneringScore,
    required this.phoneFreeScore,
    required this.daytimeDrivingScore,
    required this.annualMilesLogged,
    required this.annualMilesLimit,
    required this.tierGrade,
  });
}

/// Vehicle insurance claim with step-by-step pipeline status
class VehicleInsuranceClaimItem {
  final String id;
  final String claimNumber;
  final String title;
  final DateTime filedDate;
  final String status; // 'Filed', 'In Review', 'Approved', 'Paid'
  final int currentStep; // 0 to 3
  final double payoutAmount;
  final double deductiblePaid;
  final String repairShop;

  const VehicleInsuranceClaimItem({
    required this.id,
    required this.claimNumber,
    required this.title,
    required this.filedDate,
    required this.status,
    required this.currentStep,
    required this.payoutAmount,
    required this.deductiblePaid,
    required this.repairShop,
  });
}

/// Represents an active or quotable US automotive insurance policy
class InsurancePolicyModel {
  final String id;
  final String provider; // 'GEICO', 'Progressive', 'State Farm', 'Allstate'
  final String providerLogo;
  final String policyNumber;
  final String coverageType; // 'Comprehensive & Collision', 'Full Coverage', 'Liability (100k/300k/100k)'
  final double annualPremium;
  final DateTime expiryDate;
  final bool isActive;
  final String vehicleId;
  final double idv; // Insured Value / Replacement Value
  final VehicleTelematicsTracking? telematics;
  final List<VehicleInsuranceClaimItem> claims;
  final double comprehensiveDeductible;
  final double collisionDeductible;
  final String bodilyInjuryLimit;
  final String propertyDamageLimit;
  final bool hasRoadsideAssistance;
  final bool hasRentalReimbursement;
  final int continuousCoverageYears;
  final DateTime? nextBillingDate;

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
    this.telematics,
    this.claims = const [],
    this.comprehensiveDeductible = 250.0,
    this.collisionDeductible = 500.0,
    this.bodilyInjuryLimit = '\$100k / \$300k',
    this.propertyDamageLimit = '\$100k',
    this.hasRoadsideAssistance = true,
    this.hasRentalReimbursement = true,
    this.continuousCoverageYears = 5,
    this.nextBillingDate,
  });

  double get monthlyPremium => annualPremium / 12;
  int get daysUntilRenewal => expiryDate.difference(DateTime.now()).inDays.clamp(0, 365);

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
    VehicleTelematicsTracking? telematics,
    List<VehicleInsuranceClaimItem>? claims,
    double? comprehensiveDeductible,
    double? collisionDeductible,
    String? bodilyInjuryLimit,
    String? propertyDamageLimit,
    bool? hasRoadsideAssistance,
    bool? hasRentalReimbursement,
    int? continuousCoverageYears,
    DateTime? nextBillingDate,
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
      telematics: telematics ?? this.telematics,
      claims: claims ?? this.claims,
      comprehensiveDeductible: comprehensiveDeductible ?? this.comprehensiveDeductible,
      collisionDeductible: collisionDeductible ?? this.collisionDeductible,
      bodilyInjuryLimit: bodilyInjuryLimit ?? this.bodilyInjuryLimit,
      propertyDamageLimit: propertyDamageLimit ?? this.propertyDamageLimit,
      hasRoadsideAssistance: hasRoadsideAssistance ?? this.hasRoadsideAssistance,
      hasRentalReimbursement: hasRentalReimbursement ?? this.hasRentalReimbursement,
      continuousCoverageYears: continuousCoverageYears ?? this.continuousCoverageYears,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    );
  }
}

/// Represents a US traffic violation / municipal or police citation
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

typedef TrafficCitationModel = ChallanModel;

/// Categorized automotive expenditure item in USD
class VehicleSpendItem {
  final String id;
  final String category; // 'Fuel', 'EV Charging', 'Service', 'Tolls', 'Others'
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

/// Verified document in the US digital glovebox (DMV, Apple Wallet, Carrier)
class GloveboxDocModel {
  final String id;
  final String title;
  final String docType; // 'Registration', 'Driver License', 'Insurance', 'Smog / Inspection'
  final String docNumber;
  final String issuingAuthority;
  final DateTime validUntil;
  final bool isStateVerified;

  const GloveboxDocModel({
    required this.id,
    required this.title,
    required this.docType,
    required this.docNumber,
    required this.issuingAuthority,
    required this.validUntil,
    this.isStateVerified = true,
  });

  bool get isDigiLockerVerified => isStateVerified;
}

/// Peak traffic hour drop / reward
class RushHourRewardModel {
  final String id;
  final String categoryTag; // 'MEGA JACKPOT', 'TOLL PASS', 'SUPERCHARGER DROP'
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

import 'package:flutter/material.dart';

enum FamilyPolicyType {
  health,
  termLife,
  homeowners,
  dental,
  vision,
}

enum FamilyClaimStatus {
  submitted,
  inReview,
  approved,
  paid,
  denied,
}

class FamilyClaimItem {
  final String id;
  final String title;
  final String provider;
  final String memberName;
  final DateTime filedDate;
  final double amountClaimed;
  final double amountCovered;
  final double memberResponsibility;
  final FamilyClaimStatus status;
  final String notes;

  const FamilyClaimItem({
    required this.id,
    required this.title,
    required this.provider,
    required this.memberName,
    required this.filedDate,
    required this.amountClaimed,
    required this.amountCovered,
    required this.memberResponsibility,
    required this.status,
    required this.notes,
  });

  String get statusDisplay {
    switch (status) {
      case FamilyClaimStatus.submitted:
        return 'Submitted';
      case FamilyClaimStatus.inReview:
        return 'Under Review';
      case FamilyClaimStatus.approved:
        return 'Approved';
      case FamilyClaimStatus.paid:
        return 'Paid & Settled';
      case FamilyClaimStatus.denied:
        return 'Denied';
    }
  }

  Color get statusColor {
    switch (status) {
      case FamilyClaimStatus.submitted:
        return const Color(0xFF3B82F6);
      case FamilyClaimStatus.inReview:
        return const Color(0xFFF59E0B);
      case FamilyClaimStatus.approved:
      case FamilyClaimStatus.paid:
        return const Color(0xFF10B981);
      case FamilyClaimStatus.denied:
        return const Color(0xFFEF4444);
    }
  }
}

class FamilyMemberCoverage {
  final String id;
  final String name;
  final String relation; // 'Self', 'Spouse', 'Dependent'
  final String memberId;
  final String rxBin;
  final String rxGroup;
  final double individualDeductibleMet;
  final double individualDeductibleLimit;

  const FamilyMemberCoverage({
    required this.id,
    required this.name,
    required this.relation,
    required this.memberId,
    required this.rxBin,
    required this.rxGroup,
    required this.individualDeductibleMet,
    required this.individualDeductibleLimit,
  });
}

class LifeBeneficiaryAllocation {
  final String name;
  final String relation;
  final double percentage; // e.g. 70.0%

  const LifeBeneficiaryAllocation({
    required this.name,
    required this.relation,
    required this.percentage,
  });
}

class FamilyInsurancePolicyModel {
  final String id;
  final String provider; // e.g. 'Blue Cross Blue Shield', 'Northwestern Mutual', 'Lemonade'
  final String planName; // e.g. 'Gold PPO 80/20 Family Plan'
  final String policyNumber;
  final FamilyPolicyType policyType;
  final double annualPremium;
  final double monthlyPremium;
  final DateTime renewalDate;
  final bool isActive;

  // Health / Dental specific
  final double? familyDeductibleMet;
  final double? familyDeductibleTotal;
  final double? outOfPocketMet;
  final double? outOfPocketMax;
  final double? hsaFsaBalance;
  final List<FamilyMemberCoverage> coveredMembers;

  // Life specific
  final double? lifeFaceValue;
  final int? termYearsRemaining;
  final List<LifeBeneficiaryAllocation> beneficiaries;

  // Homeowners specific
  final double? dwellingCoverage;
  final double? personalPropertyCoverage;
  final double? liabilityCoverage;
  final double? propertyDeductible;

  // Claims
  final List<FamilyClaimItem> claims;

  const FamilyInsurancePolicyModel({
    required this.id,
    required this.provider,
    required this.planName,
    required this.policyNumber,
    required this.policyType,
    required this.annualPremium,
    required this.monthlyPremium,
    required this.renewalDate,
    required this.isActive,
    this.familyDeductibleMet,
    this.familyDeductibleTotal,
    this.outOfPocketMet,
    this.outOfPocketMax,
    this.hsaFsaBalance,
    this.coveredMembers = const [],
    this.lifeFaceValue,
    this.termYearsRemaining,
    this.beneficiaries = const [],
    this.dwellingCoverage,
    this.personalPropertyCoverage,
    this.liabilityCoverage,
    this.propertyDeductible,
    this.claims = const [],
  });

  int get daysUntilRenewal => renewalDate.difference(DateTime.now()).inDays.clamp(0, 3650);

  double get deductiblePercentage {
    if (familyDeductibleTotal == null || familyDeductibleTotal == 0) return 0.0;
    return ((familyDeductibleMet ?? 0) / familyDeductibleTotal!).clamp(0.0, 1.0);
  }

  double get outOfPocketPercentage {
    if (outOfPocketMax == null || outOfPocketMax == 0) return 0.0;
    return ((outOfPocketMet ?? 0) / outOfPocketMax!).clamp(0.0, 1.0);
  }
}

import 'package:flutter/material.dart';

enum AssetCategory {
  cash('Liquid Cash & HYSA', Icons.account_balance, Color(0xFF00E676)),
  investments('Brokerage & Equities', Icons.trending_up, Color(0xFF00E5FF)),
  realEstate('Real Estate & Home Equity', Icons.home_work, Color(0xFFE5B869)),
  vehicles('Vehicles & Garage', Icons.directions_car, Color(0xFFFFB300)),
  crypto('Crypto & Cold Storage', Icons.currency_bitcoin, Color(0xFFB388FF)),
  retirement('Retirement & 401(k)', Icons.shield, Color(0xFF64B5F6));

  final String label;
  final IconData icon;
  final Color color;

  const AssetCategory(this.label, this.icon, this.color);
}

enum LiabilityCategory {
  creditCard('Credit Card', Icons.credit_card, Color(0xFFFF3366)),
  mortgage('Mortgage', Icons.home, Color(0xFFFF7043)),
  autoLoan('Auto Loan', Icons.directions_car_filled, Color(0xFFFFAB91)),
  studentLoan('Student / Personal Loan', Icons.school, Color(0xFFE57373));

  final String label;
  final IconData icon;
  final Color color;

  const LiabilityCategory(this.label, this.icon, this.color);
}

class AssetItem {
  final String id;
  final String name;
  final String institution;
  final AssetCategory category;
  final double valuation;
  final DateTime lastUpdated;
  final double monthlyChangePercent;

  const AssetItem({
    required this.id,
    required this.name,
    required this.institution,
    required this.category,
    required this.valuation,
    required this.lastUpdated,
    this.monthlyChangePercent = 0.0,
  });

  AssetItem copyWith({
    String? id,
    String? name,
    String? institution,
    AssetCategory? category,
    double? valuation,
    DateTime? lastUpdated,
    double? monthlyChangePercent,
  }) {
    return AssetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      institution: institution ?? this.institution,
      category: category ?? this.category,
      valuation: valuation ?? this.valuation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      monthlyChangePercent: monthlyChangePercent ?? this.monthlyChangePercent,
    );
  }
}

class LiabilityItem {
  final String id;
  final String name;
  final String lender;
  final LiabilityCategory category;
  final double balance;
  final double interestRateApr;
  final double monthlyPayment;

  const LiabilityItem({
    required this.id,
    required this.name,
    required this.lender,
    required this.category,
    required this.balance,
    required this.interestRateApr,
    required this.monthlyPayment,
  });

  LiabilityItem copyWith({
    String? id,
    String? name,
    String? lender,
    LiabilityCategory? category,
    double? balance,
    double? interestRateApr,
    double? monthlyPayment,
  }) {
    return LiabilityItem(
      id: id ?? this.id,
      name: name ?? this.name,
      lender: lender ?? this.lender,
      category: category ?? this.category,
      balance: balance ?? this.balance,
      interestRateApr: interestRateApr ?? this.interestRateApr,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
    );
  }
}

class NetWorthSnapshot {
  final String monthLabel;
  final double totalAssets;
  final double totalLiabilities;
  final double netWorth;

  const NetWorthSnapshot({
    required this.monthLabel,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
  });
}

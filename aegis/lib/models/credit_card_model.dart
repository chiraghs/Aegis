
import 'package:flutter/material.dart';

class CardTransaction {
  final String id;
  final String merchant;
  final String category;
  final double amount;
  final DateTime date;
  final String cashBackOrReward;
  final IconData icon;

  const CardTransaction({
    required this.id,
    required this.merchant,
    required this.category,
    required this.amount,
    required this.date,
    required this.cashBackOrReward,
    required this.icon,
  });
}

enum CardNetwork { visa, mastercard, amex }

enum CardThemePreset { amexGold, chaseSapphire, ventureX, appleTitanium, mintGreen, charcoal }

class CreditCardModel {
  final String id;
  final String cardName;
  final String issuer;
  final CardNetwork network;
  final String lastFour;
  final double currentBalance;
  final double creditLimit;
  final double statementBalance;
  final double minimumDue;
  final DateTime dueDate;
  final double apr;
  final List<String> topPerks;
  final CardThemePreset themePreset;
  final bool isPaidThisCycle;
  final List<CardTransaction> transactions;

  CreditCardModel({
    required this.id,
    required this.cardName,
    required this.issuer,
    required this.network,
    required this.lastFour,
    required this.currentBalance,
    required this.creditLimit,
    required this.statementBalance,
    required this.minimumDue,
    required this.dueDate,
    required this.apr,
    required this.topPerks,
    required this.themePreset,
    this.isPaidThisCycle = false,
    this.transactions = const [],
  });

  double get utilizationRate => (currentBalance / creditLimit).clamp(0.0, 1.0);

  int get daysUntilDue {
    final now = DateTime.now();
    return dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  CreditCardModel copyWith({
    String? id,
    String? cardName,
    String? issuer,
    CardNetwork? network,
    String? lastFour,
    double? currentBalance,
    double? creditLimit,
    double? statementBalance,
    double? minimumDue,
    DateTime? dueDate,
    double? apr,
    List<String>? topPerks,
    CardThemePreset? themePreset,
    bool? isPaidThisCycle,
    List<CardTransaction>? transactions,
  }) {
    return CreditCardModel(
      id: id ?? this.id,
      cardName: cardName ?? this.cardName,
      issuer: issuer ?? this.issuer,
      network: network ?? this.network,
      lastFour: lastFour ?? this.lastFour,
      currentBalance: currentBalance ?? this.currentBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      statementBalance: statementBalance ?? this.statementBalance,
      minimumDue: minimumDue ?? this.minimumDue,
      dueDate: dueDate ?? this.dueDate,
      apr: apr ?? this.apr,
      topPerks: topPerks ?? this.topPerks,
      themePreset: themePreset ?? this.themePreset,
      isPaidThisCycle: isPaidThisCycle ?? this.isPaidThisCycle,
      transactions: transactions ?? this.transactions,
    );
  }
}

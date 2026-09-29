
enum CardNetwork { visa, mastercard, amex }

enum CardThemePreset { amexGold, chaseSapphire, ventureX, appleTitanium }

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
    );
  }
}

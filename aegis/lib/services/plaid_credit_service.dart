import '../models/credit_card_model.dart';

class PlaidCreditService {
  static List<CreditCardModel> getInitialCards() {
    return [
      CreditCardModel(
        id: 'card_amex_gold',
        cardName: 'American Express Gold',
        issuer: 'American Express',
        network: CardNetwork.amex,
        lastFour: '8492',
        currentBalance: 1248.50,
        creditLimit: 25000.0,
        statementBalance: 1248.50,
        minimumDue: 35.00,
        dueDate: DateTime.now().add(const Duration(days: 4)),
        apr: 24.99,
        topPerks: ['4x Dining Worldwide', '4x US Supermarkets', '\$120 Dining Credit'],
        themePreset: CardThemePreset.amexGold,
        isPaidThisCycle: false,
      ),
      CreditCardModel(
        id: 'card_chase_sapphire',
        cardName: 'Chase Sapphire Reserve',
        issuer: 'Chase Bank',
        network: CardNetwork.visa,
        lastFour: '3109',
        currentBalance: 3410.20,
        creditLimit: 30000.0,
        statementBalance: 3410.20,
        minimumDue: 85.00,
        dueDate: DateTime.now().add(const Duration(days: 9)),
        apr: 22.49,
        topPerks: ['3x Travel Worldwide', '\$300 Annual Travel Credit', 'Priority Pass Lounges'],
        themePreset: CardThemePreset.chaseSapphire,
        isPaidThisCycle: false,
      ),
      CreditCardModel(
        id: 'card_venture_x',
        cardName: 'Capital One Venture X',
        issuer: 'Capital One',
        network: CardNetwork.visa,
        lastFour: '7721',
        currentBalance: 890.00,
        creditLimit: 20000.0,
        statementBalance: 890.00,
        minimumDue: 25.00,
        dueDate: DateTime.now().add(const Duration(days: 15)),
        apr: 19.99,
        topPerks: ['2x on All Purchases', '10,000 Anniversary Miles', 'Capital One Lounge Access'],
        themePreset: CardThemePreset.ventureX,
        isPaidThisCycle: true, // Marked as paid to show comparison
      ),
    ];
  }

  /// Calculates AI recommendation for which card to swipe given a merchant category
  static Map<String, dynamic> recommendCardForPurchase({
    required String merchant,
    required String category,
    required List<CreditCardModel> userCards,
  }) {
    if (category.toLowerCase().contains('dining') || category.toLowerCase().contains('restaurant')) {
      final amex = userCards.firstWhere(
        (c) => c.cardName.contains('Gold'),
        orElse: () => userCards.first,
      );
      return {
        'card': amex,
        'multiplier': '4x Points',
        'reason': 'Amex Gold delivers highest yield (4x) on restaurants worldwide.',
      };
    } else if (category.toLowerCase().contains('flight') || category.toLowerCase().contains('travel')) {
      final chase = userCards.firstWhere(
        (c) => c.cardName.contains('Sapphire'),
        orElse: () => userCards.first,
      );
      return {
        'card': chase,
        'multiplier': '3x Points + Trip Insurance',
        'reason': 'Chase Sapphire gives 3x points plus primary rental CDW & delay insurance.',
      };
    } else {
      final venture = userCards.firstWhere(
        (c) => c.cardName.contains('Venture'),
        orElse: () => userCards.first,
      );
      return {
        'card': venture,
        'multiplier': '2x Miles Catch-All',
        'reason': 'Venture X guarantees minimum 2% return on miscellaneous shopping.',
      };
    }
  }
}

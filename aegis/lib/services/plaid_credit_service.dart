import 'package:flutter/material.dart';
import '../models/credit_card_model.dart';

class PlaidCreditService {
  static List<CreditCardModel> getInitialCards() {
    final now = DateTime.now();
    return [
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
        dueDate: now.add(const Duration(days: 9)),
        apr: 22.49,
        topPerks: ['3x Travel Worldwide', '\$300 Annual Travel Credit', 'Priority Pass Lounges'],
        themePreset: CardThemePreset.chaseSapphire,
        isPaidThisCycle: false,
        transactions: [
          CardTransaction(
            id: 'tx_cs_1',
            merchant: 'Delta Air Lines',
            category: 'Flights & Travel',
            amount: 642.80,
            date: now.subtract(const Duration(days: 1)),
            cashBackOrReward: '+1,928 Pts (3x)',
            icon: Icons.flight_takeoff_rounded,
          ),
          CardTransaction(
            id: 'tx_cs_2',
            merchant: 'Nobu Downtown NYC',
            category: 'Fine Dining',
            amount: 285.50,
            date: now.subtract(const Duration(days: 3)),
            cashBackOrReward: '+856 Pts (3x)',
            icon: Icons.restaurant_rounded,
          ),
          CardTransaction(
            id: 'tx_cs_3',
            merchant: 'Uber Black',
            category: 'Rideshare',
            amount: 68.20,
            date: now.subtract(const Duration(days: 4)),
            cashBackOrReward: '+204 Pts (3x)',
            icon: Icons.directions_car_rounded,
          ),
          CardTransaction(
            id: 'tx_cs_4',
            merchant: 'Apple Store 5th Ave',
            category: 'Electronics',
            amount: 1299.00,
            date: now.subtract(const Duration(days: 6)),
            cashBackOrReward: '+1,299 Pts (1x)',
            icon: Icons.laptop_mac_rounded,
            type: 'debit',
          ),
          CardTransaction(
            id: 'tx_cs_5',
            merchant: 'Delta Air Lines Refund',
            category: 'Flights & Travel',
            amount: -145.20,
            date: now.subtract(const Duration(days: 8)),
            cashBackOrReward: 'Refund Cleared',
            icon: Icons.replay_rounded,
            type: 'credit',
          ),
          CardTransaction(
            id: 'tx_cs_6',
            merchant: 'Aegis 1.5% Yield Auto-Cashback',
            category: 'Rewards & Yield',
            amount: -48.50,
            date: now.subtract(const Duration(days: 12)),
            cashBackOrReward: '+250 Aegis Coins',
            icon: Icons.bolt_rounded,
            type: 'reward',
          ),
        ],
      ),
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
        dueDate: now.add(const Duration(days: 4)),
        apr: 24.99,
        topPerks: ['4x Dining Worldwide', '4x US Supermarkets', '\$120 Dining Credit'],
        themePreset: CardThemePreset.amexGold,
        isPaidThisCycle: false,
        transactions: [
          CardTransaction(
            id: 'tx_ag_1',
            merchant: 'Whole Foods Market',
            category: 'US Supermarkets',
            amount: 184.20,
            date: now.subtract(const Duration(days: 1)),
            cashBackOrReward: '+736 Pts (4x)',
            icon: Icons.shopping_basket_rounded,
          ),
          CardTransaction(
            id: 'tx_ag_2',
            merchant: 'Sweetgreen',
            category: 'Dining & Fast Casual',
            amount: 24.80,
            date: now.subtract(const Duration(days: 2)),
            cashBackOrReward: '+99 Pts (4x)',
            icon: Icons.lunch_dining_rounded,
          ),
          CardTransaction(
            id: 'tx_ag_3',
            merchant: 'Erewhon Beverly Hills',
            category: 'US Supermarkets',
            amount: 142.10,
            date: now.subtract(const Duration(days: 5)),
            cashBackOrReward: '+568 Pts (4x)',
            icon: Icons.local_grocery_store_rounded,
          ),
        ],
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
        dueDate: now.add(const Duration(days: 15)),
        apr: 19.99,
        topPerks: ['2x on All Purchases', '10,000 Anniversary Miles', 'Capital One Lounge Access'],
        themePreset: CardThemePreset.ventureX,
        isPaidThisCycle: true, // Marked as paid to demonstrate Cleared badge
        transactions: [
          CardTransaction(
            id: 'tx_vx_1',
            merchant: 'Tesla Supercharging',
            category: 'Automotive & EV',
            amount: 28.50,
            date: now.subtract(const Duration(days: 2)),
            cashBackOrReward: '+57 Miles (2x)',
            icon: Icons.electric_car_rounded,
          ),
          CardTransaction(
            id: 'tx_vx_2',
            merchant: 'Equinox Fitness Club',
            category: 'Health & Wellness',
            amount: 320.00,
            date: now.subtract(const Duration(days: 7)),
            cashBackOrReward: '+640 Miles (2x)',
            icon: Icons.fitness_center_rounded,
          ),
        ],
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

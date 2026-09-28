import 'package:flutter/foundation.dart';
import '../models/credit_card_model.dart';
import '../models/vehicle_model.dart';
import '../models/reward_model.dart';
import '../models/subscription_tier.dart';
import '../services/revenuecat_service.dart';
import '../services/plaid_credit_service.dart';
import '../services/nhtsa_vehicle_service.dart';

class AppState extends ChangeNotifier {
  List<CreditCardModel> _cards = [];
  List<VehicleModel> _vehicles = [];
  UserRewardsState _rewards = UserRewardsState(
    totalCoins: 3420,
    streakDays: 4,
    totalDebtCleared: 8450.0,
    claimedPerkIds: [],
  );
  SubscriptionTier _tier = SubscriptionTier.free;

  AppState() {
    _init();
  }

  List<CreditCardModel> get cards => _cards;
  List<VehicleModel> get vehicles => _vehicles;
  UserRewardsState get rewards => _rewards;
  SubscriptionTier get tier => _tier;

  // Subscription Gates
  bool get isFree => _tier == SubscriptionTier.free;
  bool get isGoldOrHigher => _tier == SubscriptionTier.gold || _tier == SubscriptionTier.black;
  bool get isBlackEdition => _tier == SubscriptionTier.black;

  bool get canAddMoreCards => isGoldOrHigher || _cards.length < 2;
  bool get canAddMoreVehicles => isGoldOrHigher || _vehicles.length < 1;
  bool get hasAiCardOptimizer => isBlackEdition;

  // Financial Computations
  double get totalCurrentBalance => _cards.fold(0.0, (acc, c) => acc + c.currentBalance);
  double get totalCreditLimit => _cards.fold(0.0, (acc, c) => acc + c.creditLimit);
  double get overallUtilization => totalCreditLimit > 0 ? (totalCurrentBalance / totalCreditLimit) : 0.0;

  CreditCardModel? get nearestDueCard {
    final unpaid = _cards.where((c) => !c.isPaidThisCycle).toList();
    if (unpaid.isEmpty) return null;
    unpaid.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return unpaid.first;
  }

  void _init() {
    _cards = PlaidCreditService.getInitialCards();
    _vehicles = NhtsaVehicleService.getDemoGarage();
    _tier = RevenueCatService.instance.currentTier;

    RevenueCatService.instance.tierStream.listen((newTier) {
      _tier = newTier;
      notifyListeners();
    });
  }

  /// Simulates external bank bill clearance detection via Plaid balance drop
  Map<String, dynamic> simulateExternalPayment(String cardId) {
    final index = _cards.indexWhere((c) => c.id == cardId);
    if (index == -1) return {'success': false, 'coins': 0};

    final card = _cards[index];
    if (card.isPaidThisCycle) return {'success': false, 'coins': 0};

    final clearedAmount = card.statementBalance;

    // Calculate coin reward with tier multipliers
    int multiplier = 1;
    if (_tier == SubscriptionTier.gold) multiplier = 2;
    if (_tier == SubscriptionTier.black) multiplier = 5;

    final earnedCoins = (clearedAmount / 2).round() * multiplier;

    _cards[index] = card.copyWith(
      currentBalance: 0.0,
      statementBalance: 0.0,
      isPaidThisCycle: true,
    );

    _rewards = _rewards.copyWith(
      totalCoins: _rewards.totalCoins + earnedCoins,
      streakDays: _rewards.streakDays + 1,
      totalDebtCleared: _rewards.totalDebtCleared + clearedAmount,
    );

    notifyListeners();
    return {
      'success': true,
      'coins': earnedCoins,
      'clearedAmount': clearedAmount,
      'multiplier': multiplier,
    };
  }

  /// Adds a new vehicle by decoding VIN via NHTSA
  Future<bool> addVehicleByVin(String vin) async {
    if (!canAddMoreVehicles) return false;

    final vehicle = await NhtsaVehicleService.decodeVin(vin);
    _vehicles.insert(0, vehicle);
    notifyListeners();
    return true;
  }

  /// Adds bonus coins (e.g. from mystery vault or milestone)
  void addBonusCoins(int bonus) {
    _rewards = _rewards.copyWith(
      totalCoins: _rewards.totalCoins + bonus,
    );
    notifyListeners();
  }

  /// Claims a perk with coins
  bool claimPerk(RewardPerk perk) {
    if (_rewards.totalCoins < perk.costInCoins) return false;
    if (_rewards.claimedPerkIds.contains(perk.id)) return false;

    _rewards = _rewards.copyWith(
      totalCoins: _rewards.totalCoins - perk.costInCoins,
      claimedPerkIds: [..._rewards.claimedPerkIds, perk.id],
    );
    notifyListeners();
    return true;
  }

  /// Subscribes or upgrades using RevenueCat
  Future<bool> upgradeTier(SubscriptionTier newTier) async {
    final success = await RevenueCatService.instance.purchaseTier(newTier);
    if (success) {
      _tier = newTier;
      notifyListeners();
    }
    return success;
  }

  /// Debug helper for judges & reviewers
  void debugSetTier(SubscriptionTier newTier) {
    RevenueCatService.instance.debugSetTier(newTier);
    _tier = newTier;
    notifyListeners();
  }
}

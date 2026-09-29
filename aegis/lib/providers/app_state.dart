import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/credit_card_model.dart';
import '../models/vehicle_model.dart';
import '../models/reward_model.dart';
import '../models/subscription_tier.dart';
import '../models/asset_model.dart';
import '../services/revenuecat_service.dart';
import '../services/plaid_credit_service.dart';
import '../services/nhtsa_vehicle_service.dart';
import '../services/networth_service.dart';

class AppState extends ChangeNotifier {
  List<CreditCardModel> _cards = [];
  List<VehicleModel> _vehicles = [];
  List<AssetItem> _assets = [];
  List<LiabilityItem> _fixedLiabilities = [];
  UserRewardsState _rewards = UserRewardsState(
    totalCoins: 3420,
    streakDays: 4,
    totalDebtCleared: 8450.0,
    claimedPerkIds: [],
  );
  SubscriptionTier _tier = SubscriptionTier.free;
  StreamSubscription<SubscriptionTier>? _tierSubscription;

  AppState() {
    _init();
  }

  List<CreditCardModel> get cards => _cards;
  List<VehicleModel> get vehicles => _vehicles;
  List<AssetItem> get assets => _assets;
  List<LiabilityItem> get fixedLiabilities => _fixedLiabilities;
  UserRewardsState get rewards => _rewards;
  SubscriptionTier get tier => _tier;

  // Subscription Gates
  bool get isFree => _tier == SubscriptionTier.free;
  bool get isGoldOrHigher => _tier == SubscriptionTier.gold || _tier == SubscriptionTier.black;
  bool get isBlackEdition => _tier == SubscriptionTier.black;

  bool get canAddMoreCards => isGoldOrHigher || _cards.length < 2;
  bool get canAddMoreVehicles => isGoldOrHigher || _vehicles.isEmpty;
  bool get hasAiCardOptimizer => isBlackEdition;
  bool get hasDeepNetWorthAnalytics => isGoldOrHigher;
  bool get hasFireProjectionSimulator => isBlackEdition;

  // Credit Card Computations
  double get totalCurrentBalance => _cards.fold(0.0, (acc, c) => acc + c.currentBalance);
  double get totalCreditLimit => _cards.fold(0.0, (acc, c) => acc + c.creditLimit);
  double get overallUtilization => totalCreditLimit > 0 ? (totalCurrentBalance / totalCreditLimit) : 0.0;

  // Unified Net Worth Computations
  double get totalVehicleAssetValue => _vehicles.fold(0.0, (acc, v) => acc + v.estimatedValue);
  double get totalManualAssetValue => _assets.fold(0.0, (acc, a) => acc + a.valuation);
  double get totalAssetValue => totalManualAssetValue + totalVehicleAssetValue;

  double get totalFixedLiabilityValue => _fixedLiabilities.fold(0.0, (acc, l) => acc + l.balance);
  double get totalLiabilityValue => totalFixedLiabilityValue + totalCurrentBalance;

  double get netWorth => totalAssetValue - totalLiabilityValue;

  // Asset Allocation Breakdown
  double get cashAssets => _assets
      .where((a) => a.category == AssetCategory.cash)
      .fold(0.0, (acc, a) => acc + a.valuation);

  double get investmentAssets => _assets
      .where((a) => a.category == AssetCategory.investments)
      .fold(0.0, (acc, a) => acc + a.valuation);

  double get realEstateAssets => _assets
      .where((a) => a.category == AssetCategory.realEstate)
      .fold(0.0, (acc, a) => acc + a.valuation);

  double get vehicleAssets => totalVehicleAssetValue;

  double get cryptoAssets => _assets
      .where((a) => a.category == AssetCategory.crypto)
      .fold(0.0, (acc, a) => acc + a.valuation);

  double get retirementAssets => _assets
      .where((a) => a.category == AssetCategory.retirement)
      .fold(0.0, (acc, a) => acc + a.valuation);

  // Historical Trajectory
  List<NetWorthSnapshot> get netWorthHistory => NetWorthService.getHistoricalSnapshots(
        currentNetWorth: netWorth,
        currentAssets: totalAssetValue,
        currentLiabilities: totalLiabilityValue,
      );

  double get monthlyNetWorthChange {
    final history = netWorthHistory;
    if (history.length < 2) return 0.0;
    return netWorth - history[history.length - 2].netWorth;
  }

  double get monthlyNetWorthChangePercent {
    final history = netWorthHistory;
    if (history.length < 2) return 0.0;
    final prev = history[history.length - 2].netWorth;
    return prev > 0 ? (monthlyNetWorthChange / prev) * 100 : 0.0;
  }

  // Liquidity Health Metric (Months of expenses covered by liquid cash, assuming $6k/mo baseline)
  double get liquidityRunwayMonths => cashAssets > 0 ? (cashAssets / 6000.0) : 0.0;

  CreditCardModel? get nearestDueCard {
    final unpaid = _cards.where((c) => !c.isPaidThisCycle).toList();
    if (unpaid.isEmpty) return null;
    unpaid.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return unpaid.first;
  }

  void _init() {
    _cards = PlaidCreditService.getInitialCards();
    _vehicles = NhtsaVehicleService.getDemoGarage();
    _assets = NetWorthService.getInitialAssets();
    _fixedLiabilities = NetWorthService.getInitialLiabilities();
    _tier = RevenueCatService.instance.currentTier;

    _tierSubscription = RevenueCatService.instance.tierStream.listen((newTier) {
      _tier = newTier;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _tierSubscription?.cancel();
    super.dispose();
  }

  void addAsset(AssetItem asset) {
    _assets.insert(0, asset);
    notifyListeners();
  }

  void removeAsset(String assetId) {
    _assets.removeWhere((a) => a.id == assetId);
    notifyListeners();
  }

  void addLiability(LiabilityItem liability) {
    _fixedLiabilities.insert(0, liability);
    notifyListeners();
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

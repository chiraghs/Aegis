import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../models/credit_card_model.dart';
import '../models/vehicle_model.dart';
import '../models/reward_model.dart';
import '../models/subscription_tier.dart';
import '../models/asset_model.dart';
import '../models/garage_extras_model.dart';
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
  ThemeMode _themeMode = ThemeMode.dark;

  // CRED Garage Extended State
  int _selectedVehicleIndex = 0;
  List<InsurancePolicyModel> _insurancePolicies = [];
  List<ChallanModel> _challans = [];
  List<VehicleSpendItem> _vehicleSpends = [];
  List<GloveboxDocModel> _gloveboxDocs = [];
  List<RushHourRewardModel> _rushHourRewards = [];

  AppState() {
    _init();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    AppThemeConfig.setThemeMode(mode);
    notifyListeners();
  }

  void toggleThemeMode() {
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(nextMode);
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
  bool get canAddMoreVehicles => isGoldOrHigher || _vehicles.length < 5;
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

    // Aegis US Garage Initial Seed Data
    _insurancePolicies = [
      InsurancePolicyModel(
        id: 'pol_1',
        provider: 'GEICO',
        providerLogo: 'shield',
        policyNumber: 'GEICO-CA-882910',
        coverageType: 'Comprehensive & Collision',
        annualPremium: 1380.0,
        expiryDate: DateTime.now().add(const Duration(days: 210)),
        isActive: true,
        vehicleId: 'car_tesla_3',
        idv: 42500.0,
      ),
      InsurancePolicyModel(
        id: 'pol_2',
        provider: 'Progressive',
        providerLogo: 'pgr',
        policyNumber: 'PGR-992140-US',
        coverageType: 'Full Coverage + Roadside',
        annualPremium: 1540.0,
        expiryDate: DateTime.now().add(const Duration(days: 140)),
        isActive: true,
        vehicleId: 'car_tesla_3',
        idv: 45000.0,
      ),
    ];

    _challans = [
      ChallanModel(
        id: 'chl_1',
        violationType: 'SFMTA Red Light Camera (Market & 4th St, San Francisco, CA)',
        location: 'Market & 4th St, San Francisco, CA',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 150.0,
        isPaid: false,
        citationNumber: 'SF-MTA-2026-9921',
        cameraImageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
      ),
      ChallanModel(
        id: 'chl_2',
        violationType: 'NYC Dept of Finance Expired Parking Meter',
        location: 'Broadway & 5th Ave, New York, NY',
        date: DateTime.now().subtract(const Duration(days: 35)),
        amount: 65.0,
        isPaid: true,
        citationNumber: 'NYC-DOF-2026-3810',
      ),
    ];

    _vehicleSpends = [
      VehicleSpendItem(
        id: 'sp_1',
        category: 'SERVICE',
        merchant: 'Costco Wholesale Tire Center',
        amount: 162.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        icon: Icons.tire_repair,
      ),
      VehicleSpendItem(
        id: 'sp_2',
        category: 'SERVICE',
        merchant: 'Valvoline Instant Oil Change',
        amount: 98.0,
        date: DateTime.now().subtract(const Duration(days: 5)),
        icon: Icons.build,
      ),
      VehicleSpendItem(
        id: 'sp_3',
        category: 'FUEL',
        merchant: 'Chevron Station #4021 - SFO',
        amount: 65.0,
        date: DateTime.now().subtract(const Duration(days: 9)),
        icon: Icons.local_gas_station,
      ),
      VehicleSpendItem(
        id: 'sp_4',
        category: 'TOLLS',
        merchant: 'FasTrak Bay Area Bridges & Express',
        amount: 36.0,
        date: DateTime.now().subtract(const Duration(days: 14)),
        icon: Icons.toll,
      ),
      VehicleSpendItem(
        id: 'sp_5',
        category: 'EV CHARGING',
        merchant: 'Tesla Supercharger - Baker, CA',
        amount: 24.5,
        date: DateTime.now().subtract(const Duration(days: 21)),
        icon: Icons.ev_station,
      ),
    ];

    _gloveboxDocs = [
      GloveboxDocModel(
        id: 'doc_rc',
        title: 'California DMV Electronic Vehicle Registration',
        docType: 'Registration',
        docNumber: 'CA-REG-2026-8812',
        issuingAuthority: 'State of California DMV',
        validUntil: DateTime(2027, 03, 15),
      ),
      GloveboxDocModel(
        id: 'doc_dl',
        title: 'State Driver License / Apple Wallet mDL',
        docType: 'Driver License',
        docNumber: 'CA-DL-D0829124',
        issuingAuthority: 'Department of Motor Vehicles',
        validUntil: DateTime(2031, 08, 22),
      ),
      GloveboxDocModel(
        id: 'doc_ins',
        title: 'GEICO Proof of Auto Insurance Card',
        docType: 'Insurance',
        docNumber: 'GEICO-CA-882910',
        issuingAuthority: 'GEICO Casualty Company',
        validUntil: DateTime.now().add(const Duration(days: 210)),
      ),
      GloveboxDocModel(
        id: 'doc_puc',
        title: 'BAR Certified Smog & Safety Inspection',
        docType: 'Smog / Inspection',
        docNumber: 'BAR-SMOG-2026-PASS',
        issuingAuthority: 'Bureau of Automotive Repair',
        validUntil: DateTime(2027, 09, 30),
      ),
    ];

    _rushHourRewards = [
      RushHourRewardModel(
        id: 'rh_1',
        categoryTag: 'MEGA JACKPOT',
        title: 'win Apple Watch Ultra 2 worth \$799',
        subtitle: 'Peak traffic rush hour unlocked',
        valueText: '\$799',
        icon: Icons.watch,
      ),
      RushHourRewardModel(
        id: 'rh_2',
        categoryTag: 'RECHARGE TOLL PASS',
        title: 'win FasTrak / E-ZPass toll credit worth \$250',
        subtitle: 'Instant express toll gateway clearance',
        valueText: '\$250',
        icon: Icons.toll,
      ),
      RushHourRewardModel(
        id: 'rh_3',
        categoryTag: 'SUPERCHARGER DROP',
        title: 'Tesla Supercharging / Electrify America credit worth \$100',
        subtitle: '100% discount on DC fast chargers across US',
        valueText: '\$100',
        icon: Icons.ev_station,
      ),
    ];

    _tierSubscription = RevenueCatService.instance.tierStream.listen((newTier) {
      _tier = newTier;
      notifyListeners();
    });

    // Proactively hit official US NHTSA API for the active vehicle
    refreshActiveVehicleNhtsaData();
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

  // --- CRED GARAGE GETTERS & ACTIONS ---

  int get selectedVehicleIndex => _selectedVehicleIndex;

  VehicleModel get activeVehicle {
    if (_vehicles.isEmpty) {
      return VehicleModel(
        id: 'car_none',
        vin: 'UNKNOWN',
        make: 'Vehicle',
        model: 'None',
        year: 2024,
        trim: '',
        mileage: 0,
        fuelOrBatteryLevel: 0.5,
        isElectric: false,
        estimatedMarketValue: 0.0,
        loanBalance: 0.0,
        nextServiceDate: DateTime.now(),
        activeRecalls: 0,
      );
    }
    return _vehicles[_selectedVehicleIndex.clamp(0, _vehicles.length - 1)];
  }

  void selectGarageVehicle(int index) {
    if (index >= 0 && index < _vehicles.length) {
      _selectedVehicleIndex = index;
      notifyListeners();
      refreshActiveVehicleNhtsaData();
    }
  }

  /// Refreshes live NHTSA Safety Recalls & Specs over HTTP for the active vehicle
  Future<void> refreshActiveVehicleNhtsaData() async {
    if (_vehicles.isEmpty) return;
    try {
      final active = activeVehicle;
      final liveRecalls = await NhtsaVehicleService.fetchRecalls(active.make, active.model, active.year);
      final idx = _selectedVehicleIndex;
      if (idx >= 0 && idx < _vehicles.length) {
        _vehicles[idx] = _vehicles[idx].copyWith(
          recalls: liveRecalls,
          activeRecalls: liveRecalls.length,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error refreshing NHTSA recalls: $e');
    }
  }

  List<InsurancePolicyModel> get insurancePolicies => _insurancePolicies;
  List<ChallanModel> get challans => _challans;
  int get unpaidChallansCount => _challans.where((c) => !c.isPaid).length;
  double get unpaidChallansAmount => _challans.where((c) => !c.isPaid).fold(0.0, (s, c) => s + c.amount);

  bool payChallan(String id) {
    final idx = _challans.indexWhere((c) => c.id == id);
    if (idx == -1 || _challans[idx].isPaid) return false;
    final challan = _challans[idx];
    _challans[idx] = challan.copyWith(isPaid: true);

    // Mint 2X Aegis Coins for clearing fines promptly!
    final coinsAwarded = (challan.amount * 2).toInt();
    _rewards = _rewards.copyWith(
      totalCoins: _rewards.totalCoins + coinsAwarded,
      totalDebtCleared: _rewards.totalDebtCleared + challan.amount,
    );
    notifyListeners();
    return true;
  }

  void purchaseOrSellInsurancePolicy(InsurancePolicyModel policy, {bool isSelling = false}) {
    _insurancePolicies.insert(0, policy);
    // Commission / Cashback reward in Aegis Coins ($200 selling commission / $100 buyer cashback)
    final bonus = isSelling ? 2000 : 1000;
    _rewards = _rewards.copyWith(totalCoins: _rewards.totalCoins + bonus);
    notifyListeners();
  }

  List<VehicleSpendItem> get vehicleSpends => _vehicleSpends;
  double get totalSeptemberSpend => _vehicleSpends.fold(0.0, (s, e) => s + e.amount);

  List<GloveboxDocModel> get gloveboxDocs => _gloveboxDocs;
  List<RushHourRewardModel> get rushHourRewards => _rushHourRewards;

  bool claimRushHourReward(String id) {
    final idx = _rushHourRewards.indexWhere((r) => r.id == id);
    if (idx == -1 || _rushHourRewards[idx].isClaimed) return false;
    _rushHourRewards[idx] = _rushHourRewards[idx].copyWith(isClaimed: true);
    _rewards = _rewards.copyWith(totalCoins: _rewards.totalCoins + 500);
    notifyListeners();
    return true;
  }
}

import '../models/asset_model.dart';

class NetWorthService {
  static List<AssetItem> getInitialAssets() {
    return [
      AssetItem(
        id: 'asset_chase_checking',
        name: 'Premier Checking',
        institution: 'Chase Bank',
        category: AssetCategory.cash,
        valuation: 18450.0,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        monthlyChangePercent: 3.2,
      ),
      AssetItem(
        id: 'asset_marcus_hysa',
        name: 'High-Yield Savings (4.4% APY)',
        institution: 'Marcus by Goldman Sachs',
        category: AssetCategory.cash,
        valuation: 45000.0,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
        monthlyChangePercent: 4.4,
      ),
      AssetItem(
        id: 'asset_vanguard_brokerage',
        name: 'Total Market Index (VTI/VOO)',
        institution: 'Vanguard Brokerage',
        category: AssetCategory.investments,
        valuation: 142800.0,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 45)),
        monthlyChangePercent: 5.8,
      ),
      AssetItem(
        id: 'asset_fidelity_tech',
        name: 'Tech Growth & RSU Portfolio',
        institution: 'Fidelity Investments',
        category: AssetCategory.investments,
        valuation: 88200.0,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        monthlyChangePercent: 7.1,
      ),
      AssetItem(
        id: 'asset_austin_home',
        name: 'Primary Residence (Austin, TX)',
        institution: 'Automated Zillow Valuation',
        category: AssetCategory.realEstate,
        valuation: 340000.0,
        lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
        monthlyChangePercent: 0.8,
      ),
      AssetItem(
        id: 'asset_vanguard_ira',
        name: 'Roth IRA Retirement',
        institution: 'Vanguard',
        category: AssetCategory.retirement,
        valuation: 62000.0,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
        monthlyChangePercent: 4.2,
      ),
      AssetItem(
        id: 'asset_coldcard_btc',
        name: 'Bitcoin Cold Storage (BTC)',
        institution: 'Coldcard Vault',
        category: AssetCategory.crypto,
        valuation: 38500.0,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
        monthlyChangePercent: 9.4,
      ),
    ];
  }

  static List<LiabilityItem> getInitialLiabilities() {
    return [
      const LiabilityItem(
        id: 'liab_home_mortgage',
        name: 'Austin Residence Mortgage',
        lender: 'Chase Home Lending (3.125% Fixed)',
        category: LiabilityCategory.mortgage,
        balance: 215000.0,
        interestRateApr: 3.125,
        monthlyPayment: 1350.0,
      ),
      const LiabilityItem(
        id: 'liab_auto_loan',
        name: 'Vehicle Financing',
        lender: 'Porsche Financial Services',
        category: LiabilityCategory.autoLoan,
        balance: 42000.0,
        interestRateApr: 4.89,
        monthlyPayment: 890.0,
      ),
    ];
  }

  static List<NetWorthSnapshot> getHistoricalSnapshots({
    required double currentNetWorth,
    required double currentAssets,
    required double currentLiabilities,
  }) {
    // Generate realistic 6-month historical progression
    return [
      NetWorthSnapshot(
        monthLabel: 'Apr',
        totalAssets: currentAssets * 0.91,
        totalLiabilities: currentLiabilities * 1.05,
        netWorth: (currentAssets * 0.91) - (currentLiabilities * 1.05),
      ),
      NetWorthSnapshot(
        monthLabel: 'May',
        totalAssets: currentAssets * 0.93,
        totalLiabilities: currentLiabilities * 1.04,
        netWorth: (currentAssets * 0.93) - (currentLiabilities * 1.04),
      ),
      NetWorthSnapshot(
        monthLabel: 'Jun',
        totalAssets: currentAssets * 0.945,
        totalLiabilities: currentLiabilities * 1.025,
        netWorth: (currentAssets * 0.945) - (currentLiabilities * 1.025),
      ),
      NetWorthSnapshot(
        monthLabel: 'Jul',
        totalAssets: currentAssets * 0.965,
        totalLiabilities: currentLiabilities * 1.015,
        netWorth: (currentAssets * 0.965) - (currentLiabilities * 1.015),
      ),
      NetWorthSnapshot(
        monthLabel: 'Aug',
        totalAssets: currentAssets * 0.985,
        totalLiabilities: currentLiabilities * 1.008,
        netWorth: (currentAssets * 0.985) - (currentLiabilities * 1.008),
      ),
      NetWorthSnapshot(
        monthLabel: 'Sep',
        totalAssets: currentAssets,
        totalLiabilities: currentLiabilities,
        netWorth: currentNetWorth,
      ),
    ];
  }
}

enum PerkCategory { travel, lifestyle, tech, dining }

class RewardPerk {
  final String id;
  final String title;
  final String partner;
  final String description;
  final int costInCoins;
  final PerkCategory category;
  final String iconCode;
  final bool isExclusiveBlackTier;

  const RewardPerk({
    required this.id,
    required this.title,
    required this.partner,
    required this.description,
    required this.costInCoins,
    required this.category,
    required this.iconCode,
    this.isExclusiveBlackTier = false,
  });
}

class UserRewardsState {
  final int totalCoins;
  final int streakDays;
  final double totalDebtCleared;
  final List<String> claimedPerkIds;

  UserRewardsState({
    required this.totalCoins,
    required this.streakDays,
    required this.totalDebtCleared,
    required this.claimedPerkIds,
  });

  UserRewardsState copyWith({
    int? totalCoins,
    int? streakDays,
    double? totalDebtCleared,
    List<String>? claimedPerkIds,
  }) {
    return UserRewardsState(
      totalCoins: totalCoins ?? this.totalCoins,
      streakDays: streakDays ?? this.streakDays,
      totalDebtCleared: totalDebtCleared ?? this.totalDebtCleared,
      claimedPerkIds: claimedPerkIds ?? this.claimedPerkIds,
    );
  }
}

class Summoner {
  final String id;
  final String accountId;
  final String puuid;
  final String name;
  final int profileIconId;
  final int revisionDate;
  final int summonerLevel;
  final Rank? soloRank;
  final Rank? flexRank;

  Summoner({
    required this.id,
    required this.accountId,
    required this.puuid,
    required this.name,
    required this.profileIconId,
    required this.revisionDate,
    required this.summonerLevel,
    this.soloRank,
    this.flexRank,
  });

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      id: json['id'],
      accountId: json['accountId'],
      puuid: json['puuid'],
      name: json['name'],
      profileIconId: json['profileIconId'],
      revisionDate: json['revisionDate'],
      summonerLevel: json['summonerLevel'],
      //RANKED_FLEX_SR" -> Map (5 items)
      //"RANKED_SOLO_5x5
      soloRank: json['RANKED_SOLO_5x5'] != null
          ? Rank.fromJson(json['RANKED_SOLO_5x5'])
          : null,
      flexRank: json['RANKED_FLEX_SR'] != null
          ? Rank.fromJson(json['RANKED_FLEX_SR'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'puuid': puuid,
      'name': name,
      'profileIconId': profileIconId,
      'revisionDate': revisionDate,
      'summonerLevel': summonerLevel,
      'soloRank': soloRank?.toJson(),
      'flexRank': flexRank?.toJson(),
    };
  }

  bool areSummonersEqual(Summoner? other) {
    if (other == null) {
      // The other summoner is null, so they are considered different
      return false;
    } else {
      // Compare the fields of both summoners
      return id == other.id &&
          accountId == other.accountId &&
          puuid == other.puuid &&
          name == other.name &&
          profileIconId == other.profileIconId &&
          revisionDate == other.revisionDate &&
          summonerLevel == other.summonerLevel &&
          areRanksEqual(soloRank, other.soloRank) &&
          areRanksEqual(flexRank, other.flexRank);
    }
  }

  bool areRanksEqual(Rank? rank1, Rank? rank2) {
    if (rank1 == null && rank2 == null) {
      // Both ranks are null, so they are considered equal
      return true;
    } else if (rank1 == null || rank2 == null) {
      // One rank is null and the other is not, so they are considered different
      return false;
    } else {
      // Both ranks are not null, so compare their fields
      return rank1.tier == rank2.tier &&
          rank1.rank == rank2.rank &&
          rank1.leaguePoints == rank2.leaguePoints &&
          rank1.wins == rank2.wins &&
          rank1.losses == rank2.losses;
    }
  }
}

class Rank {
  final String? tier;
  final String? rank;
  final int? leaguePoints;
  final int? wins;
  final int? losses;

  Rank({this.tier, this.rank, this.leaguePoints, this.wins, this.losses});

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
        tier: json['tier'],
        rank: json['rank'],
        leaguePoints: json['leaguePoints'],
        wins: json['wins'],
        losses: json['losses']);
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier,
      'rank': rank,
      'leaguePoints': leaguePoints,
      'wins': wins,
      'losses': losses,
    };
  }
}

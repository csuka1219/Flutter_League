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
}

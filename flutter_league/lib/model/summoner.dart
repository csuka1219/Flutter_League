class Summoner {
  final String id;
  final String accountId;
  final String puuid;
  final String name;
  final int profileIconId;
  final int revisionDate;
  final int summonerLevel;
  final String? tier;
  final String? rank;
  final int? leaguePoints;
  final int? wins;
  final int? losses;

  Summoner(
      {required this.id,
      required this.accountId,
      required this.puuid,
      required this.name,
      required this.profileIconId,
      required this.revisionDate,
      required this.summonerLevel,
      this.tier,
      this.rank,
      this.leaguePoints,
      this.wins,
      this.losses});

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      id: json['id'],
      accountId: json['accountId'],
      puuid: json['puuid'],
      name: json['name'],
      profileIconId: json['profileIconId'],
      revisionDate: json['revisionDate'],
      summonerLevel: json['summonerLevel'],
      tier: json['tier'],
      rank: json['rank'],
      leaguePoints: json['leaguePoints'],
      wins: json['wins'],
      losses: json['losses'],
    );
  }
}

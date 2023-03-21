class PlayerStats {
  final String summonerName;
  final int assists;
  final int champLevel;
  final int championId;
  final String championName;
  final int championTransform;
  final int deaths;
  final int item0;
  final int item1;
  final int item2;
  final int item3;
  final int item4;
  final int item5;
  final int item6;
  final List<int> items;
  final int kills;
  final String role;
  final int summoner1Id;
  final int summoner2Id;
  final int totalCS;
  final int goldEarned;
  final int totalDamageDealtToChampions;
  final int totalDamageTaken;
  final int wardsPlaced;
  final bool win;
  final Perks perks;
//   goldEarned
// totalDamageDealt
// totalDamageTaken
// wardsPlaced

  PlayerStats(
      {required this.summonerName,
      required this.assists,
      required this.champLevel,
      required this.championId,
      required this.championName,
      required this.championTransform,
      required this.deaths,
      required this.item0,
      required this.item1,
      required this.item2,
      required this.item3,
      required this.item4,
      required this.item5,
      required this.item6,
      required this.items,
      required this.kills,
      required this.role,
      required this.summoner1Id,
      required this.summoner2Id,
      required this.totalCS,
      required this.goldEarned,
      required this.totalDamageDealtToChampions,
      required this.totalDamageTaken,
      required this.wardsPlaced,
      required this.win,
      required this.perks});
  factory PlayerStats.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> perksJson) {
    return PlayerStats(
      summonerName: json['summonerName'],
      assists: json['assists'],
      champLevel: json['champLevel'],
      championId: json['championId'],
      championName: json['championName'],
      championTransform: json['championTransform'],
      deaths: json['deaths'],
      item0: json['item0'],
      item1: json['item1'],
      item2: json['item2'],
      item3: json['item3'],
      item4: json['item4'],
      item5: json['item5'],
      item6: json['item6'],
      items: [
        json['item0'],
        json['item1'],
        json['item2'],
        json['item3'],
        json['item4'],
        json['item5'],
        json['item6'],
      ],
      kills: json['kills'],
      role: json['teamPosition'],
      summoner1Id: json['summoner1Id'],
      summoner2Id: json['summoner2Id'],
      totalCS: json['totalMinionsKilled'] + json['neutralMinionsKilled'],
      goldEarned: json['goldEarned'],
      totalDamageDealtToChampions: json['totalDamageDealtToChampions'],
      totalDamageTaken: json['totalDamageTaken'],
      wardsPlaced: json['wardsPlaced'],
      win: json['win'],
      perks: Perks.fromJson(perksJson),
    );
  }
  static int sumByProperty(
      List<PlayerStats> list, int Function(PlayerStats) selector) {
    return list.fold(0, (sum, stats) => sum + selector(stats));
  }
}

class Perks {
  final int primaryStyle;
  final int secondaryStyle;

  Perks({required this.primaryStyle, required this.secondaryStyle});

  factory Perks.fromJson(Map<String, dynamic> json) {
    final primaryStyle = json['styles'][0]['selections'][0]['perk'];
    final secondaryStyle = json['styles'][1]['style'];

    return Perks(primaryStyle: primaryStyle, secondaryStyle: secondaryStyle);
  }
}

class StyleSelection {
  final int perk;

  StyleSelection({required this.perk});

  factory StyleSelection.fromJson(Map<String, dynamic> json) {
    return StyleSelection(perk: json['perk'] as int);
  }
}

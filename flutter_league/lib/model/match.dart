class Match {
  final String tier;
  final String rank;
  final int gameDuration;
  final String gameMode;
  final List<dynamic> teams;
  final List<dynamic> participants;

  Match({
    required this.tier,
    required this.rank,
    required this.gameDuration,
    required this.gameMode,
    required this.teams,
    required this.participants,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      tier: json['tier'],
      rank: json['rank'],
      gameDuration: json['gameDuration'],
      gameMode: json['gameMode'],
      teams: json['teams'],
      participants: json['participants'],
    );
  }
}

class Participants {
  final int champLevel;
  final int championId;
  final int championTransform;
  final int deaths;
  final int goldEarned;
  final int item0;
  final int item1;
  final int item2;
  final int item3;
  final int item4;
  final int item5;
  final int item6;
  final int kills;
  final String lane;
  final int pentaKills;
  final String role;
  final int summoner1Id;
  final int summoner2Id;
  final int summonerLevel;
  final String summonerName;
  final int totalDamageDealtToChampions;
  final int totalDamageTaken;
  final int totalHeal;
  final int totalMinionsKilled;
  final int wardsPlaced;
  final bool win;

  Participants({
    required this.champLevel,
    required this.championId,
    required this.championTransform,
    required this.deaths,
    required this.goldEarned,
    required this.item0,
    required this.item1,
    required this.item2,
    required this.item3,
    required this.item4,
    required this.item5,
    required this.item6,
    required this.kills,
    required this.lane,
    required this.pentaKills,
    required this.role,
    required this.summoner1Id,
    required this.summoner2Id,
    required this.summonerLevel,
    required this.summonerName,
    required this.totalDamageDealtToChampions,
    required this.totalDamageTaken,
    required this.totalHeal,
    required this.totalMinionsKilled,
    required this.wardsPlaced,
    required this.win,
  });
  factory Participants.fromJson(Map<String, dynamic> json) {
    return Participants(
      champLevel: json['champLevel'],
      championId: json['championId'],
      championTransform: json['championTransform'],
      deaths: json['deaths'],
      goldEarned: json['goldEarned'],
      item0: json['item0'],
      item1: json['item1'],
      item2: json['item2'],
      item3: json['item3'],
      item4: json['item4'],
      item5: json['item5'],
      item6: json['item6'],
      kills: json['kills'],
      lane: json['lane'],
      pentaKills: json['pentaKills'],
      role: json['role'],
      summoner1Id: json['summoner1Id'],
      summoner2Id: json['summoner2Id'],
      summonerLevel: json['summonerLevel'],
      summonerName: json['summonerName'],
      totalDamageDealtToChampions: json['totalDamageDealtToChampions'],
      totalDamageTaken: json['totalDamageTaken'],
      totalHeal: json['totalHeal'],
      totalMinionsKilled: json['totalMinionsKilled'],
      wardsPlaced: json['wardsPlaced'],
      win: json['win'],
    );
  }
}

class Baron {
  final bool first;
  final int kills;

  Baron({
    required this.first,
    required this.kills,
  });

  factory Baron.fromJson(Map<String, dynamic> json) {
    return Baron(
      first: json['first'],
      kills: json['kills'],
    );
  }
}

class Dragon {
  final bool first;
  final int kills;

  Dragon({
    required this.first,
    required this.kills,
  });

  factory Dragon.fromJson(Map<String, dynamic> json) {
    return Dragon(
      first: json['first'],
      kills: json['kills'],
    );
  }
}

class Tower {
  final int kills;

  Tower({
    required this.kills,
  });

  factory Tower.fromJson(Map<String, dynamic> json) {
    return Tower(
      kills: json['kills'],
    );
  }
}

class Objectives {
  final Baron baron;
  final Dragon dragon;
  final Tower tower;

  Objectives({
    required this.baron,
    required this.dragon,
    required this.tower,
  });

  factory Objectives.fromJson(Map<String, dynamic> json) {
    return Objectives(
      baron: Baron.fromJson(json['baron']),
      dragon: Dragon.fromJson(json['dragon']),
      tower: Tower.fromJson(json['tower']),
    );
  }
}

class Team {
  final Objectives objectives;
  final bool win;

  Team({
    required this.objectives,
    required this.win,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      objectives: Objectives.fromJson(json['objectives']),
      win: json['win'],
    );
  }
}

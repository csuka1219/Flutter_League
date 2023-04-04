class LiveGame {
  final int gameModeId;
  final List<Participant> participants;
  final int gameLength;

  LiveGame(
      {required this.gameModeId,
      required this.participants,
      required this.gameLength});

  factory LiveGame.fromJson(Map<String, dynamic> json) {
    List<Participant> participants = [];
    for (var participantJson in json['participants']) {
      Participant participant = Participant.fromJson(participantJson);
      participants.add(participant);
    }
    return LiveGame(
        gameModeId: json['gameQueueConfigId'],
        participants: participants,
        gameLength: json['gameLength']);
  }
}

class Participant {
  final int teamId;
  final int spell1Id;
  final int spell2Id;
  final int championId;
  final String summonerName;
  final String summonerId;
  final int perkStyle;
  final int perkSubStyle;

  Participant(
      {required this.teamId,
      required this.spell1Id,
      required this.spell2Id,
      required this.championId,
      required this.summonerName,
      required this.summonerId,
      required this.perkStyle,
      required this.perkSubStyle});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
        teamId: json['teamId'],
        spell1Id: json['spell1Id'],
        spell2Id: json['spell2Id'],
        championId: json['championId'],
        summonerName: json['summonerName'],
        summonerId: json['summonerId'],
        perkStyle: json['perks']['perkIds'][0],
        perkSubStyle: json['perks']['perkSubStyle']);
  }
}

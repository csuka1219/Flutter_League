import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/model/playerstats.dart';

class Match {
  final int gameDuration;
  final int queueId;
  final List<Team> teams;
  final List<PlayerStats> participants;

  Match({
    required this.gameDuration,
    required this.queueId,
    required this.teams,
    required this.participants,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    List<PlayerStats> participants = [];
    for (var participantJson in json['participants']) {
      final perksJson = participantJson['perks'] as Map<String, dynamic>;
      PlayerStats participant =
          PlayerStats.fromJson(participantJson, perksJson);
      participants.add(participant);
    }
    return Match(
      gameDuration: json['gameDuration'],
      queueId: json['queueId'],
      teams: [Team.fromJson(json['teams'][0]), Team.fromJson(json['teams'][1])],
      participants: participants,
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

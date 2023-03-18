import 'package:flutter_riot_api/model/playerstats.dart';

class MatchPreview {
  final int gameDuration;
  final PlayerStats playerStats;
  final int queueId;
  final String matchId;

  MatchPreview(
      {required this.gameDuration,
      required this.playerStats,
      required this.queueId,
      required this.matchId});

  factory MatchPreview.fromJson(Map<String, dynamic> json,
      Map<String, dynamic> participant, String matchId) {
    final playerStatsJson = participant;
    final perksJson = participant['perks'] as Map<String, dynamic>;

    return MatchPreview(
        gameDuration: json['gameDuration'] as int,
        playerStats: PlayerStats.fromJson(playerStatsJson, perksJson),
        queueId: json['queueId'],
        matchId: matchId);
  }
}

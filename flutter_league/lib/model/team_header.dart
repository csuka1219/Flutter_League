import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/model/playerstats.dart';

class TeamHeader {
  final int kills;
  final int deaths;
  final int assists;
  final int turrets;
  final int dragons;
  final int barons;

  TeamHeader(List<PlayerStats> playerStats, Team team)
      : kills = playerStats.fold(0, (total, element) => total + element.kills),
        deaths =
            playerStats.fold(0, (total, element) => total + element.deaths),
        assists =
            playerStats.fold(0, (total, element) => total + element.assists),
        turrets = team.objectives.tower.kills,
        dragons = team.objectives.dragon.kills,
        barons = team.objectives.baron.kills;
}

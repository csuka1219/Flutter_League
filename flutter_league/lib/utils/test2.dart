import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/utils/pulldata.dart';
import 'package:flutter_riot_api/utils/test.dart';

dynamic getTeamRoles(List<Participant> participants,
    Map<String, Map<String, double>> championRoles) async {
  championRoles = await pullData();

  List<int> champions = participants.map((p) => p.championId).toList();
  //champions = [82, 876, 147, 236, 1];
  int smite = 0;

  for (final participant in participants) {
    if (participant.spell1Id == 11 || participant.spell2Id == 11) {
      if (smite == 0) {
        smite = participant.championId;
        break;
      }
    }
  }

  dynamic positions;
  if (smite == 0) {
    positions = getPositions(championRoles, champions);
  } else {
    positions = getPositions(championRoles, champions, jungle: smite);
  }

  dynamic teamRoles = {};
  for (final entry in positions.entries) {
    // 82
    // 876
    // 84
    // 236
    // 37
    // final position = Position.fromString(entry.value);
    // final champion = Champion(id: entry.key, region: 'NA');
    //teamRoles[position] = champion;
    int a = 0;
  }

  return teamRoles;
}

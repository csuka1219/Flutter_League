import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/utils/pulldata.dart';
import 'package:flutter_riot_api/utils/test.dart';

dynamic getRoles(List<Participant> participants) async {
  Map<String, Map<String, double>> championRoles = await pullData();

  //champions = [82, 876, 147, 236, 1];
  List<int> roles = [];
  roles=(getTeamRoles(participants.take(5).toList(), championRoles));
  roles.addAll(getTeamRoles(participants.skip(5).take(5).toList(), championRoles));
  participants.sort((a, b) => roles.indexOf(a.championId).compareTo(roles.indexOf(b.championId)));
  return roles;
}

List<int> getTeamRoles(List<Participant> participants, Map<String, Map<String, double>> championRoles) {
  List<int> champions = participants.map((p) => p.championId).toList();
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
  for (final entry in positions) {
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
  
  return positions[0];
}

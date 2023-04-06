import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/services/pulldata.dart';
import 'package:flutter_riot_api/utils/roleidentification.dart';

dynamic sortByRole(List<Participant> participants) async {
  Map<String, Map<String, double>> championRoles = await pullData();

  List<int> positions = [];
  positions = (getTeamRoles(participants.take(5).toList(), championRoles));
  positions.addAll(
      getTeamRoles(participants.skip(5).take(5).toList(), championRoles));
  participants.sort((a, b) => positions
      .indexOf(a.championId)
      .compareTo(positions.indexOf(b.championId)));
  return positions;
}

List<int> getTeamRoles(List<Participant> participants,
    Map<String, Map<String, double>> championRoles) {
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

  return positions[0];
}

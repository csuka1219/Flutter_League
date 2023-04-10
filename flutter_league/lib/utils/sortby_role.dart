import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/services/pulldata.dart';
import 'package:flutter_riot_api/utils/roleidentification.dart';

/// This function sorts the participants in a given list by their role using champion data from MerakiAnalytics API
dynamic sortByRole(List<Participant> participants) async {
  // Get the champion roles data from the MerakiAnalytics API using the `pullData()` function
  Map<String, Map<String, double>> championRoles = await pullData();

  // Get the role positions for the first and second team using the `getTeamRoles()` function
  List<int> positions = [];
  positions = (getTeamRoles(participants.take(5).toList(), championRoles));
  positions.addAll(
      getTeamRoles(participants.skip(5).take(5).toList(), championRoles));

  // Sort the participants based on their role positions using the `sort()` function
  participants.sort((a, b) => positions
      .indexOf(a.championId)
      .compareTo(positions.indexOf(b.championId)));

  // Return the role positions of the participants
  return positions;
}

/// This function returns the role positions of a given list of participants
List<int> getTeamRoles(List<Participant> participants,
    Map<String, Map<String, double>> championRoles) {
  // Create a list of champion IDs for the given participants
  List<int> champions = participants.map((p) => p.championId).toList();
  int smite = 0;

  // Check if any participant has Smite spell and assign that champion ID to `smite`
  for (final participant in participants) {
    if (participant.spell1Id == 11 || participant.spell2Id == 11) {
      if (smite == 0) {
        smite = participant.championId;
        break;
      }
    }
  }

  // Get the role positions of the given champions using the `getPositions()` function
  dynamic positions;
  if (smite == 0) {
    positions = getPositions(championRoles, champions);
  } else {
    positions = getPositions(championRoles, champions, jungle: smite);
  }

  // Return the role positions of the champions
  return positions[0];
}

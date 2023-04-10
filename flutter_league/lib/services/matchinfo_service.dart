import 'dart:convert';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/utils/riotdata_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riot_api/utils/config.dart';

// Returns a Match object containing information about the specified match
Future<Match?> getMatchInfo(String matchId, [String? serverId]) async {
  String apiUrl =
      '${Config.apiUrlRegion}match/v5/matches/$matchId?api_key=${Config.apikey}'; // Send a GET request to the Riot API to fetch match data
  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(
        Config.currentRegion, getRegionFromServerId(serverId));
  }
  final matchResponse = await http.get(Uri.parse(apiUrl));

  if (matchResponse.statusCode == 200) {
    final matchData = jsonDecode(matchResponse.body);
    final summonerObjResponse = Match.fromJson(matchData["info"]);
    return summonerObjResponse;
  } else {
    // TODO: handle error
    return null;
  }
}

import 'dart:convert';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/utils/riotdata_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riot_api/utils/config.dart';

/// Returns a Match object containing information about the specified match
Future<Match?> getMatchInfo(String matchId, [String? serverId]) async {
  // Construct the API URL using the specified match ID and the API key
  String apiUrl =
      '${Config.apiUrlRegion}match/v5/matches/$matchId?api_key=${Config.apikey}';

  // If a server ID is specified, replace the current region in the API URL with the region corresponding to the server ID
  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(
        Config.currentRegion, getRegionFromServerId(serverId));
  }

  // Send a GET request to the Riot API to fetch match data
  final matchResponse = await http.get(Uri.parse(apiUrl));

  // If the API returns a successful response, decode the JSON response and create a Match object from the "info" field in the response
  if (matchResponse.statusCode == 200) {
    final matchData = jsonDecode(matchResponse.body);
    final summonerObjResponse = Match.fromJson(matchData["info"]);
    return summonerObjResponse;
  } else {
    // If the API returns an error, return null
    // TODO: handle error
    return null;
  }
}

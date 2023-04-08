import 'dart:convert';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riot_api/utils/config.dart';

// Returns a MatchPreview object containing information about the specified match
Future<MatchPreview?> getMatchPreview(String summonerName, String matchId,
    [String? serverId]) async {
  String apiUrl =
      '${Config.apiUrlRegion}match/v5/matches/$matchId?api_key=${Config.apikey}'; // Send a GET request to the Riot API to fetch match data

  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(
        Config.currentRegion, getRegionFromServerId(serverId));
  }
  final matchResponse = await http.get(Uri.parse(apiUrl));

  if (matchResponse.statusCode == 200) {
    // If the request was successful
    final matchData = jsonDecode(matchResponse.body);

    // Find the participant object for the specified summoner
    Map<String, dynamic> participant = matchData["info"]["participants"]
        .firstWhere((p) => p["summonerName"] == summonerName,
            orElse: () => null);

    // Parse the match data into a MatchPreview object
    final summonerObjResponse = MatchPreview.fromJson(
        matchData["info"], participant, matchData["metadata"]["matchId"]);
    return summonerObjResponse; // Return the MatchPreview object
  } else {
    // TODO: handle error
    return null;
  }
}

// Returns a list of match IDs for a given summoner PUUID
Future<List<String>> getMatchIds(String puuid, [String? serverId]) async {
  List<String> response = [];

  String apiUrl =
      '${Config.apiUrlRegion}match/v5/matches/by-puuid/$puuid/ids?start=0&count=100&api_key=${Config.apikey}';
  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(
        Config.currentRegion, getRegionFromServerId(serverId));
  }
  final matchIdResponse = await http.get(
    Uri.parse(
        apiUrl), // Send a GET request to the Riot API to fetch match IDs for the summoner
  );

  if (matchIdResponse.statusCode == 200) {
    // If the request was successful
    response = jsonDecode(matchIdResponse.body)
        .cast<String>(); // Parse the response into a list of strings
    return response; // Return the list of match IDs
  } else {
    // TODO: handle error
  }

  return response;
}

Future<LiveGame?> getLiveGame(String summonerId, [String? serverId]) async {
  final response;
  String apiUrl =
      '${Config.apiUrl}spectator/v4/active-games/by-summoner/$summonerId/?api_key=${Config.apikey}';
  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(Config.currentServer, serverId);
  }
  final liveGameResponse = await http.get(
    Uri.parse(
        apiUrl), // Send a GET request to the Riot API to fetch live game data for the summoner
  );

  if (liveGameResponse.statusCode == 200) {
    // If the request was successful
    response = jsonDecode(liveGameResponse.body);
    final liveGameObjresponse = LiveGame.fromJson(response);
    return liveGameObjresponse;
  } else {
    // TODO: handle error
  }
  return null;
}

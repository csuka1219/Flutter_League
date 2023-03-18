import 'dart:convert';
import 'package:flutter_riot_api/model/match.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riot_api/utils/constants.dart';

// Returns a Match object containing information about the specified match
Future<Match?> getMatchInfo(String matchId) async {
  final matchResponse = await http.get(
    Uri.parse(
        '${apiUrl2}match/v5/matches/$matchId?api_key=$apikey'), // Send a GET request to the Riot API to fetch match data
  );

  if (matchResponse.statusCode == 200) {
    final matchData = jsonDecode(matchResponse.body);
    final summonerObjResponse = Match.fromJson(matchData["info"]);
    return summonerObjResponse;
  } else {
    // TODO: handle error
    return null;
  }
}

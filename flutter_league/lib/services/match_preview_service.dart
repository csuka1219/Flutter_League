import 'dart:convert';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riot_api/utils/constants.dart';

Future<MatchPreview?> getMatchPreview(
    String summonerName, String matchId) async {
  final matchResponse = await http.get(
    //TODO server aztonosito külön
    Uri.parse('${apiUrl2}match/v5/matches/$matchId?api_key=$apikey'),
  );

  if (matchResponse.statusCode == 200) {
    final matchData = jsonDecode(matchResponse.body);
    Map<String, dynamic> participant = matchData["info"]["participants"]
        .firstWhere((p) => p["summonerName"] == summonerName,
            orElse: () => null);

    final summonerObjResponse = MatchPreview.fromJson(
        matchData["info"], participant, matchData["metadata"]["matchId"]);
    return summonerObjResponse;
  } else {
    // TODO: handle error
    return null;
  }
}

Future<List<String>> getMatchIds(
    //https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/3nAQ1XUk_evbC8AqTcH06blBip0dzrpFQVl-PRGP962RTdzfWkWWfApcwOy09C1U1R59kl-LoVI8rA/ids?start=0&count=100&api_key=RGAPI-90c0dff8-1e1b-43b7-b313-0d43d6bf19b1
    String puuid) async {
  List<String> response = [];
  final matchIdResponse = await http.get(
    //TODO server aztonosito külön
    Uri.parse(
        '${apiUrl2}match/v5/matches/by-puuid/$puuid/ids?start=0&count=100&api_key=$apikey'),
  );
  if (matchIdResponse.statusCode == 200) {
    response = jsonDecode(matchIdResponse.body).cast<String>();
    return response;
  } else {
    // TODO: handle error
  }
  return response;
}

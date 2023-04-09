import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/utils/config.dart';

// This function retrieves the Summoner object associated with the given Summoner Name.
// If a Summoner is found, it also retrieves the Summoner's ranked data, and merges
// the Summoner and Ranked data into a single JSON object. If a Summoner is not found,
// null is returned.
Future<Summoner?> getSummonerByName(String summonerName,
    [String? serverId]) async {
  String apiUrl =
      '${Config.apiUrl}summoner/v4/summoners/by-name/$summonerName?api_key=${Config.apikey}';
  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(Config.currentServer, serverId);
  }
  final summonerResponse = await http.get(Uri.parse(apiUrl));

  if (summonerResponse.statusCode == 200) {
    final summonerData = jsonDecode(summonerResponse.body);

    // Retrieve the Summoner's ranked data.
    final rankedData = await getRankedData(summonerData['id'], serverId);

    // If the Summoner has ranked data, merge the Summoner and Ranked data into a single JSON object.
    final jsonResult = (rankedData[0]['result'] != 'Unranked')
        ? mergeJson(summonerData, rankedData)
        : summonerData;

    // Create and return the Summoner object.
    final summonerObjResponse = Summoner.fromJson(jsonResult);
    return summonerObjResponse;
  } else {
    // TODO: handle error
    return null;
  }
}

// This function retrieves the Summoner object associated with the given Summoner Puuid.
// If a Summoner is found, it also retrieves the Summoner's ranked data, and merges
// the Summoner and Ranked data into a single JSON object. If a Summoner is not found,
// null is returned.
Future<Summoner?> getSummonerByPuuid(String puuid, [String? serverId]) async {
  String apiUrl =
      '${Config.apiUrl}summoner/v4/summoners/by-puuid/$puuid?api_key=${Config.apikey}';
  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(Config.currentServer, serverId);
  }
  final summonerResponse = await http.get(Uri.parse(apiUrl));

  if (summonerResponse.statusCode == 200) {
    final summonerData = jsonDecode(summonerResponse.body);

    // Retrieve the Summoner's ranked data.
    final rankedData = await getRankedData(summonerData['id'], serverId);

    // If the Summoner has ranked data, merge the Summoner and Ranked data into a single JSON object.
    final jsonResult = (rankedData[0]['result'] != 'Unranked')
        ? mergeJson(summonerData, rankedData)
        : summonerData;

    // Create and return the Summoner object.
    final summonerObjResponse = Summoner.fromJson(jsonResult);
    return summonerObjResponse;
  } else {
    // TODO: handle error
    return null;
  }
}

// This function retrieves the ranked data associated with the given Account ID.
// If ranked data is found, it is returned as a List<dynamic>. If ranked data is not
// found, a single JSON object with a 'result' key of 'Unranked' is returned.
Future<List<dynamic>> getRankedData(String accountId,
    [String? serverId]) async {
  String apiUrl =
      '${Config.apiUrl}league/v4/entries/by-summoner/$accountId?api_key=${Config.apikey}';
  if (serverId != null) {
    apiUrl = apiUrl.replaceFirst(Config.currentServer, serverId);
  }
  final rankedResponse = await http.get(Uri.parse(apiUrl));

  if (rankedResponse.statusCode == 200) {
    final rankedData = jsonDecode(rankedResponse.body);

    // If ranked data is found, return it as a List<dynamic>.
    if (rankedData.isNotEmpty) {
      return rankedData;
    }
  }

  // If ranked data is not found, return a single JSON object with a 'result' key of 'Unranked'.
  return [
    {'result': 'Unranked'}
  ];
}

// This function merges two JSON objects into a single JSON object.
// It is used to merge the Summoner and Ranked data into a single JSON object.
Map<String, dynamic> mergeJson(
    Map<String, dynamic> summonerData, List<dynamic> rankedData) {
  Map<String, dynamic> rankedInfo = {};
  if (rankedData.isNotEmpty) {
    for (var data in rankedData) {
      // Extract the ranked data from the list and add it to the rankedInfo Map.
      rankedInfo[data['queueType']] = {
        'tier': data['tier'],
        'rank': data['rank'],
        'leaguePoints': data['leaguePoints'],
        'wins': data['wins'],
        'losses': data['losses']
      };
    }
  }

  // Merge the Summoner and Ranked data into a single JSON object.
  Map<String, dynamic> mergedData = {...summonerData, ...rankedInfo};
  return mergedData;
}

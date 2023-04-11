import 'dart:convert';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

// declare a SharedPreferences object
late SharedPreferences _prefs;

/// load saved summoners from SharedPreferences
Future<List<SummonerServer>> loadSummoners() async {
  // initialize _prefs with an instance of SharedPreferences
  _prefs = await SharedPreferences.getInstance();

  // get the list of saved summoners from SharedPreferences as a list of JSON strings
  final jsonStringList = _prefs.getStringList('favourite_summoners');

  // if jsonStringList is not null, convert each JSON string to a SummonerServer object and add it to a list
  if (jsonStringList != null) {
    final summonerServers = jsonStringList
        .map((jsonString) => SummonerServer.fromJson(jsonDecode(jsonString)))
        .toList();
    return summonerServers;
  }

  // if jsonStringList is null, return an empty list
  return [];
}

/// save summoners to SharedPreferences
Future<void> saveSummoner(List<SummonerServer> summonerServers) async {
  // remove the previous list of saved summoners from SharedPreferences
  await _prefs.remove('favourite_summoners');

  // convert each SummonerServer object to a JSON string and add it to a list
  final jsonString = summonerServers
      .map((summonerServer) => jsonEncode(summonerServer.toJson()))
      .toList();

  // save the list of JSON strings to SharedPreferences
  await _prefs.setStringList('favourite_summoners', jsonString);
}

/// save the selected server ID to SharedPreferences
Future<void> saveServerId(String serverId) async {
  // remove the previous server ID from SharedPreferences
  await _prefs.remove('serverId');

  // save the new server ID to SharedPreferences
  await _prefs.setString('serverId', serverId);
}

/// get the selected server ID from SharedPreferences
Future<String?> getServerId() async {
  // initialize a new instance of SharedPreferences
  _prefs = await SharedPreferences.getInstance();

  // get the saved server ID from SharedPreferences
  String? serverId = _prefs.getString('serverId');

  // if serverId is null, return an empty string
  return serverId ?? "eun1";
}

/// delete a summoner's saved data from SharedPreferences
Future<void> deleteSummonerPref(String puuid) async {
  // load the list of saved summoners from SharedPreferences
  List<SummonerServer> summonerServers = await loadSummoners();

  // if the list of saved summoners is not empty, remove the summoner with the given puuid
  if (summonerServers.isNotEmpty) {
    summonerServers.removeWhere((element) => element.puuid == puuid);

    // save the updated list of summoners to SharedPreferences
    await saveSummoner(summonerServers);
  }
}

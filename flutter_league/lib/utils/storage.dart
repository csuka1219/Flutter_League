import 'dart:convert';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _prefs;
Future<List<SummonerServer>> loadSummoners() async {
  _prefs = await SharedPreferences.getInstance();
  final jsonStringList = _prefs.getStringList('favourite_summoners');
  if (jsonStringList != null) {
    final summonerServers = jsonStringList
        .map((jsonString) => SummonerServer.fromJson(jsonDecode(jsonString)))
        .toList();
    return summonerServers;
  }
  return [];
}

Future<void> saveSummoner(List<SummonerServer> summonerServers) async {
  await _prefs.remove('favourite_summoners');
  final jsonString = summonerServers
      .map((summonerServer) => jsonEncode(summonerServer.toJson()))
      .toList();
  await _prefs.setStringList('favourite_summoners', jsonString);
}

Future<void> saveServerId(String serverId) async {
  await _prefs.remove('serverId');
  await _prefs.setString('serverId', serverId);
}

Future<String?> getServerId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? serverId = prefs.getString('serverId');
  return serverId ?? "eun1";
}

Future<void> deleteSummonerPref(String puuid) async {
  List<SummonerServer> summonerServers = await loadSummoners();
  if (summonerServers.isNotEmpty) {
    summonerServers.removeWhere((element) => element.puuid == puuid);
    await saveSummoner(summonerServers);
  }
}

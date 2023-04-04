import 'dart:convert';

import 'package:flutter_riot_api/model/summoner.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _prefs;
Future<List<String>> loadSummoners() async {
  _prefs = await SharedPreferences.getInstance();
  List<String>? summonersNames = _prefs.getStringList('favourite_summoners');
  if (summonersNames != null) {
    return summonersNames;
  }
  return [];
}

Future<void> saveSummoner(List<String> summonersJson) async {
  await _prefs.remove('favourite_summoners');
  await _prefs.setStringList('favourite_summoners', summonersJson);
}

Future<void> deleteSummonerPref(String summonerName) async {
  List<String> summonersNames = await loadSummoners();
  if (summonersNames.isNotEmpty) {
    summonersNames.removeWhere((name) => name == summonerName);
    await _prefs.setStringList('favourite_summoners', summonersNames);
  }
}

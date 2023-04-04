import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/storage.dart';

class MatchHistoryAppBarIcon with ChangeNotifier {
  MatchHistoryAppBarIcon(initFavourite) {
    _isFavourite = initFavourite;
  }

  bool _isFavourite = true;

  bool get isFavourite => _isFavourite;

  set isFavourite(bool value) {
    _isFavourite = value;
    notifyListeners();
  }

  void saveSummoners(Summoner summoner) async {
    List<String> summonerNames = [];
    summonerNames = await loadSummoners();
    if (!summonerNames.any((s) => s == summoner.name)) {
      summonerNames.add(summoner.name);
    }
    saveSummoner(summonerNames);
  }

  void deleteSummoner(Summoner summoner) async {
    await deleteSummonerPref(summoner.name);
  }
}

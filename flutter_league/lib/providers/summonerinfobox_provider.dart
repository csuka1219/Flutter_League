import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class SummonerInfoData with ChangeNotifier {
  SummonerInfoData(Summoner kSummoner) {
    summoner = kSummoner;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late Summoner summoner;

  Future<void> updateSummoner() async {
    isLoading = true;
    Summoner? sum = await getSummonerByName(summoner.name);
    bool needUpdate = summoner.areSummonersEqual(sum);
    if (needUpdate) {
      summoner = sum!;
    }
    isLoading = false;
  }

  void deleteSummoner(Summoner summoner) async {
    await deleteSummonerPref(summoner.name);
  }
}

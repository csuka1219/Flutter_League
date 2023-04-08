import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class SummonerInfoData with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Summoner? summoner;

  Future<void> updateSummoner([String? serverId]) async {
    isLoading = true;
    Summoner? sum = await getSummonerByName(summoner!.name, serverId);
    bool needUpdate = summoner!.areSummonersEqual(sum);
    if (needUpdate) {
      summoner = sum!;
    }
    isLoading = false;
  }

  void deleteSummoner(Summoner summoner) async {
    await deleteSummonerPref(summoner.puuid);
  }

  void init(Summoner summoner) {
    this.summoner = summoner;
  }
}

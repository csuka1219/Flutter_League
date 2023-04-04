import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class HomePageData with ChangeNotifier {
  HomePageData() {
    int a = 0;
  }
  List<Summoner?> summoners = [];

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initSummoners() async {
    List<String> summonerNames = await loadSummoners();
    for (String summonerName in summonerNames) {
      summoners.add(await getSummonerByName(summonerName));
    }
    isLoading = false;
  }
}

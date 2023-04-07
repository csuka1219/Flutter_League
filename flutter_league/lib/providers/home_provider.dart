import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class HomeProvider with ChangeNotifier {
  List<Summoner?> summoners = [];

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void addSummoner(Summoner summoner) {
    summoners.add(summoner);
    notifyListeners();
  }

  void removeSummoner(Summoner summoner) {
    summoners.removeWhere(((element) => element!.id == summoner.id));
    notifyListeners();
  }

  Future<void> initSummoners() async {
    List<String> summonerNames = await loadSummoners();
    for (String summonerName in summonerNames) {
      summoners.add(await getSummonerByName(summonerName));
    }
    isLoading = false;
    notifyListeners();
  }

  bool _dropdownOpen = false;
  bool get dropdownOpen => _dropdownOpen;
  String _summomnerName = "";
  void onButtonPressed() {
    _dropdownOpen = !_dropdownOpen;
    notifyListeners();
  }

  void setFalse() {
    _dropdownOpen = false;
    notifyListeners();
  }

  String get summomnerName => _summomnerName;

  set summomnerName(String value) {
    _summomnerName = value;
    notifyListeners();
  }
}

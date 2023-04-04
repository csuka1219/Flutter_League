import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';

class LiveGameData with ChangeNotifier {
  final List<Summoner?> _summonerInfos = [];

  List<Summoner?> get summonerInfos => _summonerInfos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initDatas(List<Participant> participants) async {
    _isLoading = true;
    for (var item in participants) {
      _summonerInfos.add(await getSummonerByName(item.summonerName));
    }
    isLoading = false;
  }
}

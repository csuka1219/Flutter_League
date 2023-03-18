import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/matchinfo_service.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';

class MatchInfoData with ChangeNotifier {
  final List<Summoner?> _summonerInfos = [];
  Match? _matchInfo;

  List<Summoner?> get summonerInfos => _summonerInfos;

  Match? get matchInfo => _matchInfo;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initDatas(String matchId) async {
    _matchInfo = await getMatchInfo(matchId);
    _isLoading = true;
    for (var item in matchInfo!.participants) {
      _summonerInfos.add(await getSummonerByName(item.summonerName));
    }
    isLoading = false;
  }
}

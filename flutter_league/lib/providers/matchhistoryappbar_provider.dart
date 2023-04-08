import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/utils/config.dart';
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

  void saveSummoners(Summoner summoner, [String? serverId]) async {
    List<SummonerServer> summonerServers = [];
    summonerServers = await loadSummoners();
    if (!summonerServers.any((s) => s.puuid == summoner.puuid)) {
      summonerServers.add(SummonerServer(
          puuid: summoner.puuid, server: serverId ?? Config.currentServer));
    }
    saveSummoner(summonerServers);
  }

  void deleteSummoner(Summoner summoner) async {
    await deleteSummonerPref(summoner.puuid);
  }
}

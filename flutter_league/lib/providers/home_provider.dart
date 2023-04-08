import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/config.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class HomeProvider with ChangeNotifier {
  List<Summoner?> summoners = [];
  List<SummonerServer> summonerServers = [];

  String? getFavouriteSummonerServerId(String puuid) {
    for (var item in summonerServers) {
      if (item.puuid == puuid) {
        return item.server;
      }
    }
    return null;
  }

  void removeSummonerServer(String puuid) {
    summonerServers.removeWhere(
      ((element) => element.puuid == puuid),
    );
  }

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
    summonerServers = await loadSummoners();
    for (SummonerServer summonerServer in summonerServers) {
      summoners.add(await getSummonerByPuuid(
          summonerServer.puuid, summonerServer.server));
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

  String? _serverId;
  String? get serverId => _serverId;

  String? _serverName;
  String? get serverName => _serverName;

  set serverName(String? serverId) {
    _serverName = getServerName(serverId!);
    _serverId = serverId;
    notifyListeners();
  }

  Future<void> init() async {
    String? serverId = await getServerId();
    Config.currentServer = serverId ?? "eun1";
    serverName = serverId ?? "eun1";
  }
}

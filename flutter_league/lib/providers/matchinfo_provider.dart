import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/model/playerstats.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/matchinfo_service.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';

class MatchInfoData with ChangeNotifier {
  final List<Summoner?> _summonerInfos =
      []; // list of summoner information associated with the match
  Match? _matchInfo; // object containing match information

  List<PlayerStats> _playerStats = [];
  bool _isLoading = true;

  // getters and setters
  List<Summoner?> get summonerInfos => _summonerInfos;
  List<PlayerStats> get playerStats => _playerStats;
  Match? get matchInfo => _matchInfo;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// initializes the match data and summoner information associated with the match
  Future<void> initDatas(String matchId, [String? serverId]) async {
    _matchInfo =
        await getMatchInfo(matchId, serverId); // retrieve match information
    _playerStats = _matchInfo!.participants; // retrieve player statistics
    _isLoading = true;

    // retrieve summoner information for each participant in the match
    for (var item in matchInfo!.participants) {
      _summonerInfos.add(await getSummonerByPuuid(item.puuid, serverId));
    }

    isLoading =
        false; // set loading flag to false after all data has been loaded
  }
}

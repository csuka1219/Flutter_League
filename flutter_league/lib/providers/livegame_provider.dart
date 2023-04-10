import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';

class LiveGameData with ChangeNotifier {
  final List<Summoner?> _summonerInfos = [];

  List<Summoner?> get summonerInfos => _summonerInfos;

  // Boolean flag to indicate if the app is currently loading data.
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Method to initialize the summonerInfos list with data for each participant.
  Future<void> initDatas(List<Participant> participants,
      [String? serverId]) async {
    // Set the isLoading flag to true.
    _isLoading = true;
    // For each participant, get the corresponding summoner data and add it to the summonerInfos list.
    for (var item in participants) {
      _summonerInfos.add(await getSummonerByName(item.summonerName, serverId));
    }
    // Once all summoner data has been loaded, set the isLoading flag to false and notify any listeners.
    isLoading = false;
  }
}

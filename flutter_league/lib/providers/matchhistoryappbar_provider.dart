import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/utils/config.dart';
import '../utils/storage.dart';

class MatchHistoryAppBarIcon with ChangeNotifier {
  // Constructor that takes an initial favorite status.
  MatchHistoryAppBarIcon(initFavourite) {
    _isFavourite = initFavourite;
  }

  bool _isFavourite = true;

  bool get isFavourite => _isFavourite;

  set isFavourite(bool value) {
    _isFavourite = value; // Update the value.
    notifyListeners(); // Notify any listeners that the value has changed.
  }

  /// Method to save the summoner to the user's favorite list.
  void saveSummoners(Summoner summoner, [String? serverId]) async {
    List<SummonerServer> summonerServers = [];
    summonerServers =
        await loadSummoners(); // Load the existing list of favorite summoners.
    // If the summoner is not already in the list, add it.
    if (!summonerServers.any((s) => s.puuid == summoner.puuid)) {
      summonerServers.add(SummonerServer(
          puuid: summoner.puuid, server: serverId ?? Config.currentServer));
    }
    saveSummoner(
        summonerServers); // Save the updated list of favorite summoners.
  }

  /// Method to delete the summoner from the user's favorite list.
  void deleteSummoner(Summoner summoner) async {
    await deleteSummonerPref(
        summoner.puuid); // Delete the summoner from the list.
  }
}

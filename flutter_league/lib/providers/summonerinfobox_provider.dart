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

  /// Updates the summoner object with new data from the server.
  /// If serverId is specified, the data will be fetched from that server.
  /// Otherwise, the data will be fetched from the current server as defined in the Config class.
  Future<void> updateSummoner([String? serverId]) async {
    // Set the loading flag to true to indicate that the update is in progress.
    isLoading = true;
    // Fetch the summoner data from the server.
    Summoner? sum = await getSummonerByName(summoner!.name, serverId);
    // Determine if the fetched summoner data is different from the current summoner data.
    bool needUpdate = summoner!.areSummonersEqual(sum);
    // If the fetched summoner data is different, update the summoner object.
    if (needUpdate) {
      summoner = sum!;
    }
    // Set the loading flag to false to indicate that the update is complete.
    isLoading = false;
  }

  // Deletes the summoner data from the app's shared preferences.
  void deleteSummoner(Summoner summoner) async {
    await deleteSummonerPref(summoner.puuid);
  }

  // Initializes the SummonerInfoData object with a summoner object.
  void init(Summoner summoner) {
    this.summoner = summoner;
  }
}

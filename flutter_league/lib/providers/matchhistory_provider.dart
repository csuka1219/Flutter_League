import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/services/matchhistory_service.dart';

// This class represents the data for a user's match history.
class MatchHistoryData with ChangeNotifier {
  // The constructor takes a boolean argument indicating whether the match history
  // is for solo queue.
  MatchHistoryData(this._isSoloQueue);

  // A list of MatchPreview objects representing the user's match history.
  List<MatchPreview?> _matchHistory = [];
  List<MatchPreview?> get matchHistory => _matchHistory;

  // The index of the current match being viewed.
  int _matchNumber = 0;
  set matchNumber(int value) {
    _matchNumber = value;
  }

  // Indicates whether the data is currently being loaded.
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Indicates whether the data is being initially loaded.
  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;
  set isInitialLoading(bool value) {
    _isInitialLoading = value;
    notifyListeners();
  }

  // Indicates whether the match history is for solo queue.
  bool _isSoloQueue = false;
  bool get isSoloQueue => _isSoloQueue;
  set isSoloQueue(bool value) {
    _isSoloQueue = value;
    notifyListeners();
  }

  // Toggles whether the match history is for solo queue.
  void toggleSoloQueue() {
    _isSoloQueue = !_isSoloQueue;
    notifyListeners();
  }

  // Initializes whether the match history is for solo queue.
  void initializeSoloQueue(bool value) {
    _isSoloQueue = value;
  }

  // A list of match IDs for the user.
  List<String> _matches = [];
  List<String> get matches => _matches;

  // Fetches the match IDs for the user.
  Future<void> fetchMatchIds(String puuid, [String? serverId]) async {
    _matches = await getMatchIds(puuid, serverId);
  }

// Fetches the match data for the user.
  Future<void> fetchData(String puuid, String summonerName,
      [bool loadMore = false, bool loadNew = false, String? serverId]) async {
    if (loadMore) {
      isLoading = true;
    }
    if (loadNew) {
      // If loading new data, set isInitialLoading to true, fetch new match IDs, and clear existing match history.
      _isInitialLoading = true;
      await fetchMatchIds(puuid, serverId);
      _matchHistory.clear();
    }
    // Create an empty list to store the loaded match data.
    final List<MatchPreview?> loadedData = [];
    if (_matches.isEmpty) {
      // If there are no match IDs, set isInitialLoading to false and return.
      isInitialLoading = false;
      return;
    }
    // Load match previews for up to 10 matches or until the end of the match list.
    int i = _matchNumber;
    while (i < _matchNumber + 10 && i < _matches.length) {
      // Get the match preview for the current match ID and add it to the loadedData list.
      loadedData
          .add(await getMatchPreview(summonerName, _matches[i], serverId));
      i++;
    }
    // Update the match number and add the loaded data to the match history.
    _matchNumber = i;
    _matchHistory += loadedData;
    if (loadMore) {
      isLoading = false;
    } else {
      isInitialLoading = false;
    }
  }

  // Indicates whether the user is currently searching for a live game.
  bool _isSearchingLiveGame = false;
  bool get isSearchingLiveGame => _isSearchingLiveGame;
  set isSearchingLiveGame(bool value) {
    _isSearchingLiveGame = value;
    notifyListeners();
  }

  // Fetches the data for the user's live game.
  Future<LiveGame?> fetchLiveGameData(String summonerId,
      [String? serverId]) async {
    isSearchingLiveGame = true;
    LiveGame? response = await getLiveGame(summonerId, serverId);
    isSearchingLiveGame = false;
    return response;
  }
}

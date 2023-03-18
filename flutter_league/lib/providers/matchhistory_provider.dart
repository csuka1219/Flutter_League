import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/services/matchhistory_service.dart';

class MatchHistoryData with ChangeNotifier {
  MatchHistoryData(bool isSoloQueue) {
    _isSoloQueue = isSoloQueue;
  }

  List<MatchPreview?> _matchHistory = [];

  List<MatchPreview?> get matchHistory => _matchHistory;

  void cleanMatchHistory() {
    _matchHistory = [];
  }

  int _matchNumber = 0;

  int get matchNumber => _matchNumber;

  set matchNumber(int value) {
    _matchNumber = value;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isSoloQueue = false;

  bool get isSoloQueue => _isSoloQueue;

  set isSoloQueue(bool value) {
    _isSoloQueue = value;
    notifyListeners();
  }

  void deniesisSoloQueue() {
    _isSoloQueue = !_isSoloQueue;
    notifyListeners();
  }

  void initisSoloQueue(bool value) {
    _isSoloQueue = value;
  }

  List<String> matches = [];

  Future<void> fetchMatchIds(String puuid) async {
    matches = await getMatchIds(puuid);
  }

  Future<void> fetchData(String puuid, String summonerName,
      [bool loadMore = false, bool loadNew = false]) async {
    if (loadMore) {
      isLoading = true;
    }
    if (loadNew) {
      await fetchMatchIds(puuid);
      _matchHistory = [];
    }
    final List<MatchPreview?> loadedData = [];
    if (matches.isEmpty) return;
    for (int i = matchNumber; i < matchNumber + 10; i++) {
      if (i >= matches.length) {
        break;
      }
      loadedData.add(await getMatchPreview(summonerName, matches[i]));
    }
    matchNumber += 10;
    _matchHistory += loadedData;
    if (loadMore) {
      isLoading = false;
    } else {
      notifyListeners();
    }
  }
}

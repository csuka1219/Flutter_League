import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/services/match_preview_service.dart';
import 'package:http/http.dart' as http;

class MatchHistoryData with ChangeNotifier {
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

import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/config.dart';
import 'package:flutter_riot_api/utils/riotdata_formatter.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class HomeProvider with ChangeNotifier {
  // Lists to hold summoner and summoner server data.
  List<Summoner?> summoners = [];
  List<SummonerServer> summonerServers = [];

  /// Method to get the server ID for a given puuid.
  String? getFavouriteSummonerServerId(String puuid) {
    // Iterate through the summonerServers list.
    for (var item in summonerServers) {
      // If the current item's puuid matches the given puuid, return its server ID.
      if (item.puuid == puuid) {
        return item.server;
      }
    }
    // If no match is found, return null.
    return null;
  }

  /// Method to remove a summoner server from the summonerServers list.
  void removeSummonerServer(String puuid) {
    summonerServers.removeWhere(
      ((element) => element.puuid == puuid),
    );
  }

  // Boolean flag to indicate if the app is currently loading data.
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Method to add a summoner to the summoners list.
  void addSummoner(Summoner summoner) {
    summoners.add(summoner);
    notifyListeners();
  }

  /// Method to remove a summoner from the summoners list.
  void removeSummoner(Summoner summoner) {
    summoners.removeWhere(((element) => element!.id == summoner.id));
    notifyListeners();
  }

  /// Method to load summoners
  Future<void> initSummoners() async {
    // Load summoner server data from the storage.
    summonerServers = await loadSummoners();
    List<Summoner?> sums = [];
    // For each summoner server, get the corresponding summoner data.
    for (SummonerServer summonerServer in summonerServers) {
      sums.add(await getSummonerByPuuid(
          summonerServer.puuid, summonerServer.server));
    }
    summoners = sums;
    // Once all summoner data has been loaded, set the isLoading flag to false and notify any listeners.
    isLoading = false;
    notifyListeners();
  }

  // Boolean flag to indicate if the dropdown menu is open.
  bool _dropdownOpen = false;
  bool get dropdownOpen => _dropdownOpen;
  // String to hold the current summoner name.
  String _summomnerName = "";

  /// Method to toggle the dropdownOpen flag and notify any listeners.
  void onButtonPressed() {
    _dropdownOpen = !_dropdownOpen;
    notifyListeners();
  }

  /// Method to set the dropdownOpen flag to false and notify any listeners.
  void setFalse() {
    _dropdownOpen = false;
    notifyListeners();
  }

  // Getter and setter methods for the summomnerName field.
  String get summomnerName => _summomnerName;

  set summomnerName(String value) {
    _summomnerName = value;
    notifyListeners();
  }

  String? _serverId; // Variable to hold the server ID.
  String? get serverId => _serverId; // Getter method for the server ID.

  String? _serverName; // Variable to hold the server name.
  String? get serverName => _serverName; // Getter method for the server name.

  // Setter method for the server name.
  set serverName(String? serverId) {
    _serverName = getServerShortName(serverId!);
    _serverId = serverId;
    notifyListeners();
  }

  /// Async method to initialize the server ID and server name.
  Future<void> init() async {
    String? serverId =
        await getServerId(); // Get the server ID from the getServerId function.
    Config.currentServer = serverId ??
        "eun1"; // Set the current server in the Config class to the server ID.
    serverName = serverId ??
        "eun1"; // Set the server name to the short name of the server ID.
  }
}

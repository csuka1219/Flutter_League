import 'package:flutter_riot_api/utils/loldata_string.dart';

class Config {
  static String apikey = "RGAPI-ce8d4ca2-3941-4190-9583-947a612aec57";
  static String apiUrl = "https://$currentServer.api.riotgames.com/lol/";
  static String apiUrlRegion = "https://$currentRegion.api.riotgames.com/lol/";
  static String _currentServer = "eun1";
  static String _currentRegion = getRegionFromServerId(_currentServer);

  static String get currentServer => _currentServer;
  static String get currentRegion => _currentRegion;

  //americas, europe, asia, sea

  static set currentServer(String server) {
    _currentServer = server;
    _currentRegion = getRegionFromServerId(server);
    apiUrl = "https://$currentServer.api.riotgames.com/lol/";
    apiUrlRegion = "https://$currentRegion.api.riotgames.com/lol/";
  }
}

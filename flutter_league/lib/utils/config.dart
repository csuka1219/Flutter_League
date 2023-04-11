// Importing the required module
import 'package:flutter_riot_api/utils/riotdata_formatter.dart';

// Defining a Config class
class Config {
  // Static string variable to store the Riot Games API key
  static String apikey = "RGAPI-a08518b3-6007-40a0-b7e6-8a2d57a49e07";

  // Static string variable to store the base URL for API requests
  static String apiUrl = "https://$currentServer.api.riotgames.com/lol/";

  // Static string variable to store the base URL for API requests with the current region included
  static String apiUrlRegion = "https://$currentRegion.api.riotgames.com/lol/";

  // Static string variable to store the current server ID (default is "eun1")
  static String _currentServer = "eun1";

  // Static string variable to store the current region based on the current server ID (default is "euw")
  static String _currentRegion = getRegionFromServerId(_currentServer);

  // Getter method to retrieve the current server ID
  static String get currentServer => _currentServer;

  // Getter method to retrieve the current region based on the current server ID
  static String get currentRegion => _currentRegion;

  // Setter method to update the current server ID and corresponding region
  static set currentServer(String server) {
    // Update the server ID
    _currentServer = server;
    // Update the corresponding region based on the new server ID
    _currentRegion = getRegionFromServerId(server);
    // Update the base API URLs with the new server ID and region
    apiUrl = "https://$currentServer.api.riotgames.com/lol/";
    apiUrlRegion = "https://$currentRegion.api.riotgames.com/lol/";
  }
}

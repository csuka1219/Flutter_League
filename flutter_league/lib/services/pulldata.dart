import 'package:http/http.dart' as http;
import 'dart:convert';

/// Define a function to asynchronously pull champion playrates data from an API
Future<Map<String, Map<String, double>>> pullData() async {
  // Send a GET request to the specified URL
  final response = await http.get(Uri.parse(
      'http://cdn.merakianalytics.com/riot/lol/resources/latest/en-US/championrates.json'));

  // If the response is successful
  if (response.statusCode == 200) {
    // Decode the JSON response
    final playRatesData = jsonDecode(response.body);
    // Create an empty map to store the play rates for each champion and position
    final data = <String, Map<String, double>>{};

    // For each champion ID in the JSON response
    playRatesData["data"].forEach((championId, positions) {
      // Create an empty map to store the play rates for each position
      final playRates = <String, double>{};

      // For each position and its corresponding play rates in the JSON response
      positions.forEach((position, rates) {
        // Add the play rate for the position in uppercase to the map
        playRates[position.toUpperCase()] = rates["playRate"] + 0.0;
      });

      // For any positions that were not found in the JSON response
      for (final position in ["TOP", "JUNGLE", "MIDDLE", "BOTTOM", "UTILITY"]) {
        if (!playRates.containsKey(position)) {
          // Set their play rate to 0.0
          playRates[position] = 0.0;
        }
      }

      // Add the champion's play rates for each position to the map
      data[championId] = playRates;
    });

    // Return the completed map of play rates for each champion and position
    return data;
  } else {
    // If the response is not successful, throw an exception
    throw Exception('Failed to fetch data');
  }
}

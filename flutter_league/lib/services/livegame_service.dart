import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riot_api/utils/constants.dart';

// Future<MatchPreview?> getMatchPreview(
//     String summonerName, String matchId) async {
//   final matchResponse = await http.get(
//     Uri.parse(
//         '${apiUrl2}match/v5/matches/$matchId?api_key=$apikey'), // Send a GET request to the Riot API to fetch match data
//   );

//   if (matchResponse.statusCode == 200) {
//     // If the request was successful
//     final matchData = jsonDecode(matchResponse.body);

//     // Find the participant object for the specified summoner
//     Map<String, dynamic> participant = matchData["info"]["participants"]
//         .firstWhere((p) => p["summonerName"] == summonerName,
//             orElse: () => null);

//     // Parse the match data into a MatchPreview object
//     final summonerObjResponse = MatchPreview.fromJson(
//         matchData["info"], participant, matchData["metadata"]["matchId"]);
//     return summonerObjResponse; // Return the MatchPreview object
//   } else {
//     // TODO: handle error
//     return null;
//   }
// }
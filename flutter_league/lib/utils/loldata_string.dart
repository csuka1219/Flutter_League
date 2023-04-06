import 'package:flutter_riot_api/model/summoner.dart';

/// Returns a formatted string representing the winrate of the summoner in
/// either solo queue or flex queue.
///
/// If `isSoloQueue` is true, the method will calculate the winrate based on the
/// summoner's solo queue rank, otherwise it will calculate based on their flex
/// queue rank.
String getWinrate(bool isSoloQueue, Summoner summonerInfo) {
  // Calculate winrate based on the selected queue type
  double winrate = isSoloQueue
      ? summonerInfo.soloRank!.wins! /
          (summonerInfo.soloRank!.wins! + summonerInfo.soloRank!.losses!)
      : summonerInfo.flexRank!.wins! /
          (summonerInfo.flexRank!.wins! + summonerInfo.flexRank!.losses!);

  // Round the winrate to the nearest integer and convert it to a string
  String winrateString = (winrate * 100).round().toString();

  return winrateString;
}

String getKdaAvg(int k, int d, int a) {
  return ((k + a) / d).toStringAsFixed(2);
}

// Returns a formatted string for game duration
String getFormattedDuration(int gameDurationInSeconds) {
  // Convert game duration in seconds to minutes and round down
  int minutes = (gameDurationInSeconds / 60).floor();

  // Calculate remaining seconds and pad with leading zero if necessary
  int seconds = gameDurationInSeconds % 60;
  String formattedSeconds = seconds.toString().padLeft(2, '0');

  // Combine minutes and seconds into formatted string
  return "${minutes}m ${formattedSeconds}s";
}

// This function maps the queueId to the corresponding game mode name
String getGameModeByQueueId(int queueId) {
  final Map<int, String> gameModes = {
    0: 'Custom',
    400: 'Normal Draft Pick',
    420: 'Ranked Solo/Duo',
    430: 'Normal Blind Pick',
    440: 'Ranked Flex',
    450: 'ARAM',
    700: 'Clash',
    900: 'URF',
    1300: 'Nexus Blitz',
    1400: 'ARAM Snowdown',
    2000: 'TFT',
    2010: 'TFT Ranked',
  };

// Return the game mode name for the given queueId
  return gameModes[queueId]!;
}

String getLane(int index) {
  switch (index) {
    case 0:
      return "TOP";
    case 1:
      return "JUNGLE";
    case 2:
      return "MIDDLE";
    case 3:
      return "BOTTOM";
    case 4:
      return "UTILITY";
    default:
      return "TOP";
  }
}

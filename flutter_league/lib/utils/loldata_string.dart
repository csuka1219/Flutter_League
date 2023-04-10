import 'package:flutter_riot_api/model/playerstats.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/match.dart';

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

String getCsPerMinute(Match matchInfo, PlayerStats playerStat) {
  double gameDurationInMinutes = matchInfo.gameDuration / 60;
  double csPerMinute = playerStat.totalCS / gameDurationInMinutes;
  return csPerMinute.toStringAsFixed(1);
}

String getRank(Match matchInfo, Summoner summonerInfo) {
  if (matchInfo.queueId == 420) {
    return summonerInfo.soloRank != null
        ? "${summonerInfo.soloRank!.tier!} ${summonerInfo.soloRank!.rank!}"
        : "Level ${summonerInfo.summonerLevel}";
  } else if (matchInfo.queueId == 440) {
    return summonerInfo.flexRank != null
        ? "${summonerInfo.flexRank!.tier!} ${summonerInfo.flexRank!.rank!}"
        : "Level ${summonerInfo.summonerLevel}";
  }
  if (summonerInfo.soloRank != null) {
    return "${summonerInfo.soloRank!.tier!} ${summonerInfo.soloRank!.rank!}";
  } else if (summonerInfo.flexRank != null) {
    return "${summonerInfo.flexRank!.tier!} ${summonerInfo.flexRank!.rank!}";
  }
  return "Level ${summonerInfo.summonerLevel}";
}

String getRegionFromServerId(String serverId) {
  if (serverId.startsWith("na") ||
      serverId.startsWith("br") ||
      serverId.startsWith("lan") ||
      serverId.startsWith("las") ||
      serverId.startsWith("oce")) {
    return "Americas";
  } else if (serverId.startsWith("eun") ||
      serverId.startsWith("euw") ||
      serverId.startsWith("tr") ||
      serverId.startsWith("ru")) {
    return "Europe";
  } else if (serverId.startsWith("jp") || serverId.startsWith("kr")) {
    return "Asia";
  } else if (serverId.startsWith("th") ||
      serverId.startsWith("vn") ||
      serverId.startsWith("sg") ||
      serverId.startsWith("ph") ||
      serverId.startsWith("id")) {
    return "SEA";
  }
  return "Unknown";
}

String getServerName(String serverId) {
  return servers[serverId]!;
}

String getServerShortName(String serverId) {
  return serverShortNames[serverId]!;
}

final Map<String, String> servers = {
  "eun1": "Europe Nordic & East",
  "euw1": "Europe West",
  "jp1": "Japan",
  "br1": "Brazil",
  "kr": "Korea",
  "la1": "Latin America North",
  "la2": "Latin America South",
  "na1": "North America",
  "oc1": "Oceania",
  "ph2": "Philippines",
  "ru": "Russia",
  "sg2": "Singapore",
  "th2": "Thailand",
  "tr1": "Turkey",
  "tw2": "Taiwan",
  "vn2": "Vietnam",
};

Map<String, String> serverShortNames = {
  'br1': 'BR',
  'eun1': 'EUNE',
  'euw1': 'EUW',
  'jp1': 'JP',
  'kr': 'KR',
  'la1': 'LAN',
  'la2': 'LAS',
  'na1': 'NA',
  'oc1': 'OCE',
  'ph1': 'PH',
  'ru': 'RU',
  'sg': 'SG',
  'th': 'TH',
  'tr1': 'TR',
  'tw': 'TW',
  'vn': 'VN',
};

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

/// Returns a formatted string for game duration
String getFormattedDuration(int gameDurationInSeconds) {
  // Convert game duration in seconds to minutes and round down
  int minutes = (gameDurationInSeconds / 60).floor();

  // Calculate remaining seconds and pad with leading zero if necessary
  int seconds = gameDurationInSeconds % 60;
  String formattedSeconds = seconds.toString().padLeft(2, '0');

  // Combine minutes and seconds into formatted string
  return "${minutes}m ${formattedSeconds}s";
}

/// This function maps the queueId to the corresponding game mode name
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

/// This function takes in a Match object and a Summoner object, and returns a String representation of the summoner's rank
String getRank(Match matchInfo, Summoner summonerInfo) {
  // If the match is a ranked solo queue game
  if (matchInfo.queueId == 420) {
    // If the summoner has a solo rank, return the tier and rank
    // If not, return the summoner's level
    return summonerInfo.soloRank != null
        ? "${summonerInfo.soloRank!.tier!} ${summonerInfo.soloRank!.rank!}"
        : "Level ${summonerInfo.summonerLevel}";
    // If the match is a ranked flex queue game
  } else if (matchInfo.queueId == 440) {
    // If the summoner has a flex rank, return the tier and rank
    // If not, return the summoner's level
    return summonerInfo.flexRank != null
        ? "${summonerInfo.flexRank!.tier!} ${summonerInfo.flexRank!.rank!}"
        : "Level ${summonerInfo.summonerLevel}";
  }
  // If the match is not a ranked game, or the summoner has no ranked information,
  // return the summoner's highest available rank (solo or flex), or their level if they have no rank information
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
  return serverId == "" ? "" : servers[serverId]!;
}

String getServerShortName(String serverId) {
  return serverId == "" ? "" : serverShortNames[serverId]!;
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
  'ph2': 'PH',
  'ru': 'RU',
  'sg': 'SG',
  'th': 'TH',
  'tr1': 'TR',
  'tw': 'TW',
  'vn': 'VN',
};

String getChampionNameById(int id) {
  switch (id) {
    case 266:
      return "Aatrox";
    case 103:
      return "Ahri";
    case 84:
      return "Akali";
    case 166:
      return "Akshan";
    case 12:
      return "Alistar";
    case 32:
      return "Amumu";
    case 34:
      return "Anivia";
    case 1:
      return "Annie";
    case 523:
      return "Aphelios";
    case 22:
      return "Ashe";
    case 136:
      return "AurelionSol";
    case 268:
      return "Azir";
    case 432:
      return "Bard";
    case 200:
      return "Bel'Veth";
    case 53:
      return "Blitzcrank";
    case 63:
      return "Brand";
    case 201:
      return "Braum";
    case 51:
      return "Caitlyn";
    case 164:
      return "Camille";
    case 69:
      return "Cassiopeia";
    case 31:
      return "Chogath";
    case 42:
      return "Corki";
    case 122:
      return "Darius";
    case 131:
      return "Diana";
    case 119:
      return "Draven";
    case 36:
      return "DrMundo";
    case 245:
      return "Ekko";
    case 60:
      return "Elise";
    case 28:
      return "Evelynn";
    case 81:
      return "Ezreal";
    case 9:
      return "Fiddlesticks";
    case 114:
      return "Fiora";
    case 105:
      return "Fizz";
    case 3:
      return "Galio";
    case 41:
      return "Gangplank";
    case 86:
      return "Garen";
    case 150:
      return "Gnar";
    case 79:
      return "Gragas";
    case 104:
      return "Graves";
    case 887:
      return "Gwen";
    case 120:
      return "Hecarim";
    case 74:
      return "Heimerdinger";
    case 420:
      return "Illaoi";
    case 39:
      return "Irelia";
    case 427:
      return "Ivern";
    case 40:
      return "Janna";
    case 59:
      return "JarvanIV";
    case 24:
      return "Jax";
    case 126:
      return "Jayce";
    case 202:
      return "Jhin";
    case 222:
      return "Jinx";
    case 145:
      return "Kai'Sa";
    case 429:
      return "Kalista";
    case 43:
      return "Karma";
    case 30:
      return "Karthus";
    case 38:
      return "Kassadin";
    case 55:
      return "Katarina";
    case 10:
      return "Kayle";
    case 141:
      return "Kayn";
    case 85:
      return "Kennen";
    case 121:
      return "Khazix";
    case 203:
      return "Kindred";
    case 240:
      return "Kled";
    case 96:
      return "Kog'Maw";
    case 897:
      return "KSante";
    case 7:
      return "Leblanc";
    case 64:
      return "Lee Sin";
    case 89:
      return "Leona";
    case 876:
      return "Lillia";
    case 127:
      return "Lissandra";
    case 236:
      return "Lucian";
    case 117:
      return "Lulu";
    case 99:
      return "Lux";
    case 54:
      return "Malphite";
    case 90:
      return "Malzahar";
    case 57:
      return "Maokai";
    case 11:
      return "MasterYi";
    case 21:
      return "Miss Fortune";
    case 62:
      return "Wukong";
    case 82:
      return "Mordekaiser";
    case 25:
      return "Morgana";
    case 267:
      return "Nami";
    case 75:
      return "Nasus";
    case 111:
      return "Nautilus";
    case 518:
      return "Neeko";
    case 76:
      return "Nidalee";
    case 895:
      return "Nilah";
    case 56:
      return "Nocturne";
    case 20:
      return "Nunu";
    case 2:
      return "Olaf";
    case 61:
      return "Orianna";
    case 516:
      return "Ornn";
    case 80:
      return "Pantheon";
    case 78:
      return "Poppy";
    case 555:
      return "Pyke";
    case 246:
      return "Qiyana";
    case 133:
      return "Quinn";
    case 497:
      return "Rakan";
    case 33:
      return "Rammus";
    case 421:
      return "Rek'Sai";
    case 526:
      return "Rell";
    case 888:
      return "Renata Glasc";
    case 58:
      return "Renekton";
    case 107:
      return "Rengar";
    case 92:
      return "Riven";
    case 68:
      return "Rumble";
    case 13:
      return "Ryze";
    case 360:
      return "Samira";
    case 113:
      return "Sejuani";
    case 235:
      return "Senna";
    case 147:
      return "Seraphine";
    case 875:
      return "Sett";
    case 35:
      return "Shaco";
    case 98:
      return "Shen";
    case 102:
      return "Shyvana";
    case 27:
      return "Singed";
    case 14:
      return "Sion";
    case 15:
      return "Sivir";
    case 72:
      return "Skarner";
    case 37:
      return "Sona";
    case 16:
      return "Soraka";
    case 50:
      return "Swain";
    case 517:
      return "Sylas";
    case 134:
      return "Syndra";
    case 223:
      return "Tahm Kench";
    case 163:
      return "Taliyah";
    case 91:
      return "Talon";
    case 44:
      return "Taric";
    case 17:
      return "Teemo";
    case 412:
      return "Thresh";
    case 18:
      return "Tristana";
    case 48:
      return "Trundle";
    case 23:
      return "Tryndamere";
    case 4:
      return "Twisted Fate";
    case 29:
      return "Twitch";
    case 77:
      return "Udyr";
    case 6:
      return "Urgot";
    case 110:
      return "Varus";
    case 67:
      return "Vayne";
    case 45:
      return "Veigar";
    case 161:
      return "Vel'Koz";
    case 711:
      return "Vex";
    case 254:
      return "Vi";
    case 234:
      return "Viego";
    case 112:
      return "Viktor";
    case 8:
      return "Vladimir";
    case 106:
      return "Volibear";
    case 19:
      return "Warwick";
    case 498:
      return "Xayah";
    case 101:
      return "Xerath";
    case 5:
      return "Xin Zhao";
    case 157:
      return "Yasuo";
    case 777:
      return "Yone";
    case 83:
      return "Yorick";
    case 350:
      return "Yuumi";
    case 154:
      return "Zac";
    case 238:
      return "Zed";
    case 221:
      return "Zeri";
    case 115:
      return "Ziggs";
    case 26:
      return "Zilean";
    case 142:
      return "Zoe";
    case 143:
      return "Zyra";
    case 902:
      return "Milio";
    default:
      return "Unknown Champion";
  }
}

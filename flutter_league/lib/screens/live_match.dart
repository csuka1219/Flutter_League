import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/providers/livegame_provider.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/utils/getchampionname.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:provider/provider.dart';

import '../utils/storage.dart';

class LiveGamePage extends StatelessWidget {
  final LiveGame liveGameData;
  final String? serverId;
  const LiveGamePage({super.key, required this.liveGameData, this.serverId});

  @override
  Widget build(BuildContext context) {
    bool isSoloQueue = liveGameData.gameModeId == 420;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorPalette().secondary),
        backgroundColor: ColorPalette().primary,
        title: Text(
          'Live Game',
          style: TextStyle(color: ColorPalette().secondary),
        ),
      ),
      body: ChangeNotifierProvider(
        // Provide the MatchHistoryData to the widget tree
        create: (_) => LiveGameData(),
        child: Consumer<LiveGameData>(
          // Consume the MatchHistoryData from the widget tree
          builder: (context, liveGameSummoners, child) {
            if (liveGameSummoners.summonerInfos.isEmpty) {
              // If the match history is empty, fetch data and show loading indicator
              liveGameSummoners.initDatas(liveGameData.participants, serverId);
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Text(
                            getGameModeByQueueId(liveGameData.gameModeId),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        height: 20,
                        child: VerticalDivider(
                          color: Colors.black,
                        )),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 2.0),
                              child: Text(
                                getFormattedDuration(liveGameData.gameLength),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Icon(Icons.schedule, size: 14.0),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 10,
                  child: Container(color: Color.fromARGB(255, 238, 238, 238)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Text(
                            'BLUE TEAM',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'RED TEAM',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                for (int i = 0; i < 5; i++)
                  playerCard(
                      context,
                      liveGameSummoners.summonerInfos[i]!,
                      liveGameSummoners.summonerInfos[i + 5]!,
                      liveGameData.participants[i],
                      liveGameData.participants[i + 5],
                      isSoloQueue,
                      getLane(i)),
                SizedBox(
                  height: 40,
                  child: Container(color: Color.fromARGB(255, 238, 238, 238)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Row playerCard(
      BuildContext context,
      Summoner blueSummonerInfo,
      Summoner redSummonerInfo,
      Participant bluePlayerMatchInfo,
      Participant redPlayerMatchInfo,
      bool isSoloQueue,
      String lane) {
    bool isUnrankedBlue = isUnranked(isSoloQueue, blueSummonerInfo);
    bool isUnrankedRed = isUnranked(isSoloQueue, redSummonerInfo);
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          //TODO
                          image: AssetImage(
                              "assets/champions/${getChampionNameById(bluePlayerMatchInfo.championId)}.png"),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(bluePlayerMatchInfo.spell1Id),
                              SizedBox(
                                height: 2.5,
                              ),
                              _buildRune(bluePlayerMatchInfo.perkStyle)
                            ],
                          ),
                          SizedBox(
                            width: 2.5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(bluePlayerMatchInfo.spell2Id),
                              SizedBox(
                                height: 2.5,
                              ),
                              _buildRune(bluePlayerMatchInfo.perkSubStyle)
                            ],
                          ),
                          SizedBox(
                            width: 8.5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isUnrankedBlue
                                  ? Text(
                                      "0 Games",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600]),
                                    )
                                  : _buildGamesPlayedText(
                                      blueSummonerInfo, isSoloQueue),
                              //TODO
                              Text(
                                  isUnrankedBlue
                                      ? "-"
                                      : "${getWinrate(isSoloQueue, blueSummonerInfo)}%",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),

                              isUnrankedBlue
                                  ? Text(
                                      "Unranked",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600]),
                                    )
                                  : _buildRankText(
                                      blueSummonerInfo, isSoloQueue)
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          //TODO
                          image: AssetImage("assets/roles/$lane.png"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              isUnrankedRed
                                  ? Text(
                                      "0 Games",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600]),
                                    )
                                  : _buildGamesPlayedText(
                                      redSummonerInfo, isSoloQueue),
                              Text(
                                  isUnrankedRed
                                      ? "-"
                                      : "${getWinrate(isSoloQueue, redSummonerInfo)}%",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              isUnrankedRed
                                  ? Text(
                                      "Unranked",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600]),
                                    )
                                  : _buildRankText(redSummonerInfo, isSoloQueue)
                            ],
                          ),
                          SizedBox(
                            width: 8.5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(redPlayerMatchInfo.spell1Id),
                              _buildRune(redPlayerMatchInfo.perkStyle)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(redPlayerMatchInfo.spell2Id),
                              _buildRune(redPlayerMatchInfo.perkSubStyle)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          //TODO
                          image: AssetImage(
                              "assets/champions/${getChampionNameById(redPlayerMatchInfo.championId)}.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: GestureDetector(
                              onTap: () async {
                                List<SummonerServer> summonerServers =
                                    await loadSummoners();
                                bool isFavourite = false;
                                if (summonerServers.any(
                                    (s) => s.puuid == blueSummonerInfo.puuid)) {
                                  isFavourite = true;
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MatchHistoryPage(
                                      summonerInfo: blueSummonerInfo,
                                      isFavourite: isFavourite,
                                      serverId: serverId,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  isUnrankedBlue
                                      ? Container()
                                      : Container(
                                          width: 22.0,
                                          height: 22.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/ranks/${isSoloQueue ? blueSummonerInfo.soloRank!.tier : blueSummonerInfo.flexRank!.tier}.png"),
                                            ),
                                          ),
                                        ),
                                  Text(
                                    blueSummonerInfo.name.length < 20
                                        ? blueSummonerInfo.name
                                        : '${blueSummonerInfo.name.substring(0, 20)}...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'VS',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: GestureDetector(
                              onTap: () async {
                                List<SummonerServer> summonerServers =
                                    await loadSummoners();
                                bool isFavourite = false;
                                if (summonerServers.any(
                                    (s) => s.puuid == redSummonerInfo.puuid)) {
                                  isFavourite = true;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MatchHistoryPage(
                                      summonerInfo: redSummonerInfo,
                                      isFavourite: isFavourite,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    redSummonerInfo.name.length < 20
                                        ? redSummonerInfo.name
                                        : '${redSummonerInfo.name.substring(0, 20)}...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  isUnrankedRed
                                      ? Container()
                                      : Container(
                                          width: 22.0,
                                          height: 22.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/ranks/${isSoloQueue ? redSummonerInfo.soloRank!.tier : redSummonerInfo.flexRank!.tier}.png"),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isUnranked(bool isSoloQueue, Summoner redSummonerInfo) {
    return (isSoloQueue && redSummonerInfo.soloRank == null) ||
        (!isSoloQueue && redSummonerInfo.flexRank == null);
  }

  Text _buildRankText(Summoner summonerInfo, bool isSoloQueue) {
    final tier = isSoloQueue
        ? summonerInfo.soloRank!.tier!
        : summonerInfo.flexRank!.tier!;
    final rank = isSoloQueue
        ? summonerInfo.soloRank!.rank!
        : summonerInfo.flexRank!.rank!;
    return Text(
      "$tier $rank",
      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
    );
  }

  Text _buildGamesPlayedText(Summoner summonerInfo, bool isSoloQueue) {
    final wins = isSoloQueue
        ? summonerInfo.soloRank!.wins!
        : summonerInfo.flexRank!.wins!;
    final losses = isSoloQueue
        ? summonerInfo.soloRank!.losses!
        : summonerInfo.flexRank!.losses!;
    return Text(
      "${(wins + losses)} Games",
      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
    );
  }
}

Container _buildSummonerSpell(int spellId) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: DecorationImage(
        image: AssetImage("assets/spells/$spellId.png"),
      ),
    ),
  );
}

Container _buildRune(int runeId) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: ColorPalette().primary,
      image: DecorationImage(
        image: AssetImage("assets/runes/$runeId.png"),
      ),
    ),
  );
}

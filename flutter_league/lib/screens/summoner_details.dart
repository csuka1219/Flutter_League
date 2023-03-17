import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/screens/match_info.dart';
import 'package:provider/provider.dart';

import '../providers/matchhistory_provider.dart';

class SummonerDetailsPage extends StatelessWidget {
  final Summoner summonerInfo;

  const SummonerDetailsPage({super.key, required this.summonerInfo});

  @override
  Widget build(BuildContext context) {
    bool startSoloQueue = summonerInfo.soloRank != null ||
        (summonerInfo.soloRank == null && summonerInfo.flexRank == null);
    return Scaffold(
      appBar: _buildAppBar(),
      body: ChangeNotifierProvider(
        create: (_) => MatchHistoryData(startSoloQueue),
        child: Consumer<MatchHistoryData>(
          builder: (context, matchHistoryData, child) {
            return Column(
              children: [
                // Header section
                ((context.read<MatchHistoryData>().isSoloQueue &&
                            summonerInfo.soloRank == null) ||
                        (!context.read<MatchHistoryData>().isSoloQueue &&
                            summonerInfo.flexRank == null))
                    ? _buildUnrankedSummonerHeader(context)
                    : _buildSummonerHeader(context),

                SizedBox(
                  height: 10,
                ),
                // Match history section
                Expanded(
                  child: Consumer<MatchHistoryData>(
                    builder: (context, matchHistoryData, child) {
                      if (matchHistoryData.matchHistory.isEmpty) {
                        matchHistoryData.matchNumber = 0;
                        matchHistoryData.fetchData(
                            summonerInfo.puuid,
                            summonerInfo.name,
                            false,
                            true); // Call the fetch method to load data
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh: () async {
                            if (!context.read<MatchHistoryData>().isLoading) {
                              matchHistoryData.isLoading = true;
                              matchHistoryData.matchNumber = 0;
                              matchHistoryData.fetchData(summonerInfo.puuid,
                                  summonerInfo.name, false, true);
                              matchHistoryData.isLoading = false;
                            }
                          },
                          child: ListView.builder(
                            itemCount: matchHistoryData.matchHistory.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              return index !=
                                      matchHistoryData.matchHistory.length
                                  ? _buildMatchListItem(context,
                                      matchHistoryData.matchHistory[index]!)
                                  : _buildLoadMoreButton(
                                      context, matchHistoryData);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: ColorPalette().secondary, //change your color here
      ),
      backgroundColor: ColorPalette().primary,
      title: Text(
        summonerInfo.name,
        style: TextStyle(color: ColorPalette().secondary),
      ),
    );
  }

  //TODO soloq után egy lenyíló hogy lehessen váltani flexre
  Widget _buildSummonerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Rank icon
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/ranks/${context.watch<MatchHistoryData>().isSoloQueue ? summonerInfo.soloRank?.tier : summonerInfo.flexRank?.tier}.png"),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rank name
                  Text(
                    context.watch<MatchHistoryData>().isSoloQueue
                        ? "${summonerInfo.soloRank?.tier} ${summonerInfo.soloRank?.rank}"
                        : "${summonerInfo.flexRank?.tier} ${summonerInfo.flexRank?.rank}",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // LP and winrate
                  Text(
                    //todo különszedni winrate alapján más színű text
                    "${context.watch<MatchHistoryData>().isSoloQueue ? summonerInfo.soloRank?.leaguePoints : summonerInfo.flexRank?.leaguePoints} LP,  ${getWinrate(context.watch<MatchHistoryData>().isSoloQueue)}% WR",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Solo/Duo or Flex
          GestureDetector(
            onTap: () {
              context.read<MatchHistoryData>().deniesisSoloQueue();
            },
            child: Text(
              context.watch<MatchHistoryData>().isSoloQueue
                  ? 'Solo/Duo'
                  : 'Flex',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Refresh and graph buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  //TODO live game
                  backgroundColor: !true ? Colors.grey[600] : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                ),
                child: Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnrankedSummonerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Rank icon
              Container(
                width: 32.0,
                height: 32.0,
                color: Colors.grey[200],
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rank name
                  Text(
                    "Unranked",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Solo/Duo or Flex
          GestureDetector(
            onTap: () {
              context.read<MatchHistoryData>().deniesisSoloQueue();
            },
            child: Text(
              context.watch<MatchHistoryData>().isSoloQueue
                  ? 'Solo/Duo'
                  : 'Flex',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Refresh and graph buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  //TODO live game
                  backgroundColor: !true ? Colors.grey[600] : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                ),
                child: Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchListItem(BuildContext context, MatchPreview matchHistory) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchInfoPage()),
        )
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: matchHistory.playerStats.win == true
                ? Color.fromARGB(255, 190, 226, 255)
                : Color.fromARGB(255, 255, 116, 116),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Champion icon
              Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/champions/${matchHistory.playerStats.championName}.png",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  // Summoner spells
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/spells/${matchHistory.playerStats.summoner1Id}.png",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/spells/${matchHistory.playerStats.summoner2Id}.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game mode and match length
                  Row(
                    children: [
                      Text(
                        "${getGameModeByQueueId(matchHistory.queueId)}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " - ${getFormattedDuration(matchHistory.gameDuration)}",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.schedule, color: Colors.grey[600], size: 14.0),
                    ],
                  ),
                  SizedBox(height: 8),
                  // KDA
                  Row(
                    children: [
                      matchHistory.playerStats.role.isNotEmpty
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/roles/${matchHistory.playerStats.role}.png"),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                          width:
                              matchHistory.playerStats.role.isNotEmpty ? 4 : 0),
                      Text(
                        "${matchHistory.playerStats.kills} / ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${matchHistory.playerStats.deaths}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 198, 24, 65),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " / ${matchHistory.playerStats.assists}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Text(
                      //   getKdaAvg(
                      //           matchHistory.playerStats.kills,
                      //           matchHistory.playerStats.deaths,
                      //           matchHistory.playerStats.assists) +
                      //       " KDA",
                      //   style: TextStyle(
                      //     color: Color.fromARGB(255, 94, 94, 94),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      Text(
                        "${matchHistory.playerStats.totalCS}" + " CS",
                        style: TextStyle(
                          color: Color.fromARGB(255, 94, 94, 94),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Match items
                  Row(
                    children: [
                      for (var i = 0;
                          i < matchHistory.playerStats.items.length - 1;
                          i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: matchHistory.playerStats.items[i] != 0
                              ? Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/items/${matchHistory.playerStats.items[i]}.png"),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorPalette().primary),
                                ),
                        ),
                      Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: matchHistory.playerStats.item6 != 0
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/items/${matchHistory.playerStats.item6}.png"),
                                ),
                              )
                            : const BoxDecoration(),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              // Rune pages
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette().primary,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/runes/${matchHistory.perks.primaryStyle}.png",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/runes/${matchHistory.perks.secondaryStyle}.png",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(
      BuildContext context, MatchHistoryData matchHistoryData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: context.watch<MatchHistoryData>().isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  matchHistoryData.fetchData(
                      summonerInfo.puuid, summonerInfo.name, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette().primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                ),
                child: Text(
                  'Load More',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }

  String getWinrate(bool isSoloQueue) {
    return isSoloQueue
        ? ((summonerInfo.soloRank!.wins! /
                    (summonerInfo.soloRank!.wins! +
                        summonerInfo.soloRank!.losses!)) *
                100)
            .round()
            .toString()
        : ((summonerInfo.flexRank!.wins! /
                    (summonerInfo.flexRank!.wins! +
                        summonerInfo.flexRank!.losses!)) *
                100)
            .round()
            .toString();
  }

  String getKdaAvg(int k, int d, int a) {
    return ((k + a) / d).toStringAsFixed(2);
  }

  String getFormattedDuration(int gameDurationInSeconds) {
    return "${(gameDurationInSeconds / 60).floor()}m ${(gameDurationInSeconds % 60).toString().padLeft(2, '0')}s";
  }

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
    return gameModes[queueId]!;
  }
}

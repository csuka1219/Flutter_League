import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/model/playerstats.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/team_header.dart';
import 'package:flutter_riot_api/providers/matchinfo_provider.dart';
import 'package:flutter_riot_api/screens/match_details.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MatchInfoPage extends StatelessWidget {
  final String summonerName;
  final bool isWin;
  final String matchId;
  const MatchInfoPage({
    Key? key,
    required this.summonerName,
    required this.isWin,
    required this.matchId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: isWin ? Colors.green[400] : Colors.red[400]),
          //backgroundColor: Colors.green[400],
          backgroundColor: ColorPalette().primary,
          title: Text(
            "Match Info",
            style:
                TextStyle(color: isWin ? Colors.green[400] : Colors.red[400]),
          ),
          actions: [
            IconButton(
              color: ColorPalette().secondary,
              icon: Icon(
                Icons.bar_chart,
                color: isWin ? Colors.green[400] : Colors.red[400],
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MatchDetailsPage()),
                ),
              },
            ),
          ],
        ),
        body: ChangeNotifierProvider(
          create: (_) => MatchInfoData(),
          child: Consumer<MatchInfoData>(
            builder: (context, matchInfoData, child) {
              if (matchInfoData.isLoading) {
                matchInfoData.initDatas(matchId);
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      color: ColorPalette().primary,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            isWin ? "Victory" : "Defeat",
                            style: TextStyle(
                              color:
                                  isWin ? Colors.green[400] : Colors.red[400],
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          //TODO ezeket kiszervezni
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${getGameModeByQueueId(matchInfoData.matchInfo!.queueId)} - ${getFormattedDuration(matchInfoData.matchInfo!.gameDuration)}",
                                style: TextStyle(
                                  color: isWin
                                      ? Colors.green[400]
                                      : Colors.red[400],
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(Icons.schedule,
                                  color: isWin
                                      ? Colors.green[400]
                                      : Colors.red[400],
                                  size: 16.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //SizedBox(height: 16.0),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(
                            color: Colors.blue,
                            thickness: 1.0,
                          ),
                          _buildTeamHeader(
                              matchInfoData.matchInfo!,
                              "WINNER ${matchInfoData.matchInfo!.participants[0].win ? '(BLUE)' : '(RED)'}",
                              true),
                          SizedBox(height: 10),
                          _buildPlayerList(matchInfoData.matchInfo!,
                              matchInfoData.summonerInfos, true),
                          SizedBox(height: 20),
                          Divider(
                            color: Colors.red,
                            thickness: 1,
                          ),
                          _buildTeamHeader(
                              matchInfoData.matchInfo!,
                              "LOSER ${matchInfoData.matchInfo!.participants[0].win ? '(RED)' : '(BLUE)'}",
                              false),
                          SizedBox(height: 10),
                          _buildPlayerList(matchInfoData.matchInfo!,
                              matchInfoData.summonerInfos, false),
                          SizedBox(height: 32.0),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildPlayerList(
      Match matchInfo, List<Summoner?> summonerInfos, bool isWinner) {
    double lineWidth = 0;
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
          thickness: 1.0,
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        List<PlayerStats> tempList = isWinner
            ? matchInfo.participants.sublist(0, 5)
            : matchInfo.participants.sublist(5);
        PlayerStats playerStat = tempList[index];
        (playerStat.summonerName == summonerName)
            ? lineWidth = 3
            : lineWidth = 0;

        List<Summoner?> tempSummonerList =
            isWinner ? summonerInfos.sublist(0, 5) : summonerInfos.sublist(5);

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchHistoryPage(
                summonerInfo: tempSummonerList[index]!,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            margin: EdgeInsets.only(bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue,
                      width: lineWidth,
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/champions/${playerStat.championName}.png"),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${playerStat.summonerName.length < 15 ? playerStat.summonerName : playerStat.summonerName.substring(0, 10) + '...'}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Row(
                            children: [
                              RankIcon(
                                summonerInfo: tempSummonerList[index]!,
                                queueId: matchInfo.queueId,
                              ),
                              SizedBox(width: 2),
                              Text(
                                //TODO
                                getRank(matchInfo, tempSummonerList[index]!),
                                style: TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/spells/${playerStat.summoner1Id}.png"),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.5),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/spells/${playerStat.summoner2Id}.png"),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.5),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette().primary,
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/runes/${playerStat.perks.primaryStyle}.png"),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.5),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/runes/${playerStat.perks.secondaryStyle}.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${playerStat.totalCS} CS(${getCsPerMinute(matchInfo, playerStat)})",
                          style: TextStyle(fontSize: 9),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${playerStat.kills} / ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${playerStat.deaths}",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " / ${playerStat.assists}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int item in playerStat.items.sublist(0, 6))
                          _buildItemsRow(item),
                        Container(
                          width: 18.0,
                          height: 18.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/items/${playerStat.item6}.png"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamHeader(Match matchInfo, String teamName, bool isWinnerTeam) {
    late TeamHeader teamHeader;
    if (isWinnerTeam) {
      teamHeader = TeamHeader(
          matchInfo.participants.sublist(0, matchInfo.participants.length ~/ 2),
          matchInfo.teams[0]);
    } else {
      teamHeader = TeamHeader(
          matchInfo.participants.sublist(matchInfo.participants.length ~/ 2),
          matchInfo.teams[1]);
    }
    Color teamColor = isWinnerTeam ? Colors.blue : Colors.red;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              teamName,
              style: TextStyle(
                color: teamColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0, width: 10),
            //TODO icon kék
            _buildStatIconAndText(
              'https://s-lol-web.op.gg/images/icon/icon-tower.svg?v=1678413225229',
              '${teamHeader.turrets}',
            ),
            SizedBox(width: 8.0),
            _buildStatIconAndText(
              'https://s-lol-web.op.gg/images/icon/icon-dragon.svg?v=1678413225229',
              '${teamHeader.dragons}',
            ),
            SizedBox(width: 8.0),
            _buildStatIconAndText(
              'https://s-lol-web.op.gg/images/icon/icon-baron.svg?v=1678413225229',
              '${teamHeader.barons}',
            ),
            Spacer(),
            Text(
              '${teamHeader.kills} / ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${teamHeader.deaths}',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' / ${teamHeader.assists}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatIconAndText(String iconUrl, String text) {
    return Row(
      children: [
        SvgPicture.network(
          iconUrl,
          height: 16,
          width: 16,
        ),
        Text(
          ' $text',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsRow(int item) {
    return item != 0
        ? Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage("assets/items/${item}.png"),
              ),
            ),
          )
        : Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorPalette().primary),
          );
  }

  Widget _buildDamageDealtBar(int damageDealt, int maxDamageDealt) {
    final double barWidth = 100;
    final double barHeight = 10;
    final double barValue = damageDealt.toDouble() / maxDamageDealt.toDouble();
    final double filledWidth = barWidth * barValue;

    return Container(
      height: barHeight,
      width: barWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(barHeight),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: barHeight,
          width: filledWidth,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(barHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildDamageDealtBar2(int damageDealt, int maxDamageDealt) {
    final double barWidth = 10;
    final double barHeight = 40;
    final double barValue = damageDealt.toDouble() / maxDamageDealt.toDouble();
    final double filledWidth = barHeight * barValue;

    return Container(
      height: barHeight,
      width: barWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(barHeight),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: filledWidth,
          width: barWidth,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(barHeight),
          ),
        ),
      ),
    );
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
}

class RankIcon extends StatelessWidget {
  final Summoner summonerInfo;
  final int queueId;
  const RankIcon({Key? key, required this.summonerInfo, required this.queueId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (queueId == 420 && summonerInfo.soloRank != null) {
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/ranks/${summonerInfo.soloRank!.tier!}.png"),
          ),
        ),
      );
    } else if (queueId == 440 && summonerInfo.flexRank != null) {
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/ranks/${summonerInfo.flexRank!.tier!}.png"),
          ),
        ),
      );
    }
    if (summonerInfo.soloRank != null) {
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/ranks/${summonerInfo.soloRank!.tier!}.png"),
          ),
        ),
      );
    } else if (summonerInfo.flexRank != null) {
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/ranks/${summonerInfo.flexRank!.tier!}.png"),
          ),
        ),
      );
    }
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }
}

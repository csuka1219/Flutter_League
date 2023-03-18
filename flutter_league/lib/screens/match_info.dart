import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/model/playerstats.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/team_header.dart';
import 'package:flutter_riot_api/screens/match_details.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchInfoPage extends StatelessWidget {
  final Match matchInfo;
  final String summonerName;
  final bool isWin;
  const MatchInfoPage(
      {Key? key,
      required this.matchInfo,
      required this.summonerName,
      required this.isWin})
      : super(key: key);

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
          style: TextStyle(color: isWin ? Colors.green[400] : Colors.red[400]),
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
      body: Column(
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
                      color: isWin ? Colors.green[400] : Colors.red[400],
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
                        "${getGameModeByQueueId(matchInfo.queueId)} - ${getFormattedDuration(matchInfo.gameDuration)}",
                        style: TextStyle(
                          color: isWin ? Colors.green[400] : Colors.red[400],
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Icon(Icons.schedule,
                          color: isWin ? Colors.green[400] : Colors.red[400],
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
                      "WINNER ${matchInfo.participants[0].win ? '(BLUE)' : '(RED)'}",
                      true),
                  SizedBox(height: 10),
                  _buildPlayerList(true),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.red,
                    thickness: 1,
                  ),
                  _buildTeamHeader(
                      "LOSER ${matchInfo.participants[0].win ? '(RED)' : '(BLUE)'}",
                      false),
                  SizedBox(height: 10),
                  _buildPlayerList(false),
                  SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList(bool isWinner) {
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
        return Container(
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
                          "${playerStat.summonerName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8),
                        Row(
                          children: [
                            RankIcon(),
                            SizedBox(width: 4),
                            Text(
                              //TODO
                              'Gold 2',
                              style: TextStyle(fontSize: 10),
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
                        "${playerStat.totalCS} CS(${getCsPerMinute(playerStat)})",
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
        );
      },
    );
  }

  Widget _buildTeamHeader(String teamName, bool isWinnerTeam) {
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
                color: isWinnerTeam ? Colors.blue : Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0, width: 10),
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

  String getCsPerMinute(PlayerStats playerStat) {
    double gameDurationInMinutes = matchInfo.gameDuration / 60;
    double csPerMinute = playerStat.totalCS / gameDurationInMinutes;
    return csPerMinute.toStringAsFixed(1);
  }
}

class RankIcon extends StatelessWidget {
  const RankIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://opgg-static.akamaized.net/images/medals_new/gold.png?image=q_auto,f_webp,w_144&v=1678078753677"))),
    );
  }
}

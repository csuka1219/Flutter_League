import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/providers/matchhistory_provider.dart';
import 'package:flutter_riot_api/screens/match_info.dart';
import 'package:flutter_riot_api/services/matchinfo_service.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';

class MatchItem extends StatelessWidget {
  final MatchPreview matchHistory;
  final Summoner summonerInfo;
  final MatchHistoryData matchHistoryData;

  const MatchItem(
      {Key? key,
      required this.matchHistory,
      required this.summonerInfo,
      required this.matchHistoryData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ///TODO null check
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MatchInfoPage(
                    summonerName: summonerInfo.name,
                    isWin: matchHistory.playerStats.win,
                    matchId: matchHistory.matchId,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: matchHistory.playerStats.win
                ? Color.fromARGB(255, 190, 226, 255)
                : Color.fromARGB(255, 255, 116, 116),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Champion icon
              _buildChampIcon(),
              SizedBox(width: 16),
              _buildMatchDetails(),
              Spacer(),
              // Rune pages
              _buildRunePages(),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildRunePages() {
    return Column(
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
                "assets/runes/${matchHistory.playerStats.perks.primaryStyle}.png",
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
                "assets/runes/${matchHistory.playerStats.perks.secondaryStyle}.png",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildMatchDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Game mode and match length
        Row(
          children: [
            Text(
              "${getGameModeByQueueId(matchHistory.queueId)}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            SizedBox(width: matchHistory.playerStats.role.isNotEmpty ? 4 : 0),
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
            for (var i = 0; i < matchHistory.playerStats.items.length - 1; i++)
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
    );
  }

  Column _buildChampIcon() {
    return Column(
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
}

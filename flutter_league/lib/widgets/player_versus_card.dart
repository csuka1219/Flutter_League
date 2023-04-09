import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/utils/getchampionname.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:flutter_riot_api/utils/storage.dart';

class PlayerVersusCard extends StatelessWidget {
  final Summoner blueSummonerInfo;
  final Summoner redSummonerInfo;
  final Participant bluePlayerMatchInfo;
  final Participant redPlayerMatchInfo;
  final bool isSoloQueue;
  final String lane;
  final String? serverId;
  const PlayerVersusCard(
      {super.key,
      required this.blueSummonerInfo,
      required this.redSummonerInfo,
      required this.bluePlayerMatchInfo,
      required this.redPlayerMatchInfo,
      required this.isSoloQueue,
      required this.lane,
      this.serverId});

  @override
  Widget build(BuildContext context) {
    // Check if the blue team player is unranked
    bool isUnrankedBlue = isUnranked(isSoloQueue, blueSummonerInfo);

    // Check if the red team player is unranked
    bool isUnrankedRed = isUnranked(isSoloQueue, redSummonerInfo);

    // Return a row widget that contains the information of both players
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Column(
              children: [
                // The row widget that displays the champion icons and stats of both players
                Row(
                  children: [
                    _buildChampionIcon(bluePlayerMatchInfo),
                    const SizedBox(width: 10),
                    _buildBluePlayerStatsRow(bluePlayerMatchInfo,
                        isUnrankedBlue, blueSummonerInfo, isSoloQueue),
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/roles/$lane.png"),
                        ),
                      ),
                    ),
                    _buildRedPlayerStatsRow(isUnrankedRed, redSummonerInfo,
                        isSoloQueue, redPlayerMatchInfo),
                    const SizedBox(width: 10),
                    _buildChampionIcon(redPlayerMatchInfo),
                  ],
                ),
                // The row widget that displays the summoner information of both players
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBlueSummonerInfoColumn(
                        blueSummonerInfo, context, isUnrankedBlue, isSoloQueue),
                    _buildVsText(),
                    redSummonerInfoWidget(
                        redSummonerInfo, context, isUnrankedRed, isSoloQueue),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Expanded redSummonerInfoWidget(Summoner redSummonerInfo, BuildContext context,
      bool isUnrankedRed, bool isSoloQueue) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 5,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: GestureDetector(
              onTap: () async {
                List<SummonerServer> summonerServers = await loadSummoners();
                bool isFavourite = false;
                if (summonerServers
                    .any((s) => s.puuid == redSummonerInfo.puuid)) {
                  isFavourite = true;
                }
                // ignore: use_build_context_synchronously
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
                    style: const TextStyle(
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
    );
  }

  Expanded _buildVsText() {
    return Expanded(
      child: Column(
        children: const [
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
    );
  }

  Expanded _buildBlueSummonerInfoColumn(Summoner blueSummonerInfo,
      BuildContext context, bool isUnrankedBlue, bool isSoloQueue) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: GestureDetector(
              onTap: () async {
                List<SummonerServer> summonerServers = await loadSummoners();
                bool isFavourite = false;
                if (summonerServers
                    .any((s) => s.puuid == blueSummonerInfo.puuid)) {
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
                    style: const TextStyle(
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
    );
  }

  Expanded _buildRedPlayerStatsRow(bool isUnrankedRed, Summoner redSummonerInfo,
      bool isSoloQueue, Participant redPlayerMatchInfo) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              isUnrankedRed
                  ? Text(
                      "0 Games",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                  : _buildGamesPlayedText(redSummonerInfo, isSoloQueue),
              _buildWinrateText(isUnrankedRed
                  ? "-"
                  : getWinrate(isSoloQueue, redSummonerInfo)),
              isUnrankedRed
                  ? Text(
                      "Unranked",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                  : _buildRankText(redSummonerInfo, isSoloQueue)
            ],
          ),
          const SizedBox(
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
    );
  }

  Expanded _buildBluePlayerStatsRow(Participant bluePlayerMatchInfo,
      bool isUnrankedBlue, Summoner blueSummonerInfo, bool isSoloQueue) {
    return Expanded(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSummonerSpell(bluePlayerMatchInfo.spell1Id),
              const SizedBox(
                height: 2.5,
              ),
              _buildRune(bluePlayerMatchInfo.perkStyle)
            ],
          ),
          const SizedBox(
            width: 2.5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSummonerSpell(bluePlayerMatchInfo.spell2Id),
              const SizedBox(
                height: 2.5,
              ),
              _buildRune(bluePlayerMatchInfo.perkSubStyle)
            ],
          ),
          const SizedBox(
            width: 8.5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isUnrankedBlue
                  ? Text(
                      "0 Games",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                  : _buildGamesPlayedText(blueSummonerInfo, isSoloQueue),
              _buildWinrateText(isUnrankedBlue
                  ? "-"
                  : getWinrate(isSoloQueue, blueSummonerInfo)),
              isUnrankedBlue
                  ? Text(
                      "Unranked",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                  : _buildRankText(blueSummonerInfo, isSoloQueue)
            ],
          )
        ],
      ),
    );
  }

  Container _buildChampionIcon(Participant bluePlayerMatchInfo) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(
              "assets/champions/${getChampionNameById(bluePlayerMatchInfo.championId)}.png"),
        ),
      ),
    );
  }

  Text _buildWinrateText(String winRate) {
    return Text(
      "$winRate%",
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          // Set the color of the win rate based on whether it's above or below 50%
          color: winRate != "-"
              ? (int.parse(winRate) >= 50)
                  ? const Color.fromARGB(255, 49, 169, 53)
                  : Colors.red
              : Colors.black),
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

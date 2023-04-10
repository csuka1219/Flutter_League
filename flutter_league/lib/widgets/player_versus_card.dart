import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/utils/riotdata_formatter.dart';
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

  /// This function returns an expanded column widget that displays information about the red summoner.
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
                // Load the list of summoner servers
                List<SummonerServer> summonerServers = await loadSummoners();
                bool isFavourite = false;
                // Check if the current summoner is in the list of favourite summoners
                if (summonerServers
                    .any((s) => s.puuid == redSummonerInfo.puuid)) {
                  isFavourite = true;
                }
                // Navigate to the MatchHistoryPage with the current summoner's information
                // Pass the isFavourite boolean to determine if the summoner is already a favourite
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
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Display the summoner's name with a maximum length of 20 characters
                    Text(
                      redSummonerInfo.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    // If the summoner has a rank, display the corresponding rank image
                    // If not, display an empty Container
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

  /// This function returns an expanded column widget that displays information about the blue summoner.
  Expanded _buildBlueSummonerInfoColumn(
      Summoner blueSummonerInfo, // Information about the blue summoner.
      BuildContext context, // The current build context.
      bool
          isUnrankedBlue, // Whether the blue summoner is unranked in their current queue.
      bool isSoloQueue // Whether the current queue is a solo queue.
      ) {
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
                // This function is called when the user taps the widget. It opens a match history page for the blue summoner.
                List<SummonerServer> summonerServers =
                    await loadSummoners(); // Load the list of summoner servers.
                bool isFavourite = false;
                if (summonerServers
                    .any((s) => s.puuid == blueSummonerInfo.puuid)) {
                  // Check if the blue summoner is a favourite.
                  isFavourite = true;
                }
                // ignore: use_build_context_synchronously
                Navigator.push(
                  // Open the match history page.
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
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    isUnrankedBlue
                        ? Container() // If the blue summoner is unranked, don't display their rank.
                        : Container(
                            // If the blue summoner has a rank, display their rank icon.
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
                      blueSummonerInfo
                          .name, // Display the blue summoner's name.
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the row containing player stats for the red team
  Expanded _buildRedPlayerStatsRow(bool isUnrankedRed, Summoner redSummonerInfo,
      bool isSoloQueue, Participant redPlayerMatchInfo) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Column containing games played, winrate, and rank
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Displays number of games played
              isUnrankedRed
                  ? Text(
                      "0 Games",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                  : _buildGamesPlayedText(redSummonerInfo, isSoloQueue),
              // Displays winrate percentage
              _buildWinrateText(isUnrankedRed
                  ? "-"
                  : getWinrate(isSoloQueue, redSummonerInfo)),
              // Displays rank, or "Unranked" if unranked
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
          // Column containing first summoner spell and rune
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSummonerSpell(redPlayerMatchInfo.spell1Id),
              _buildRune(redPlayerMatchInfo.perkStyle)
            ],
          ),
          // Column containing second summoner spell and rune
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

  /// This method returns a Row widget that displays the stats for a blue player
  Expanded _buildBluePlayerStatsRow(Participant bluePlayerMatchInfo,
      bool isUnrankedBlue, Summoner blueSummonerInfo, bool isSoloQueue) {
    return Expanded(
      child: Row(
        children: [
          // Column to display first summoner spell and primary rune
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSummonerSpell(
                  bluePlayerMatchInfo.spell1Id), // Display first summoner spell
              const SizedBox(
                height: 2.5,
              ),
              _buildRune(bluePlayerMatchInfo.perkStyle) // Display primary rune
            ],
          ),
          const SizedBox(
            width: 2.5,
          ),
          // Column to display second summoner spell and secondary rune
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSummonerSpell(bluePlayerMatchInfo
                  .spell2Id), // Display second summoner spell
              const SizedBox(
                height: 2.5,
              ),
              _buildRune(
                  bluePlayerMatchInfo.perkSubStyle) // Display secondary rune
            ],
          ),
          const SizedBox(
            width: 8.5,
          ),
          // Column to display number of games played, winrate, and rank (if applicable)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isUnrankedBlue
                  ? Text(
                      "0 Games",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                  : _buildGamesPlayedText(blueSummonerInfo,
                      isSoloQueue), // Display number of games played
              _buildWinrateText(isUnrankedBlue
                  ? "-"
                  : getWinrate(
                      isSoloQueue, blueSummonerInfo)), // Display winrate
              isUnrankedBlue
                  ? Text(
                      "Unranked",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    )
                  : _buildRankText(blueSummonerInfo,
                      isSoloQueue) // Display rank (if applicable)
            ],
          )
        ],
      ),
    );
  }

  /// This function returns a container widget with a circular avatar image of the champion
  /// played by the given player in the match.
  Container _buildChampionIcon(Participant playerMatchInfo) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(
              // Load the image of the champion based on the champion ID of the given player.
              "assets/champions/${getChampionNameById(playerMatchInfo.championId)}.png"),
        ),
      ),
    );
  }

  /// This function returns a Text widget with the win rate percentage of the player.
  Text _buildWinrateText(String winRate) {
    return Text(
      "$winRate%",
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          // Set the color of the win rate based on whether it's above or below 50%.
          color: winRate != "-"
              ? (int.parse(winRate) >= 50)
                  ? const Color.fromARGB(255, 49, 169, 53)
                  : Colors.red
              : Colors.black),
    );
  }

  /// This function checks whether the given summoner is unranked in the given queue type.
  bool isUnranked(bool isSoloQueue, Summoner redSummonerInfo) {
    return (isSoloQueue && redSummonerInfo.soloRank == null) ||
        (!isSoloQueue && redSummonerInfo.flexRank == null);
  }

  /// Builds and returns a widget that displays the rank of a player in the specified queue (solo or flex).
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

  /// Builds and returns a widget that displays the number of games played by a player in the specified queue (solo or flex).
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

  // Builds and returns a widget that displays the summoner spell with the given ID.
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

  /// Builds and returns a widget that displays the rune with the given ID.
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
}

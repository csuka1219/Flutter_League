import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/match.dart';
import 'package:flutter_riot_api/model/playerstats.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/model/team_header.dart';
import 'package:flutter_riot_api/providers/matchinfo_provider.dart';
import 'package:flutter_riot_api/screens/match_details.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:flutter_riot_api/widgets/rankicon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../utils/storage.dart';

// ignore: must_be_immutable
class MatchInfoPage extends StatelessWidget {
  final String summonerName;
  final bool isWin;
  final String matchId;
  final String? serverId;
  MatchInfoPage({
    Key? key,
    required this.summonerName,
    required this.isWin,
    required this.matchId,
    this.serverId,
  }) : super(key: key);
  static final ColorPalette colorPalette = ColorPalette();
  List<PlayerStats> playerStats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context), // Set the app bar
      body: ChangeNotifierProvider(
        create: (_) =>
            MatchInfoData(), // Create a new instance of the match info data
        child: Consumer<MatchInfoData>(
          builder: (context, matchInfoData, child) {
            if (matchInfoData.isLoading) {
              // If the match info data is still loading, show a progress indicator
              matchInfoData.initDatas(
                  matchId, serverId); // Initialize the match info data
              // Return the progress indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            playerStats = matchInfoData.matchInfo!
                .participants; // Get the player stats from the match info data
            // Return the main content of the screen
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show the result of the match
                _buildMatchHeader(matchInfoData),
                const SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Show the winner team header and player list
                        const Divider(
                          color: Colors.blue,
                          thickness: 1.0,
                        ),
                        _buildTeamHeader(
                          matchInfoData.matchInfo!,
                          "WINNER ${matchInfoData.matchInfo!.participants[0].win ? '(BLUE)' : '(RED)'}",
                          true,
                        ),
                        const SizedBox(height: 10),
                        _buildPlayerList(
                          matchInfoData.matchInfo!,
                          matchInfoData.summonerInfos,
                          true,
                        ),
                        const SizedBox(height: 20),
                        // Show the loser team header and player list
                        const Divider(
                          color: Colors.red,
                          thickness: 1,
                        ),
                        _buildTeamHeader(
                          matchInfoData.matchInfo!,
                          "LOSER ${matchInfoData.matchInfo!.participants[0].win ? '(RED)' : '(BLUE)'}",
                          false,
                        ),
                        const SizedBox(height: 10),
                        _buildPlayerList(
                          matchInfoData.matchInfo!,
                          matchInfoData.summonerInfos,
                          false,
                        ),
                        const SizedBox(height: 32.0),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    // Set the icon color based on whether the match was won or lost
    IconThemeData iconTheme =
        IconThemeData(color: isWin ? Colors.green[400] : Colors.red[400]);
    // Return an AppBar widget
    return AppBar(
      iconTheme: iconTheme, // Set the icon color
      backgroundColor: colorPalette.primary, // Set the background color
      title: Text(
        "Match Info",
        style: TextStyle(color: isWin ? Colors.green[400] : Colors.red[400]),
      ), // Set the title of the AppBar
      actions: [
        // Add an icon button to show the match details
        IconButton(
          splashRadius: 20,
          color: colorPalette.secondary, // Set the color of the button
          icon: Icon(
            Icons.bar_chart,
            color: isWin ? Colors.green[400] : Colors.red[400],
          ), // Set the icon to use for the button
          onPressed: () => {
            // When the button is pressed, navigate to the MatchDetailsPage
            // Only navigate if the playerStats list is not empty
            if (playerStats.isNotEmpty)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchDetailsPage(
                      playerStats: playerStats,
                      summonerName: summonerName,
                    ),
                  ),
                ),
              },
          },
        ),
      ],
    );
  }

  /// Builds the header for the match information, including the result of the match, the game mode, and the duration.
  Container _buildMatchHeader(MatchInfoData matchInfoData) {
    // Create a container with a blue background and rounded corners
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        // Create a child container with a primary-colored background and padding
        color: colorPalette.primary,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display a text widget that says either "Victory" or "Defeat"
            Text(
              isWin ? "Victory" : "Defeat",
              style: TextStyle(
                color: isWin ? Colors.green[400] : Colors.red[400],
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Display a row with the game mode and duration, along with a clock icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${getGameModeByQueueId(matchInfoData.matchInfo!.queueId)} - ${getFormattedDuration(matchInfoData.matchInfo!.gameDuration)}",
                  style: TextStyle(
                    color: isWin ? Colors.green[400] : Colors.red[400],
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  Icons.schedule,
                  color: isWin ? Colors.green[400] : Colors.red[400],
                  size: 16.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// A method to build a list of players in a match
  Widget _buildPlayerList(
      Match matchInfo, // Information about the match being displayed
      List<Summoner?>
          summonerInfos, // List of summoner information for each player
      bool
          isWinner // A boolean value indicating if the player's team won the match
      ) {
    double lineWidth = 0; // Width of the border around the champion image

    // Create a sublist of the first 5 or last 5 players depending on if the team won
    List<PlayerStats> tempList = isWinner
        ? matchInfo.participants.sublist(0, 5)
        : matchInfo.participants.sublist(5);

    // Create a sublist of the first 5 or last 5 summoners depending on if the team won
    List<Summoner?> tempSummonerList =
        isWinner ? summonerInfos.sublist(0, 5) : summonerInfos.sublist(5);

    // Build a ListView widget with a separator between each item
    return ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1.0,
        );
      },
      itemBuilder: (context, index) {
        // Get the player stats for the current index
        PlayerStats playerStat = tempList[index];

        // Set the border width based on whether or not the player is the user
        (playerStat.summonerName == summonerName)
            ? lineWidth = 3
            : lineWidth = 0;

        // Build a gesture detector that navigates to the match history page when tapped
        return GestureDetector(
          onTap: () async {
            // Load the summoner names from storage
            List<SummonerServer> summonerNames = await loadSummoners();

            // Check if the current summoner is marked as a favorite
            bool isFavourite = summonerNames
                .any((s) => s.puuid == tempSummonerList[index]!.puuid);

            // Navigate to the match history page for the current summoner
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchHistoryPage(
                  summonerInfo: tempSummonerList[index]!,
                  isFavourite: isFavourite,
                  serverId: serverId,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display the champion image with a border around it
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the summoner name and rank
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                          children: [
                            Text(
                              playerStat.summonerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Row(
                              children: [
                                RankIcon(
                                  summonerInfo: tempSummonerList[index]!,
                                  queueId: matchInfo.queueId,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  getRank(matchInfo, tempSummonerList[index]!),
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      //display spells and runes
                      Row(
                        children: [
                          _buildSummonerSpell(playerStat.summoner1Id),
                          const SizedBox(width: 2.5),
                          _buildSummonerSpell(playerStat.summoner2Id),
                          const SizedBox(width: 2.5),
                          _buildRune(playerStat.perks.primaryStyle),
                          const SizedBox(width: 2.5),
                          _buildRune(playerStat.perks.secondaryStyle),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //display kda and cs/min
                    Row(
                      children: [
                        Text(
                          "${playerStat.totalCS} CS(${getCsPerMinute(matchInfo, playerStat)})",
                          style: const TextStyle(fontSize: 9),
                        ),
                        const SizedBox(width: 5),
                        _buildKDAText("${playerStat.kills} / ", Colors.black),
                        _buildKDAText("${playerStat.deaths}", Colors.red),
                        _buildKDAText(" / ${playerStat.assists}", Colors.black),
                      ],
                    ),
                    const SizedBox(height: 5),
                    //display items
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

  Text _buildKDAText(String text, Color color) {
    return Text(
      "$text / ",
      style: TextStyle(
        color: color,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Container _buildSummonerSpell(int summonerId) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          image: AssetImage("assets/spells/$summonerId.png"),
        ),
      ),
    );
  }

  Container _buildRune(int runeId) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorPalette.primary,
        image: DecorationImage(
          image: AssetImage("assets/runes/$runeId.png"),
        ),
      ),
    );
  }

  /// Returns a [Container] widget that displays the team's name, statistics and KDA.
  Container _buildTeamHeader(
      Match matchInfo, String teamName, bool isWinnerTeam) {
    // Determine which team header to use based on whether the team is the winner or not.
    final teamHeader = isWinnerTeam
        ? TeamHeader(
            matchInfo.participants
                .sublist(0, matchInfo.participants.length ~/ 2),
            matchInfo.teams[0])
        : TeamHeader(
            matchInfo.participants.sublist(matchInfo.participants.length ~/ 2),
            matchInfo.teams[1]);

    // Determine the team color based on whether the team is the winner or not.
    final teamColor = isWinnerTeam ? Colors.blue : Colors.red;

    // Build the container widget that displays the team information.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Display the team's name.
            Text(
              teamName,
              style: TextStyle(
                color: teamColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0, width: 10),
            // Display the team's statistics.
            _buildStatIconAndText(
                'turret.svg', '${teamHeader.turrets}', teamColor),
            const SizedBox(width: 8.0),
            _buildStatIconAndText(
                'drake.svg', '${teamHeader.dragons}', teamColor),
            const SizedBox(width: 8.0),
            _buildStatIconAndText(
                'baron.svg', '${teamHeader.barons}', teamColor),
            const Spacer(),
            // Display the team's KDA.
            _buildTeamKda("${teamHeader.kills} /", Colors.black),
            _buildTeamKda(" ${teamHeader.assists}", Colors.red),
            _buildTeamKda(" / ${teamHeader.kills}", Colors.black),
          ],
        ),
      ),
    );
  }

  /// Builds a Text widget with the given text and color
  Text _buildTeamKda(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Builds a Row widget with an icon, text, and color
  Row _buildStatIconAndText(String iconName, String text, Color color) {
    return Row(
      children: [
        // Adds an SVG icon to the Row with the given color filter
        SvgPicture.asset(
          "assets/objects/$iconName",
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        // Adds text to the Row with a font size of 12 and black color
        Text(
          ' $text',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  /// This function takes an integer item number as input and returns a widget
  Container _buildItemsRow(int item) {
    // Check if item is not equal to zero
    if (item != 0) {
      // If the item number is not zero, create a Container widget with an image decoration
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            // The image source is determined by the item number
            image: AssetImage("assets/items/$item.png"),
          ),
        ),
      );
    } else {
      // If the item number is zero, create a Container widget with a solid background color
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorPalette
              .primary, // Use the primary color defined in the colorPalette
        ),
      );
    }
  }
}

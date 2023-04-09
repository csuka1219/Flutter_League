import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/providers/livegame_provider.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:flutter_riot_api/widgets/player_versus_card.dart';
import 'package:provider/provider.dart';

class LiveGamePage extends StatelessWidget {
  final LiveGame liveGameData;
  final String? serverId;
  const LiveGamePage({super.key, required this.liveGameData, this.serverId});

  @override
  Widget build(BuildContext context) {
    // Check if the game mode is Solo Queue (gameModeId 420)
    bool isSoloQueue = liveGameData.gameModeId == 420;

    return Scaffold(
      // Build the AppBar
      appBar: AppBar(
        // Set the icon color
        iconTheme: IconThemeData(color: ColorPalette().secondary),
        // Set the background color
        backgroundColor: ColorPalette().primary,
        // Set the title of the AppBar
        title: Text(
          'Live Game',
          style: TextStyle(color: ColorPalette().secondary),
        ),
      ),
      body: ChangeNotifierProvider(
        // Provide the LiveGameData to the widget tree
        create: (_) => LiveGameData(),
        // Consume the LiveGameData from the widget tree
        child: Consumer<LiveGameData>(
          builder: (context, liveGameSummoners, child) {
            if (liveGameSummoners.summonerInfos.isEmpty) {
              // If the summonerInfos list is empty, fetch data and show loading indicator
              liveGameSummoners.initDatas(liveGameData.participants, serverId);
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Build the widget tree for the live game display
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                _buildGameHeader(), // Build the game header
                const Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 10,
                  child: Container(
                    color: const Color.fromARGB(255, 238, 238, 238),
                  ),
                ),
                _buildTeamHeader(), // Build the team header
                for (int i = 0; i < 5; i++)
                  // Build the player versus cards for each lane
                  PlayerVersusCard(
                    blueSummonerInfo: liveGameSummoners.summonerInfos[i]!,
                    redSummonerInfo: liveGameSummoners.summonerInfos[i + 5]!,
                    bluePlayerMatchInfo: liveGameData.participants[i],
                    redPlayerMatchInfo: liveGameData.participants[i + 5],
                    isSoloQueue: isSoloQueue,
                    lane: getLane(i),
                    serverId: serverId,
                  ),
                SizedBox(
                  height: 40,
                  child: Container(
                    color: const Color.fromARGB(255, 238, 238, 238),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// This function returns a Row widget that displays the team header
  Row _buildTeamHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display the blue team name
        Column(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
        // Display the red team name
        Column(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
    );
  }

  /// This function returns a Row widget that displays information about the current game being played.
  Row _buildGameHeader() {
    return Row(
      children: [
        // This Column displays the game mode being played.
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                // Get the game mode based on the queue ID from the live game data.
                getGameModeByQueueId(liveGameData.gameModeId),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        // This SizedBox is a vertical divider to separate the game mode from the game duration.
        const SizedBox(
            height: 20,
            child: VerticalDivider(
              color: Colors.black,
            )),
        // This Column displays the game duration.
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 2.0),
                  child: Text(
                    // Get the formatted duration from the live game data.
                    getFormattedDuration(liveGameData.gameLength),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const Icon(Icons.schedule,
                    size: 14.0), // Display an icon of a clock.
              ],
            )
          ],
        ),
      ],
    );
  }
}

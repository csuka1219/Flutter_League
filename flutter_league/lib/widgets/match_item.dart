import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/match_preview.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/providers/matchhistory_provider.dart';
import 'package:flutter_riot_api/screens/match_info.dart';

class MatchItem extends StatelessWidget {
  final MatchPreview matchHistory;
  final Summoner summonerInfo;
  final MatchHistoryData matchHistoryData;
  final String? serverId;

  const MatchItem(
      {Key? key,
      required this.matchHistory,
      required this.summonerInfo,
      required this.matchHistoryData,
      this.serverId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // When the user taps on this widget, navigate to the MatchInfoPage and pass along some parameters
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchInfoPage(
              summonerName: summonerInfo.name,
              isWin: matchHistory.playerStats.win,
              matchId: matchHistory.matchId,
              serverId: serverId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          // The container has a rounded border and a background color depending on the match result
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: matchHistory.playerStats.win
                ? const Color.fromARGB(255, 190, 226, 255)
                : const Color.fromARGB(255, 255, 116, 116),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the champion icon
              _buildChampIcon(),
              const SizedBox(width: 16),
              // Display the match details
              _buildMatchDetails(),
              const Spacer(),
              // Display the rune pages used in this match
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
        const SizedBox(height: 8),
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
              getGameModeByQueueId(matchHistory
                  .queueId), // Display game mode based on the queue ID of the match
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              " - ${getFormattedDuration(matchHistory.gameDuration)}", // Display formatted duration of the match
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Icon(Icons.schedule,
                color: Colors.grey[600],
                size: 14.0), // Display a clock icon to represent match duration
          ],
        ),
        const SizedBox(height: 8), // Add a small vertical spacing
        // KDA
        _buildPlayerStats(), // Display player's kill, death and assists (KDA) in a separate widget
        const SizedBox(height: 8), // Add a small vertical spacing
        // Match items
        _buildPlayerItems(), // Display the player's items in a separate widget
      ],
    );
  }

  Row _buildPlayerItems() {
    return Row(
      children: [
        // Loop through each item the player had
        for (var i = 0; i < matchHistory.playerStats.items.length - 1; i++)
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: matchHistory.playerStats.items[i] != 0
                // If the item is not a default empty item slot, display the item icon
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
                // If the item is a default empty item slot, display a blank circle
                : Container(
                    width: 25.0,
                    height: 25.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorPalette().primary),
                  ),
          ),
        // Display the ward separately since it has a different position in the item list
        Container(
          width: 25.0,
          height: 25.0,
          decoration: matchHistory.playerStats.item6 != 0
              // If the ward is not a default empty item slot, display the item icon
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/items/${matchHistory.playerStats.item6}.png"),
                  ),
                )
              // If the ward is a default empty item slot, display nothing
              : const BoxDecoration(),
        ),
      ],
    );
  }

  Row _buildPlayerStats() {
    return Row(
      children: [
        // Player role icon
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
        // Spacing after player role icon
        SizedBox(width: matchHistory.playerStats.role.isNotEmpty ? 4 : 0),
        // Player KDA text with color
        _buildKDAText("${matchHistory.playerStats.kills} / ", Colors.black),
        _buildKDAText("${matchHistory.playerStats.deaths}",
            const Color.fromARGB(255, 198, 24, 65)),
        _buildKDAText(" / ${matchHistory.playerStats.assists}", Colors.black),
        const SizedBox(
          width: 5,
        ),
        // Player total CS text
        Text(
          "${matchHistory.playerStats.totalCS} CS",
          style: const TextStyle(
            color: Color.fromARGB(255, 94, 94, 94),
          ),
        ),
      ],
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
        const SizedBox(height: 4),
        // Summoner spells
        Row(
          children: [
            _buildSummonerSpell(matchHistory.playerStats.summoner1Id),
            const SizedBox(width: 4),
            _buildSummonerSpell(matchHistory.playerStats.summoner2Id)
          ],
        ),
      ],
    );
  }

  Container _buildSummonerSpell(int summonerid) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          image: AssetImage(
            "assets/spells/$summonerid.png",
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
    return gameModes[queueId]!; //TODO nincs ilyen
  }
}

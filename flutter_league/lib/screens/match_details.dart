import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/playerstats.dart';
import 'package:tuple/tuple.dart';

class MatchDetailsPage extends StatelessWidget {
  final List<PlayerStats> playerStats;
  final String summonerName;

  const MatchDetailsPage(
      {super.key, required this.playerStats, required this.summonerName});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorPalette().secondary),
          backgroundColor: ColorPalette().primary,
          title: Text(
            'Match Details',
            style: TextStyle(color: ColorPalette().secondary),
          ),
          bottom: TabBar(
            indicatorColor: ColorPalette().secondary,
            isScrollable: true,
            tabs: [
              Tab(text: 'Kills'),
              Tab(text: 'Gold'),
              Tab(text: 'Damage Dealt'),
              Tab(text: 'Damage Taken'),
              Tab(text: 'Wards'),
              Tab(text: 'CS'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent(
                      'kills',
                      orderByProperty(
                          List<PlayerStats>.from(playerStats), "kills")),
                  _buildTabContent(
                      'gold',
                      orderByProperty(
                          List<PlayerStats>.from(playerStats), "gold")),
                  _buildTabContent(
                      'damageDealt',
                      orderByProperty(List<PlayerStats>.from(playerStats),
                          "totalDamageDealtToChampions")),
                  _buildTabContent(
                      'damageTaken',
                      orderByProperty(List<PlayerStats>.from(playerStats),
                          "totalDamageTaken")),
                  _buildTabContent(
                      'wards',
                      orderByProperty(
                          List<PlayerStats>.from(playerStats), "wardsPlaced")),
                  _buildTabContent(
                      'cs',
                      orderByProperty(
                          List<PlayerStats>.from(playerStats), "totalCS")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
      String category, List<PlayerStats> sortedPlayerStats) {
    final categoryPropertyMap = {
      'kills': (stats) => stats.kills,
      'gold': (stats) => stats.goldEarned,
      'damageDealt': (stats) => stats.totalDamageDealtToChampions,
      'damageTaken': (stats) => stats.totalDamageTaken,
      'wards': (stats) => stats.wardsPlaced,
      'cs': (stats) => stats.totalCS,
    };

    // Find the maximum value of the given category in the player stats.
    int maxData = sortedPlayerStats
        .map((stats) => categoryPropertyMap[category]!(stats))
        .reduce((a, b) => a > b ? a : b);

    // Calculate the ratio of data to maximum data.
    final ratio = maxData == 0 ? 1.0 : 1.0 / maxData;

    // Build the list view of player stats.
    return ListView.builder(
      itemCount: sortedPlayerStats.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          // Build the team comparison widget.
          return _buildTeamComparisonWidget(category, sortedPlayerStats);
        }

        // Get the index of the player stats for the current row.
        final playerStatsIndex = index - 1;

        // Determine the color of the row based on whether the player won or lost.
        final color =
            sortedPlayerStats[playerStatsIndex].win ? Colors.blue : Colors.red;

        // Get the data value for the given category and player stats.
        final data = _getData(sortedPlayerStats[playerStatsIndex], category);

        // Build the row for the player stats.
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue,
                    //if you summoner is the summoner that you select earlier
                    width: sortedPlayerStats[playerStatsIndex].summonerName ==
                            summonerName
                        ? 3
                        : 0,
                  ),
                  //champion icon
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/champions/${sortedPlayerStats[playerStatsIndex].championName}.png"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show the data value for the given category.
                    Text(
                      NumberFormat('#,##0', 'en_US').format(data),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    // Show a progress bar for the data value relative to the maximum data value.
                    LinearProgressIndicator(
                      value: data.toDouble() * ratio,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // This function builds a widget that displays a comparison between two teams based on a given category
  Widget _buildTeamComparisonWidget(
      String category, List<PlayerStats> sortedPlayerStats) {
    // Initialize team data to 0
    int team1Data = 0;
    int team2Data = 0;

    // Get the team data for the given category
    var restuple = _getTeamData(category, sortedPlayerStats);
    team1Data = restuple.item1;
    team2Data = restuple.item2;

    // Return a container widget that displays the team data comparison
    return Container(
      // Set the container color
      color: Colors.grey[200],
      // Set the container padding
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Build the column widget that displays the team data
      child: Column(
        children: [
          // Build a row widget that displays the team data for winner and loser
          Row(
            // Set the row widget's main axis alignment
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Add two widgets that display the team data for winner and loser
            children: [
              _buildTeamDataWidget('Winner', team1Data, Colors.blue),
              const SizedBox(width: 16),
              _buildTeamDataWidget('Loser', team2Data, Colors.red),
            ],
          ),
          // Add a SizedBox widget for spacing
          const SizedBox(height: 16),
          // Add a LinearProgressIndicator widget that displays the percentage of the team data for the winner
          LinearProgressIndicator(
            // Calculate the value of the progress indicator
            value: team1Data / (team1Data + team2Data),
            // Set the progress indicator value color
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            // Set the progress indicator background color
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  // Widget to display team data
  Widget _buildTeamDataWidget(String teamName, int data, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Display team name with a bold font
        Text(
          teamName,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 8),
        // Display data with comma separators and a bold font
        Text(
          NumberFormat('#,##0', 'en_US').format(data),
          style: TextStyle(
              fontSize: 24, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<PlayerStats> orderByProperty(
      List<PlayerStats> playerStatsList, String property) {
    switch (property) {
      // Sort the list by the provided property using a descending order
      case "gold":
        playerStatsList.sort((a, b) => b.goldEarned.compareTo(a.goldEarned));
        break;
      case "kills":
        playerStatsList.sort((a, b) => b.kills.compareTo(a.kills));
        break;
      case "totalDamageDealtToChampions":
        playerStatsList.sort((a, b) => b.totalDamageDealtToChampions
            .compareTo(a.totalDamageDealtToChampions));
        break;
      case "totalDamageTaken":
        playerStatsList
            .sort((a, b) => b.totalDamageTaken.compareTo(a.totalDamageTaken));
        break;
      case "wardsPlaced":
        playerStatsList.sort((a, b) => b.wardsPlaced.compareTo(a.wardsPlaced));
        break;
      case "totalCS":
        playerStatsList.sort((a, b) => b.totalCS.compareTo(a.totalCS));
        break;
      // If an invalid property is provided, sort by gold by default
      default:
        playerStatsList.sort((a, b) => b.goldEarned.compareTo(a.goldEarned));
    }

// Return the sorted list
    return playerStatsList;
  }

  int _getData(PlayerStats stats, String category) {
    switch (category) {
      case 'kills':
        return stats.kills;
      case 'gold':
        return stats.goldEarned;
      case 'damageDealt':
        return stats.totalDamageDealtToChampions;
      case 'damageTaken':
        return stats.totalDamageTaken;
      case 'wards':
        return stats.wardsPlaced;
      case 'cs':
        return stats.totalCS;
      default:
        return 0;
    }
  }

  Tuple2<int, int> _getTeamData(
      String category, List<PlayerStats> sortedPlayerStats) {
    var winTeam = sortedPlayerStats.where((stats) => stats.win).toList();
    var loseTeam = sortedPlayerStats.where((stats) => !stats.win).toList();

    switch (category) {
      case 'kills':
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.kills),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.kills));
      case 'gold':
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.goldEarned),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.goldEarned));
      case 'damageDealt':
        return Tuple2(
            PlayerStats.sumByProperty(
                winTeam, (stats) => stats.totalDamageDealtToChampions),
            PlayerStats.sumByProperty(
                loseTeam, (stats) => stats.totalDamageDealtToChampions));
      case 'damageTaken':
        return Tuple2(
            PlayerStats.sumByProperty(
                winTeam, (stats) => stats.totalDamageTaken),
            PlayerStats.sumByProperty(
                loseTeam, (stats) => stats.totalDamageTaken));
      case 'wards':
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.wardsPlaced),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.wardsPlaced));
      case 'cs':
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.totalCS),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.totalCS));
      default:
        return const Tuple2(0, 0);
    }
  }
}

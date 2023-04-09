import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/playerstats.dart';
import 'package:tuple/tuple.dart';

class MatchDetailsPage extends StatelessWidget {
  final List<PlayerStats> playerStats;
  final String summonerName;
  static final ColorPalette colorPalette = ColorPalette();

  const MatchDetailsPage(
      {super.key, required this.playerStats, required this.summonerName});
  @override

  /// This widget builds the match details view using a TabView to display
  /// information about kills, gold, damage dealt, damage taken, wards and CS.
  /// It takes in a [BuildContext] and a [List] of [PlayerStats] objects.
  Widget build(BuildContext context) {
    // Build the match details view with a DefaultTabController and a Scaffold.
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        // Set the AppBar with a title and tabs.
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: colorPalette.secondary,
          ),
          backgroundColor: colorPalette.primary,
          title: Text(
            'Match Details',
            style: TextStyle(
              color: colorPalette.secondary,
            ),
          ),
          bottom: TabBar(
            // Set the tab labels and style.
            indicatorColor: colorPalette.secondary,
            isScrollable: true,
            tabs: const [
              Tab(
                text: 'Kills',
              ),
              Tab(
                text: 'Gold',
              ),
              Tab(
                text: 'Damage Dealt',
              ),
              Tab(
                text: 'Damage Taken',
              ),
              Tab(
                text: 'Wards',
              ),
              Tab(
                text: 'CS',
              ),
            ],
          ),
        ),
        // Set the body with a Column and an Expanded TabBarView.
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  // Use the _buildTabContent() method to build each tab.
                  _buildTabContent(
                    'kills',
                    orderByProperty(
                        List<PlayerStats>.from(playerStats), "kills"),
                  ),
                  _buildTabContent(
                    'gold',
                    orderByProperty(
                        List<PlayerStats>.from(playerStats), "gold"),
                  ),
                  _buildTabContent(
                    'damageDealt',
                    orderByProperty(List<PlayerStats>.from(playerStats),
                        "totalDamageDealtToChampions"),
                  ),
                  _buildTabContent(
                    'damageTaken',
                    orderByProperty(List<PlayerStats>.from(playerStats),
                        "totalDamageTaken"),
                  ),
                  _buildTabContent(
                    'wards',
                    orderByProperty(
                        List<PlayerStats>.from(playerStats), "wardsPlaced"),
                  ),
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

  /// This method builds the content of a tab in the UI, given a category and a list of player stats.
  Widget _buildTabContent(
      String category, List<PlayerStats> sortedPlayerStats) {
    // This map defines how to extract the value for a given category from a PlayerStats object.
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
                    width: sortedPlayerStats[playerStatsIndex].summonerName ==
                            summonerName
                        ? 3
                        : 0,
                  ),
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

  /// This function builds a widget that displays a comparison between two teams based on a given category
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  /// Widget to display team data
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

  /// This function takes in a list of PlayerStats objects and a string property
  /// It sorts the list of PlayerStats objects based on the provided property
  /// It then returns the sorted list of PlayerStats objects
  List<PlayerStats> orderByProperty(
      List<PlayerStats> playerStatsList, String property) {
    switch (property) {
      // Sort the list by the provided property using a descending order
      // For each case, the list is sorted based on the specified property
      // using a descending order by using the compareTo() method
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
      // For the default case, the list is sorted based on the goldEarned property
      // using a descending order
      default:
        playerStatsList.sort((a, b) => b.goldEarned.compareTo(a.goldEarned));
    }

    // Return the sorted list
    return playerStatsList;
  }

  /// This function takes a PlayerStats object and a category as input and returns the value of the corresponding category for that player.
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

  /// This function takes a category and a sorted list of PlayerStats objects as input and returns a Tuple2<int, int> object with the sums of the specified category for each team (winning and losing).
  Tuple2<int, int> _getTeamData(
      String category, List<PlayerStats> sortedPlayerStats) {
    // Split the list of PlayerStats into two lists, one for the winning team and one for the losing team.
    var winTeam = sortedPlayerStats.where((stats) => stats.win).toList();
    var loseTeam = sortedPlayerStats.where((stats) => !stats.win).toList();

    switch (category) {
      case 'kills':
        // Return a tuple with the sum of kills for the winning team and the sum of kills for the losing team.
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.kills),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.kills));
      case 'gold':
        // Return a tuple with the sum of gold earned for the winning team and the sum of gold earned for the losing team.
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.goldEarned),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.goldEarned));
      case 'damageDealt':
        // Return a tuple with the sum of damage dealt to champions for the winning team and the sum of damage dealt to champions for the losing team.
        return Tuple2(
            PlayerStats.sumByProperty(
                winTeam, (stats) => stats.totalDamageDealtToChampions),
            PlayerStats.sumByProperty(
                loseTeam, (stats) => stats.totalDamageDealtToChampions));
      case 'damageTaken':
        // Return a tuple with the sum of damage taken for the winning team and the sum of damage taken for the losing team.
        return Tuple2(
            PlayerStats.sumByProperty(
                winTeam, (stats) => stats.totalDamageTaken),
            PlayerStats.sumByProperty(
                loseTeam, (stats) => stats.totalDamageTaken));
      case 'wards':
        // Return a tuple with the sum of wards placed for the winning team and the sum of wards placed for the losing team.
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.wardsPlaced),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.wardsPlaced));
      case 'cs':
        // Return a tuple with the sum of CS for the winning team and the sum of CS for the losing team.
        return Tuple2(
            PlayerStats.sumByProperty(winTeam, (stats) => stats.totalCS),
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.totalCS));
      default:
        // If an invalid category is provided, return a tuple with 0 for both sums.
        return const Tuple2(0, 0);
    }
  }
}

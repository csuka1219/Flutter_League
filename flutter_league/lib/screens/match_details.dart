import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/playerstats.dart';

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
    String category,
    List<PlayerStats> sortedPlayerStats,
  ) {
    Map<String, Function(PlayerStats)> categoryPropertyMap = {
      'kills': (stats) => stats.kills,
      'gold': (stats) => stats.goldEarned,
      'damageDealt': (stats) => stats.totalDamageDealtToChampions,
      'damageTaken': (stats) => stats.totalDamageTaken,
      'wards': (stats) => stats.wardsPlaced,
      'cs': (stats) => stats.totalCS,
    };

// find the maximum value of data in the list
    int maxData = sortedPlayerStats
        .map((stats) => categoryPropertyMap[category]!(stats))
        .reduce((a, b) => a > b ? a : b);

// calculate the ratio for each data point
    double ratio = 1.0;
    if (maxData != 0) {
      ratio = 1.0 / maxData;
    }
    return ListView.builder(
      itemCount: sortedPlayerStats.length,
      itemBuilder: (BuildContext context, int index) {
        // build the widget
        if (index == 0) {
          return _buildTeamComparisonWidget(category, sortedPlayerStats);
        } else {
          final int playerStatsIndex = index - 1;
          Color color = sortedPlayerStats[playerStatsIndex].win
              ? Colors.blue
              : Colors.red;
          // calculate the data and adder values
          int data;
          switch (category) {
            case 'kills':
              data = sortedPlayerStats[playerStatsIndex].kills;
              break;
            case 'gold':
              data = sortedPlayerStats[playerStatsIndex].goldEarned;
              break;
            case 'damageDealt':
              data = sortedPlayerStats[playerStatsIndex]
                  .totalDamageDealtToChampions;
              break;
            case 'damageTaken':
              data = sortedPlayerStats[playerStatsIndex].totalDamageTaken;
              break;
            case 'wards':
              data = sortedPlayerStats[playerStatsIndex].wardsPlaced;
              break;
            case 'cs':
              data = sortedPlayerStats[playerStatsIndex].totalCS;
              break;
            default:
              data = 0;
          }
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue,
                      width:
                          (sortedPlayerStats[playerStatsIndex].summonerName ==
                                  summonerName)
                              ? 3
                              : 0,
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/champions/${sortedPlayerStats[playerStatsIndex].championName}.png"),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        NumberFormat('#,##0', 'en_US').format(data),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
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
        }
      },
    );
  }

  Widget _buildTeamComparisonWidget(
      String category, List<PlayerStats> sortedPlayerStats) {
    // Replace this with your logic for fetching and processing the data for the two teams
    int team1Data = 0;
    int team2Data = 0;

    var winTeam = sortedPlayerStats.where((stats) => stats.win).toList();
    var loseTeam = sortedPlayerStats.where((stats) => !stats.win).toList();

    switch (category) {
      case 'kills':
        team1Data = PlayerStats.sumByProperty(winTeam, (stats) => stats.kills);
        team2Data = PlayerStats.sumByProperty(loseTeam, (stats) => stats.kills);
        break;
      case 'gold':
        team1Data =
            PlayerStats.sumByProperty(winTeam, (stats) => stats.goldEarned);
        team2Data =
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.goldEarned);
        break;
      case 'damageDealt':
        team1Data = PlayerStats.sumByProperty(
            winTeam, (stats) => stats.totalDamageDealtToChampions);
        team2Data = PlayerStats.sumByProperty(
            loseTeam, (stats) => stats.totalDamageDealtToChampions);
        break;
      case 'damageTaken':
        team1Data = PlayerStats.sumByProperty(
            winTeam, (stats) => stats.totalDamageTaken);
        team2Data = PlayerStats.sumByProperty(
            loseTeam, (stats) => stats.totalDamageTaken);
        break;
      case 'wards':
        team1Data =
            PlayerStats.sumByProperty(winTeam, (stats) => stats.wardsPlaced);
        team2Data =
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.wardsPlaced);
        break;
      case 'cs':
        team1Data =
            PlayerStats.sumByProperty(winTeam, (stats) => stats.totalCS);
        team2Data =
            PlayerStats.sumByProperty(loseTeam, (stats) => stats.totalCS);
        break;
      default:
        team1Data = 0;
        team2Data = 0;
    }

    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTeamDataWidget('Winner', team1Data, Colors.blue),
              SizedBox(width: 16),
              _buildTeamDataWidget('Loser', team2Data, Colors.red),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: team1Data / (team1Data + team2Data),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDataWidget(String teamName, int data, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          teamName,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 8),
        Text(
          NumberFormat('#,##0', 'en_US').format(
              data), // Replace this with the sum of the specified category for the team
          style: TextStyle(
              fontSize: 24, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<PlayerStats> orderByProperty(
      List<PlayerStats> playerStatsList, String property) {
    switch (property) {
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
      default:
        // Sort by gold by default
        playerStatsList.sort((a, b) => b.goldEarned.compareTo(a.goldEarned));
    }

    return playerStatsList;
  }
}

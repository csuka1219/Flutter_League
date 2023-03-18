import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/widgets/match_item.dart';
import 'package:provider/provider.dart';
import '../providers/matchhistory_provider.dart';

//TODO appbar jobb felső sarok kedvencemnek választás
//TODO live game betöltés

class MatchHistoryPage extends StatelessWidget {
  final Summoner summonerInfo;

  const MatchHistoryPage({super.key, required this.summonerInfo});

  @override
  Widget build(BuildContext context) {
    // Determine whether to show solo or flex rank, or neither
    bool startSoloQueue = summonerInfo.soloRank != null ||
        (summonerInfo.soloRank == null && summonerInfo.flexRank == null);

    return Scaffold(
      // Build the app bar
      appBar: _buildAppBar(),
      body: ChangeNotifierProvider(
        // Provide the MatchHistoryData to the widget tree
        create: (_) => MatchHistoryData(startSoloQueue),
        child: Consumer<MatchHistoryData>(
          // Consume the MatchHistoryData from the widget tree
          builder: (context, matchHistoryData, child) {
            if (matchHistoryData.matchHistory.isEmpty) {
              // If the match history is empty, fetch data and show loading indicator
              matchHistoryData.matchNumber = 0;
              matchHistoryData.fetchData(
                  summonerInfo.puuid, summonerInfo.name, false, true);
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // Otherwise, build the column widget
            return Column(
              children: [
                // Show an unranked summoner header if the summoner doesn't have a rank in the selected queue
                ((context.read<MatchHistoryData>().isSoloQueue &&
                            summonerInfo.soloRank == null) ||
                        (!context.read<MatchHistoryData>().isSoloQueue &&
                            summonerInfo.flexRank == null))
                    ? _buildUnrankedSummonerHeader(context)
                    : _buildSummonerHeader(
                        context, context.read<MatchHistoryData>().isSoloQueue),

                SizedBox(
                  height: 10,
                ),

                // Build the match history section
                Expanded(
                    child: RefreshIndicator(
                  // Add the onRefresh callback to fetch new data
                  onRefresh: () async {
                    if (!context.read<MatchHistoryData>().isLoading) {
                      matchHistoryData.isLoading = true;
                      matchHistoryData.matchNumber = 0;
                      matchHistoryData.fetchData(
                          summonerInfo.puuid, summonerInfo.name, false, true);
                      matchHistoryData.isLoading = false;
                    }
                  },
                  child: ListView.builder(
                    // Set the item count to the number of matches + 1
                    itemCount: matchHistoryData.matchHistory.length + 1,
                    // Build the list item for each match or the load more button
                    itemBuilder: (BuildContext context, int index) {
                      if (index != matchHistoryData.matchHistory.length) {
                        return MatchItem(
                          matchHistory: matchHistoryData.matchHistory[index]!,
                          summonerInfo: summonerInfo,
                          matchHistoryData: matchHistoryData,
                        );
                      } else {
                        return _buildLoadMoreButton(context, matchHistoryData);
                      }
                    },
                  ),
                )),
              ],
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: ColorPalette().secondary, //change your color here
      ),
      backgroundColor: ColorPalette().primary,
      title: Text(
        summonerInfo.name,
        style: TextStyle(color: ColorPalette().secondary),
      ),
    );
  }

  // Builds the header widget for the summoner info screen.
  // The isSoloQueue parameter determines whether to display data for solo queue or flex queue.
  Widget _buildSummonerHeader(BuildContext context, bool isSoloQueue) {
    // Get the league points (LP) and win rate based on the queue type
    final lp = isSoloQueue
        ? summonerInfo.soloRank?.leaguePoints // If solo queue, get solo rank LP
        : summonerInfo
            .flexRank?.leaguePoints; // If flex queue, get flex rank LP
    final winRate = getWinrate(isSoloQueue);

    // Get the rank tier, rank (e.g. Platinum IV), based on the queue type
    final rankTier =
        isSoloQueue ? summonerInfo.soloRank?.tier : summonerInfo.flexRank?.tier;
    final rank =
        isSoloQueue ? summonerInfo.soloRank?.rank : summonerInfo.flexRank?.rank;

    // Return the header widget with the summoner rank and LP, win rate, and queue type
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display the rank icon and rank name
          Row(
            children: [
              // Rank icon
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ranks/$rankTier.png"),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rank name (e.g. Platinum IV)
                  Text(
                    '$rankTier $rank',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // LP and win rate (e.g. 95 LP, 60% WR)
                  Text(
                    '$lp LP, $winRate% WR',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Display the queue type (e.g. Solo/Duo or Flex) with an onTap listener to switch between them
          GestureDetector(
            onTap: () {
              context.read<MatchHistoryData>().deniesisSoloQueue();
            },
            child: Text(
              isSoloQueue ? 'Solo/Duo' : 'Flex',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Display the "Live" button (TODO: implement the live game functionality)
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  //TODO: live game - Set the background color based on whether a live game is available or not
                  backgroundColor: !true ? Colors.grey[600] : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                ),
                child: Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnrankedSummonerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rank icon and text
          Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                color: Colors.grey[200],
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rank name
                  Text(
                    "Unranked",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Solo/Duo or Flex
          GestureDetector(
            onTap: () {
              context.read<MatchHistoryData>().deniesisSoloQueue();
            },
            child: Text(
              context.watch<MatchHistoryData>().isSoloQueue
                  ? 'Solo/Duo'
                  : 'Flex',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Refresh and graph buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  //TODO live game
                  backgroundColor: !true ? Colors.grey[600] : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                ),
                child: Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // This method returns a widget that displays either a progress indicator or
// a button to load more data, depending on whether the match history data is
// currently being loaded or not.
  Widget _buildLoadMoreButton(
      BuildContext context, MatchHistoryData matchHistoryData) {
    // The Container widget provides margin around the button or progress
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child:

          // If the match history data is currently being loaded, display a
          context.watch<MatchHistoryData>().isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )

              // If the match history data is not being loaded, display an
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // When the button is pressed, call the fetchData method of
                      // the matchHistoryData object to load more data.
                      matchHistoryData.fetchData(
                          summonerInfo.puuid, summonerInfo.name, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette().primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 12.0),
                    ),
                    child: Text(
                      'Load More',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
    );
  }

  /// Returns a formatted string representing the winrate of the summoner in
  /// either solo queue or flex queue.
  ///
  /// If `isSoloQueue` is true, the method will calculate the winrate based on the
  /// summoner's solo queue rank, otherwise it will calculate based on their flex
  /// queue rank.
  String getWinrate(bool isSoloQueue) {
    // Calculate winrate based on the selected queue type
    double winrate = isSoloQueue
        ? summonerInfo.soloRank!.wins! /
            (summonerInfo.soloRank!.wins! + summonerInfo.soloRank!.losses!)
        : summonerInfo.flexRank!.wins! /
            (summonerInfo.flexRank!.wins! + summonerInfo.flexRank!.losses!);

    // Round the winrate to the nearest integer and convert it to a string
    String winrateString = (winrate * 100).round().toString();

    return winrateString;
  }

  String getKdaAvg(int k, int d, int a) {
    return ((k + a) / d).toStringAsFixed(2);
  }

  // Returns a formatted string for game duration
  String getFormattedDuration(int gameDurationInSeconds) {
    // Convert game duration in seconds to minutes and round down
    int minutes = (gameDurationInSeconds / 60).floor();

    // Calculate remaining seconds and pad with leading zero if necessary
    int seconds = gameDurationInSeconds % 60;
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    // Combine minutes and seconds into formatted string
    return "${minutes}m ${formattedSeconds}s";
  }

// This function maps the queueId to the corresponding game mode name
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

// Return the game mode name for the given queueId
    return gameModes[queueId]!;
  }
}

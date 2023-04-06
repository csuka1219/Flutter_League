import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/live_game.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/providers/home_provider.dart';
import 'package:flutter_riot_api/providers/matchhistoryappbar_provider.dart';
import 'package:flutter_riot_api/screens/live_match.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:flutter_riot_api/utils/sortby_role.dart';
import 'package:flutter_riot_api/widgets/match_item.dart';
import 'package:provider/provider.dart';
import '../providers/matchhistory_provider.dart';

class MatchHistoryPage extends StatelessWidget {
  final Summoner summonerInfo;
  final bool isFavourite;

  const MatchHistoryPage(
      {super.key, required this.summonerInfo, required this.isFavourite});

  @override
  Widget build(BuildContext context) {
    // Determine whether to show solo or flex rank, or neither
    bool startSoloQueue = summonerInfo.soloRank != null ||
        (summonerInfo.soloRank == null && summonerInfo.flexRank == null);

    return Scaffold(
      // Build the app bar
      appBar: _buildAppBar(context, isFavourite),
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
                          //TODO itt volt egy hiba, mikor új meccs kerülne be
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

  AppBar _buildAppBar(BuildContext bContext, bool isFavourite) {
    return AppBar(
      iconTheme: IconThemeData(
        color: ColorPalette().secondary, //change your color here
      ),
      backgroundColor: ColorPalette().primary,
      title: Text(
        summonerInfo.name,
        style: TextStyle(color: ColorPalette().secondary),
      ),
      actions: [
        ChangeNotifierProvider(
          create: (_) => MatchHistoryAppBarIcon(isFavourite),
          child: Consumer<MatchHistoryAppBarIcon>(
            builder: (context, appBarData, child) {
              return IconButton(
                splashRadius: 1,
                color: ColorPalette().secondary,
                icon: Icon(
                  appBarData.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: ColorPalette().secondary,
                ),
                onPressed: () {
                  appBarData.isFavourite
                      ? {
                          appBarData.deleteSummoner(summonerInfo),
                          bContext
                              .read<HomeProvider>()
                              .removeSummoner(summonerInfo)
                        }
                      : {
                          appBarData.saveSummoners(summonerInfo),
                          bContext
                              .read<HomeProvider>()
                              .addSummoner(summonerInfo)
                        };
                  appBarData.isFavourite = !appBarData.isFavourite;
                },
              );
            },
          ),
        ),
      ],
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
    final winRate = getWinrate(isSoloQueue, summonerInfo);

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
                onPressed: () async {
                  LiveGame? liveGame = await context
                      .read<MatchHistoryData>()
                      .fetchLiveGameData(summonerInfo.id);
                  if (liveGame == null) return;

                  sortByRole(liveGame.participants);

                  if (liveGame != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveGamePage(
                          liveGameData: liveGame,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  //TODO: live game - Set the background color based on whether a live game is available or not
                  backgroundColor: !true ? Colors.grey[600] : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                ),
                child: context.watch<MatchHistoryData>().isSearchingLiveGame
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
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
}

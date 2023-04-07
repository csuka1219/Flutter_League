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
  static final ColorPalette colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    // Determine whether to show solo or flex rank, or neither
    final startSoloQueue = summonerInfo.soloRank != null ||
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
            if (matchHistoryData.isInitialLoading) {
              // If the match history is empty, fetch data and show loading indicator
              matchHistoryData.matchNumber = 0;
              matchHistoryData.fetchData(
                  summonerInfo.puuid, summonerInfo.name, false, true);
              return const Center(child: CircularProgressIndicator());
            }

            // Otherwise, build the column widget
            return Column(
              children: [
                // Show an unranked summoner header if the summoner doesn't have a rank in the selected queue
                (matchHistoryData.isSoloQueue &&
                            summonerInfo.soloRank == null) ||
                        (!matchHistoryData.isSoloQueue &&
                            summonerInfo.flexRank == null)
                    ? _buildUnrankedSummonerHeader(context)
                    : _buildSummonerHeader(
                        context, matchHistoryData.isSoloQueue),
                const SizedBox(height: 10),
                // Build the match history section
                Expanded(
                  child: RefreshIndicator(
                    // Add the onRefresh callback to fetch new data
                    onRefresh: () async {
                      if (!matchHistoryData.isLoading) {
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
                      itemBuilder: (context, index) {
                        if (index != matchHistoryData.matchHistory.length) {
                          return MatchItem(
                            matchHistory: matchHistoryData.matchHistory[index]!,
                            summonerInfo: summonerInfo,
                            matchHistoryData: matchHistoryData,
                          );
                        } else {
                          return _buildLoadMoreButton(
                              context, matchHistoryData);
                        }
                      },
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

  PreferredSize _buildAppBar(BuildContext bContext, bool isFavourite) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        iconTheme: IconThemeData(
          color: colorPalette.secondary,
        ),
        backgroundColor: colorPalette.primary,
        title: Text(
          summonerInfo.name,
          style: TextStyle(color: colorPalette.secondary),
        ),
        actions: [
          ChangeNotifierProvider(
            create: (_) => MatchHistoryAppBarIcon(isFavourite),
            child: Consumer<MatchHistoryAppBarIcon>(
              builder: (context, appBarData, child) {
                return IconButton(
                  splashRadius: 1,
                  color: colorPalette.secondary,
                  icon: Icon(
                    appBarData.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: colorPalette.secondary,
                  ),
                  onPressed: () {
                    _toggleFavourite(appBarData, summonerInfo, bContext);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavourite(MatchHistoryAppBarIcon appBarData,
      Summoner summonerInfo, BuildContext context) {
    bool isFavourite = !appBarData.isFavourite;
    if (isFavourite) {
      appBarData.saveSummoners(summonerInfo);
      Provider.of<HomeProvider>(context, listen: false)
          .addSummoner(summonerInfo);
    } else {
      appBarData.deleteSummoner(summonerInfo);
      Provider.of<HomeProvider>(context, listen: false)
          .removeSummoner(summonerInfo);
    }
    appBarData.isFavourite = isFavourite;
  }

  Widget _buildSummonerHeader(BuildContext context, bool isSoloQueue) {
    final rankInfo =
        isSoloQueue ? summonerInfo.soloRank! : summonerInfo.flexRank!;
    final rankTier = rankInfo.tier!;
    final rank = rankInfo.rank!;
    final leaguePoints = rankInfo.leaguePoints!;
    final winRate = getWinrate(isSoloQueue, summonerInfo);

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRankInfo(rankTier, rank, leaguePoints, winRate),
          _buildQueueType(isSoloQueue, context),
          _buildLiveButton(context),
        ],
      ),
    );
  }

  Widget _buildRankInfo(
      String rankTier, String rank, int leaguePoints, String winRate) {
    return Row(
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/ranks/$rankTier.png"),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$rankTier $rank',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '$leaguePoints LP, $winRate% WR',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQueueType(bool isSoloQueue, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MatchHistoryData>().toggleSoloQueue();
      },
      child: Text(
        isSoloQueue ? 'Solo/Duo' : 'Flex',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildLiveButton(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final liveGame = await context
                .read<MatchHistoryData>()
                .fetchLiveGameData(summonerInfo.id);
            if (liveGame == null) return;

            sortByRole(liveGame.participants);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveGamePage(
                  liveGameData: liveGame,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPalette.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          child: const Text(
            'Live',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnrankedSummonerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
              context.read<MatchHistoryData>().toggleSoloQueue();
            },
            child: Text(
              context.watch<MatchHistoryData>().isSoloQueue
                  ? 'Solo/Duo'
                  : 'Flex',
              style: const TextStyle(
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
                  backgroundColor: colorPalette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                ),
                child: const Text(
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

  Widget _buildLoadMoreButton(
      BuildContext context, MatchHistoryData matchHistoryData) {
    // Add margin around the button or progress
    const margin = EdgeInsets.symmetric(vertical: 12.0);

    if (context.watch<MatchHistoryData>().isLoading) {
      // If match history data is currently being loaded, show a progress indicator
      return Container(
        margin: margin,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // If match history data is not being loaded, show a "Load More" button
      return Container(
        margin: margin,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // When the button is pressed, call fetchData method to load more data
              matchHistoryData.fetchData(
                  summonerInfo.puuid, summonerInfo.name, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette().primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
            ),
            child: const Text(
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
}

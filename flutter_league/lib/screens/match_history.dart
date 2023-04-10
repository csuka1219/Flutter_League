import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/model/summoner_server.dart';
import 'package:flutter_riot_api/providers/home_provider.dart';
import 'package:flutter_riot_api/providers/matchhistoryappbar_provider.dart';
import 'package:flutter_riot_api/screens/live_match.dart';
import 'package:flutter_riot_api/utils/config.dart';
import 'package:flutter_riot_api/utils/riotdata_formatter.dart';
import 'package:flutter_riot_api/utils/sortby_role.dart';
import 'package:flutter_riot_api/widgets/match_item.dart';
import 'package:provider/provider.dart';
import '../providers/matchhistory_provider.dart';

class MatchHistoryPage extends StatelessWidget {
  final Summoner summonerInfo;
  final bool isFavourite;
  final String? serverId;

  const MatchHistoryPage(
      {super.key,
      required this.summonerInfo,
      required this.isFavourite,
      this.serverId});
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
                  summonerInfo.puuid, summonerInfo.name, false, true, serverId);
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
                        matchHistoryData.fetchData(summonerInfo.puuid,
                            summonerInfo.name, false, true, serverId);
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
                            serverId: serverId,
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

  /// This method returns a PreferredSize widget, which is used to set the size of the AppBar.
  PreferredSize _buildAppBar(BuildContext bContext, bool isFavourite) {
    return PreferredSize(
      // This sets the preferred size of the AppBar to a constant height.
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        // This sets the color of the back button and any other icons in the AppBar.
        iconTheme: IconThemeData(
          color: colorPalette.secondary,
        ),
        // This sets the background color of the AppBar.
        backgroundColor: colorPalette.primary,
        // This sets the title of the AppBar to the summoner's name.
        title: Text(
          summonerInfo.name,
          style: TextStyle(color: colorPalette.secondary),
        ),
        // This adds an icon button to the right side of the AppBar.
        actions: [
          // This creates a ChangeNotifierProvider for the MatchHistoryAppBarIcon.
          ChangeNotifierProvider(
            create: (_) => MatchHistoryAppBarIcon(isFavourite),
            child: Consumer<MatchHistoryAppBarIcon>(
              builder: (context, appBarData, child) {
                // This returns an IconButton that toggles the favourite status when pressed.
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

  /// This function toggles the favourite status of the summoner represented by the given MatchHistoryAppBarIcon.
  void _toggleFavourite(MatchHistoryAppBarIcon appBarData,
      Summoner summonerInfo, BuildContext context) {
    bool isFavourite = !appBarData.isFavourite; // Toggle the favourite status.
    if (isFavourite) {
      // If the summoner is now a favourite, add them to the home provider and to the list of favourite summoners in the MatchHistoryAppBarIcon.
      appBarData.saveSummoners(summonerInfo, serverId);
      Provider.of<HomeProvider>(context, listen: false)
          .addSummoner(summonerInfo);
      Provider.of<HomeProvider>(context, listen: false).summonerServers.add(
            SummonerServer(
              puuid: summonerInfo.puuid,
              server: serverId ?? Config.currentServer,
            ),
          );
    } else {
      // If the summoner is no longer a favourite, remove them from the home provider and from the list of favourite summoners in the MatchHistoryAppBarIcon.
      appBarData.deleteSummoner(summonerInfo);
      Provider.of<HomeProvider>(context, listen: false)
          .removeSummoner(summonerInfo);
      // If a server ID was provided, also remove the summoner from the list of summoners for that server.
      serverId != null
          ? Provider.of<HomeProvider>(context, listen: false)
              .summonerServers
              .removeWhere(
                ((element) => element.puuid == summonerInfo.puuid),
              )
          : null;
    }
    // Update the favourite status in the MatchHistoryAppBarIcon.
    appBarData.isFavourite = isFavourite;
  }

  /// This function returns a widget that displays information about the summoner's rank, league points, and win rate.
  Widget _buildSummonerHeader(BuildContext context, bool isSoloQueue) {
    // Get the rank information for the appropriate queue type.
    final rankInfo =
        isSoloQueue ? summonerInfo.soloRank! : summonerInfo.flexRank!;
    final rankTier = rankInfo.tier!;
    final rank = rankInfo.rank!;
    final leaguePoints = rankInfo.leaguePoints!;
    final winRate = getWinrate(
        isSoloQueue, summonerInfo); // Calculate the summoner's win rate.

    // Build a container containing the rank information, queue type, and live button.
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRankInfo(rankTier, rank, leaguePoints,
              winRate), // Display the rank information.
          _buildQueueType(isSoloQueue, context), // Display the queue type.
          _buildLiveButton(context), // Display the live button.
        ],
      ),
    );
  }

  Widget _buildRankInfo(
      String rankTier, String rank, int leaguePoints, String winRate) {
    return Row(
      children: [
        // Widget to display the rank emblem
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
            // Widget to display the rank and tier of the user
            Text(
              '$rankTier $rank',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Widget to display the user's league points and win rate
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
        // Toggle the queue type when tapped
        context.read<MatchHistoryData>().toggleSoloQueue();
      },
      child: Text(
        isSoloQueue ? 'Solo/Duo' : 'Flex', // Display the current queue type
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  /// Builds a button that allows the user to navigate to the live game page for the
  /// current summoner. When pressed, this button fetches the live game data for the
  /// summoner and navigates to the `LiveGamePage` with the fetched data.
  Widget _buildLiveButton(BuildContext context) {
    return Row(
      children: [
        // The ElevatedButton widget
        ElevatedButton(
          // When the button is pressed
          onPressed: () async {
            // Fetch live game data using the summoner ID and server ID from the context's MatchHistoryData object
            final liveGame = await context
                .read<MatchHistoryData>()
                .fetchLiveGameData(summonerInfo.id, serverId);
            // If live game data is null, return
            if (liveGame == null) return;

            // Sort the participants by role
            sortByRole(liveGame.participants);

            // Navigate to the LiveGamePage passing in live game data and server ID
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveGamePage(
                  liveGameData: liveGame,
                  serverId: serverId,
                ),
              ),
            );
          },
          // Button styling
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPalette.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          // Button text
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

  /// This function returns a header widget for an unranked summoner.
  Widget _buildUnrankedSummonerHeader(BuildContext context) {
    return Container(
      // Add padding and background color to the container
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        // Align children in the main axis with space in between
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rank icon and text
          Row(
            children: [
              // Add a gray box as a placeholder for the rank icon
              Container(
                width: 32.0,
                height: 32.0,
                color: Colors.grey[200],
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Add text for the rank name
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

          // Solo/Duo or Flex text that toggles when tapped
          GestureDetector(
            onTap: () {
              // Toggle between Solo/Duo and Flex using the MatchHistoryData provider
              context.read<MatchHistoryData>().toggleSoloQueue();
            },
            child: Text(
              // Show the current mode based on the isSoloQueue boolean in the MatchHistoryData provider
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

          // Live button
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPalette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 6.0),
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

  /// This widget builds a "Load More" button that loads additional match history data
  Widget _buildLoadMoreButton(
      BuildContext context, MatchHistoryData matchHistoryData) {
    // Define a constant margin for the button or progress widget
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
                  summonerInfo.puuid, summonerInfo.name, true, false, serverId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPalette.primary,
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

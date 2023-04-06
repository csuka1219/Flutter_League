import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/screens/live_match.dart';
import 'package:flutter_riot_api/services/matchinfo_service.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';

import '../services/pulldata.dart';
import '../utils/roleidentification.dart';

class SummonerInfo extends StatelessWidget {
  final Summoner summonerInfo;
  const SummonerInfo({super.key, required this.summonerInfo});

  @override
  Widget build(BuildContext context) {
    // Determine if solo queue rank should be shown or not
    bool showSoloQueue = summonerInfo.soloRank != null ||
        (summonerInfo.soloRank == null && summonerInfo.flexRank == null);

    // Determine if the summoner is unranked
    bool unranked = (showSoloQueue && summonerInfo.soloRank == null) ||
        (!showSoloQueue && summonerInfo.flexRank == null);

    // Get the screen width
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.03),
            spreadRadius: 10,
            blurRadius: 3,
            // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 25, right: 20, left: 20),
        child: InkWell(
          onTap: () async {
            // Navigate to the match history page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchHistoryPage(
                  summonerInfo: summonerInfo,
                  isFavourite: true,
                ),
              ),
            );
          },
          child: Column(
            children: [
              // Display the refresh and delete icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBoxIcon(Icons.refresh_outlined), //TODO
                  _buildBoxIcon(Icons.delete), //TODO
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  // Display the summoner's icon
                  _buildsummonerIcon(summonerInfo),
                  const SizedBox(
                    height: 10,
                  ),
                  // Display the summoner's base information
                  _buildSummonerBaseInfo(
                    width,
                    summonerInfo,
                    showSoloQueue,
                    unranked,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Display the summoner's ranked stats
              _buildRankedStats(summonerInfo, showSoloQueue),
            ],
          ),
        ),
      ),
    );
  }

  // This widget builds the summoner icon and level badge
  Widget _buildsummonerIcon(Summoner summonerInfo) {
    return Stack(
      children: [
        // The container is a circular shape and contains the summoner icon image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  // This line of code sets the URL for the summoner icon image
                  image: NetworkImage(
                      "https://ddragon.leagueoflegends.com/cdn/13.7.1/img/profileicon/${summonerInfo.profileIconId}.png"),
                  fit: BoxFit.cover)),
        ),
        // The position of the badge is set to the bottom of the container
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            // This container contains the level badge and is positioned at the bottom of the summoner icon
            child: Container(
              height: 15,
              width: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // The color of the badge is set using a custom color palette
                color: ColorPalette().primary,
              ),
              // The summoner level is displayed in white text within the badge
              child: Text(
                "${summonerInfo.summonerLevel}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummonerBaseInfo(
      double width, Summoner summonerInfo, bool showSoloQueue, bool unranked) {
    // define the width of the widget as 60% of the available width
    double widgetWidth = (width - 40) * 0.6;

    // return a SizedBox widget with the defined width, containing a Column
    return SizedBox(
      width: widgetWidth,
      child: Column(
        children: [
          // display the summoner's name
          Text(
            summonerInfo.name,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          // display the rank details for the summoner
          _buildRankDetails(showSoloQueue, unranked),
        ],
      ),
    );
  }

  Row _buildRankDetails(bool showSoloQueue, bool unranked) {
    // Get the LP, tier, and rank based on the queue type
    final leaguePoints = showSoloQueue
        ? summonerInfo.soloRank?.leaguePoints
        : summonerInfo.flexRank?.leaguePoints;
    final tier = showSoloQueue
        ? summonerInfo.soloRank?.tier
        : summonerInfo.flexRank?.tier;
    final rank = showSoloQueue
        ? summonerInfo.soloRank?.rank
        : summonerInfo.flexRank?.rank;

    return unranked
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Unranked",
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display rank image
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ranks/$tier.png"),
                  ),
                ),
              ),
              // Display rank details
              Text(
                "$tier $rank $leaguePoints LP",
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          );
  }

  Widget _buildRankedStats(Summoner summonerInfo, bool showSoloQueue) {
    // Initialize the win rate to "-" and get the appropriate rank based on the queue type
    String winRate = "-";
    Rank? rank = showSoloQueue ? summonerInfo.soloRank : summonerInfo.flexRank;

    // If the summoner is unranked in the selected queue, set the rank to 0 wins and 0 losses
    if (rank == null) {
      rank = Rank(wins: 0, losses: 0);
    } else {
      // If the summoner is ranked, calculate their win rate
      winRate = getWinrate(showSoloQueue, summonerInfo);
    }

    // Build the row containing the win/loss record and win rate
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${rank.wins}W",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
        ),
        const Text(
          "/",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        Text(
          "${rank.losses}L",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 0.5,
          height: 40,
          color: Colors.black.withOpacity(0.3),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Row(
              children: [
                const Text(
                  "Winrate ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Text(
                  "$winRate%",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      // Set the color of the win rate based on whether it's above or below 50%
                      color: winRate != "-"
                          ? (int.parse(winRate) >= 50)
                              ? Colors.green
                              : Colors.red
                          : Colors.black),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Returns a circular material widget with an icon inside it.
  Widget _buildBoxIcon(IconData icon) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: () => {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: ColorPalette().primary),
        ),
      ),
    );
  }
}

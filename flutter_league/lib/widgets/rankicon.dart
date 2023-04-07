import 'package:flutter/material.dart';
import 'package:flutter_riot_api/model/summoner.dart';

class RankIcon extends StatelessWidget {
  final Summoner summonerInfo; // Summoner object containing rank information
  final int
      queueId; // ID of the queue (e.g. 420 for solo queue, 440 for flex queue)

  const RankIcon({Key? key, required this.summonerInfo, required this.queueId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? tier; // The tier of the player's rank, initially null
    if (queueId == 420) {
      // If queueId is for solo queue
      tier = summonerInfo
          .soloRank?.tier; // Set tier to solo queue tier (if available)
    } else if (queueId == 440) {
      // If queueId is for flex queue
      tier = summonerInfo
          .flexRank?.tier; // Set tier to flex queue tier (if available)
    }
    tier ??= summonerInfo.soloRank?.tier ?? summonerInfo.flexRank?.tier;

    return _buildRankIcon(
        tier); // Return the container with the rank icon based on the computed tier
  }

  // Builds the container with the rank icon
  Widget _buildRankIcon(String? tier) {
    if (tier != null) {
      // If tier is not null
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/ranks/$tier.png"),
          ),
        ),
      );
    }
    // If tier is null, return an empty container with no width and height
    return const SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }
}

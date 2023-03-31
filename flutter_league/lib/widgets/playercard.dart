import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final Color teamColor;
  final String summonerName;
  final String championImageUrl;
  final String kda;
  final String winRate;
  final String rank;
  final String rankIconUrl;
  final List<String> spells;
  final List<String> runes;

  const PlayerCard({
    Key? key,
    required this.teamColor,
    required this.summonerName,
    required this.championImageUrl,
    required this.kda,
    required this.winRate,
    required this.rank,
    required this.rankIconUrl,
    required this.spells,
    required this.runes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(championImageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              summonerName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "championName",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              'KDA: $kda',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

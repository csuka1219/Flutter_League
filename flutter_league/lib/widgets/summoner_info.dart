import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/screens/live_match.dart';
import 'package:flutter_riot_api/services/matchinfo_service.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';

import '../utils/pulldata.dart';
import '../utils/roleidentification.dart';

class SummonerInfo extends StatelessWidget {
  final Summoner summonerInfo;
  const SummonerInfo({super.key, required this.summonerInfo});

  @override
  Widget build(BuildContext context) {
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
          ]),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 25, right: 20, left: 20),
        child: InkWell(
          onTap: () async {
            // var champion_roles = await pullData();
            // List<int> champions = [145, 122, 90, 412, 121];
            // var roles = getPositions(champion_roles, champions);
            // int b = 0;
            //List<int> champions = [145, 122, 90, 412, 121]; ['Kai'Sa', 'Darius', 'Malzahar', 'Thresh', 'Kha'Zix']
            Summoner? summoner = await getSummonerByName(
              summonerInfo.name,
            );
            if (summonerInfo == null) return; //TODO nem létező summoner
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MatchHistoryPage(
                        summonerInfo: summonerInfo,
                        isFavourite: true,
                      )),
            );
          },
          child: Column(
            children: [
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
                  _buildsummonerIcon(summonerInfo), //TODO
                  const SizedBox(
                    height: 10,
                  ),
                  _buildSummonerBaseInfo(width, summonerInfo),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _buildMatchStats(summonerInfo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildsummonerIcon(Summoner summonerInfo) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      "https://ddragon.leagueoflegends.com/cdn/13.6.1/img/profileicon/${summonerInfo.profileIconId}.png"),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 15,
              width: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: ColorPalette().primary,
              ),
              child: Text(
                "${summonerInfo.summonerLevel}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummonerBaseInfo(double width, Summoner summonerInfo) {
    return Container(
      width: (width - 40) * 0.6,
      child: Column(
        children: [
          Text(
            summonerInfo.name,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          //icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/ranks/${summonerInfo.soloRank!.tier}.png"),
                  ),
                ),
              ),
              Text(
                //TODO
                "${summonerInfo.soloRank!.tier} ${summonerInfo.soloRank!.rank} ${summonerInfo.soloRank!.leaguePoints} LP",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStats(Summoner summonerInfo) {
    final winRate = getWinrate(true, summonerInfo);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${summonerInfo.soloRank!.wins}W",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
        ),
        Text(
          "/",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        Text(
          "${summonerInfo.soloRank!.losses}L",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 0.5,
          height: 40,
          color: Colors.black.withOpacity(0.3),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Winrate ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Text(
                  "${winRate}%",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: (int.parse(winRate) >= 50)
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

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

String getWinrate(bool isSoloQueue, Summoner summonerInfo) {
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

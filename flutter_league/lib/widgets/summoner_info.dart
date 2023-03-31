import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/screens/ongoing_match.dart';
import 'package:flutter_riot_api/services/matchinfo_service.dart';

class SummonerInfo extends StatelessWidget {
  const SummonerInfo({super.key});

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
          onTap: () => {
            //TODO
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnGoingMatchPage()),
            ),
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBoxIcon(Icons.refresh_outlined),
                  _buildBoxIcon(Icons.delete),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  _buildsummonerIcon(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildSummonerBaseInfo(width),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              _buildMatchStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildsummonerIcon() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      "https://opgg-static.akamaized.net/images/profile_icons/profileIcon5484.jpg?image=q_auto,f_webp,w_auto&v=1678078753492"),
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
                "{lvl}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummonerBaseInfo(double width) {
    return Container(
      width: (width - 40) * 0.6,
      child: Column(
        children: [
          Text(
            "{summoner name}",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "{rank} {tier} {rankicon} {lp}",
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "{W/L}",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        Container(
          width: 0.5,
          height: 40,
          color: Colors.black.withOpacity(0.3),
        ),
        Column(
          children: [
            Text(
              "{Winrate}",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ),
        Container(
          width: 0.5,
          height: 40,
          color: Colors.black.withOpacity(0.3),
        ),
        Column(
          children: [
            Text(
              "{champ} {Winrate}",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
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

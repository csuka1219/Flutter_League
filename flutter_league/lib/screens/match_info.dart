import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/screens/match_details.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchInfoPage extends StatelessWidget {
  const MatchInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green[400]),
        //backgroundColor: Colors.green[400],
        backgroundColor: ColorPalette().primary,
        title: Text(
          "Match Info",
          style: TextStyle(color: Colors.green[400]),
        ),
        actions: [
          IconButton(
            color: ColorPalette().secondary,
            icon: Icon(
              Icons.bar_chart,
              color: Colors.green[400],
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MatchDetailsPage()),
              ),
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              color: true ? ColorPalette().primary : Colors.red[400],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    true ? "Victory" : "Defeat",
                    style: TextStyle(
                      color: Colors.green[400],
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule,
                          color: Colors.green[400], size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        "Normal - 15:27",
                        style: TextStyle(
                          color: Colors.green[400],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //SizedBox(height: 16.0),
          SizedBox(height: 8.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(
                    color: Colors.blue,
                    thickness: 1.0,
                  ),
                  _buildTeamHeader(
                      "WINNER (BLUE)", 32, 16, 44, 10, 3, 1, Colors.blue),
                  SizedBox(height: 10),
                  _buildPlayerList(),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.red,
                    thickness: 1,
                  ),
                  _buildTeamHeader(
                      "LOSER (RED)", 16, 32, 22, 5, 2, 0, Colors.red),
                  SizedBox(height: 10),
                  _buildPlayerList(),
                  SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList() {
    double lineWidth = 0;
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
          thickness: 1.0,
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        (index == 3) ? lineWidth = 2 : lineWidth = 0;
        //Player player = players[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          margin: EdgeInsets.only(bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue,
                    width: lineWidth,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://opgg-static.akamaized.net/meta/images/lol/champion/Kaisa.png?image=c_crop,h_103,w_103,x_9,y_9/q_auto,f_webp,w_96&v=1678078753492",
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //TODO max length
                        Text(
                          "NusyBerry",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8),
                        Row(
                          children: [
                            RankIcon(),
                            SizedBox(width: 4),
                            Text(
                              'Gold 2',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://opgg-static.akamaized.net/meta/images/lol/spell/SummonerFlash.png?image=q_auto,f_webp,w_44&v=1678078753492",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.5),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://opgg-static.akamaized.net/meta/images/lol/spell/SummonerExhaust.png?image=q_auto,f_webp,w_44&v=1678078753492",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.5),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette().primary,
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://opgg-static.akamaized.net/meta/images/lol/perk/8008.png?image=q_auto,f_webp,w_44&v=1678078753492",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.5),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://opgg-static.akamaized.net/meta/images/lol/perkStyle/8300.png?image=q_auto,f_webp,w_44&v=1678078753492",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "120 CS(6.1)",
                        style: TextStyle(fontSize: 9),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "4 / ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "2",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " / 4",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildItemsRow(),
                      _buildItemsRow(),
                      _buildItemsRow(),
                      _buildItemsRow(),
                      _buildItemsRow(),
                      _buildItemsRow(),
                      Container(
                        width: 18.0,
                        height: 18.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://opgg-static.akamaized.net/meta/images/lol/item/3363.png?image=q_auto,f_webp,w_44&v=1678078753492"),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamHeader(String teamName, int kills, int deaths, int assists,
      int turrets, int dragons, int barons, Color color) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        //color: true ? Colors.green[400] : Colors.red[400],
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              teamName,
              style: TextStyle(
                color: color,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0, width: 10),
            SizedBox(width: 8.0),
            Row(
              children: [
                SvgPicture.network(
                  'https://s-lol-web.op.gg/images/icon/icon-tower.svg?v=1678413225229',
                  height: 16,
                  width: 16,
                ),
                Text(
                  " $turrets",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.0),
            Row(
              children: [
                SvgPicture.network(
                  'https://s-lol-web.op.gg/images/icon/icon-dragon.svg?v=1678413225229',
                  height: 16,
                  width: 16,
                ),
                Text(
                  " $dragons",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.0),
            Row(
              children: [
                SvgPicture.network(
                  'https://s-lol-web.op.gg/images/icon/icon-dragon.svg?v=1678413225229',
                  height: 16,
                  width: 16,
                ),
                Text(
                  " $barons",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              "$kills / ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$deaths",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " / $assists",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsRow() {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(
              "https://opgg-static.akamaized.net/meta/images/lol/item/6671.png?image=q_auto,f_webp,w_44&v=1678078753492"),
        ),
      ),
    );
  }

  Widget _buildDamageDealtBar(int damageDealt, int maxDamageDealt) {
    final double barWidth = 100;
    final double barHeight = 10;
    final double barValue = damageDealt.toDouble() / maxDamageDealt.toDouble();
    final double filledWidth = barWidth * barValue;

    return Container(
      height: barHeight,
      width: barWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(barHeight),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: barHeight,
          width: filledWidth,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(barHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildDamageDealtBar2(int damageDealt, int maxDamageDealt) {
    final double barWidth = 10;
    final double barHeight = 40;
    final double barValue = damageDealt.toDouble() / maxDamageDealt.toDouble();
    final double filledWidth = barHeight * barValue;

    return Container(
      height: barHeight,
      width: barWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(barHeight),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: filledWidth,
          width: barWidth,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(barHeight),
          ),
        ),
      ),
    );
  }
}

class RankIcon extends StatelessWidget {
  const RankIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://opgg-static.akamaized.net/images/medals_new/gold.png?image=q_auto,f_webp,w_144&v=1678078753677"))),
    );
  }
}

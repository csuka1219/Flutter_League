import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';

class MatchInfoPage extends StatelessWidget {
  const MatchInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Match Info"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh match info
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              // Navigate to match graphs page
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
              color: true ? Colors.green[400] : Colors.red[400],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    true ? "Victory" : "Defeat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule, color: Colors.white, size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        "{gameMode} - {gameDuration}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            "Players",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Blue Team",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPlayerList(),
              SizedBox(height: 20),
              Text(
                "Red Team",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPlayerList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        //Player player = players[index];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                    Text(
                      "{Name} {player.rank}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://opgg-static.akamaized.net/meta/images/lol/spell/SummonerFlash.png?image=q_auto,f_webp,w_44&v=1678078753492",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://opgg-static.akamaized.net/meta/images/lol/spell/SummonerFlash.png?image=q_auto,f_webp,w_44&v=1678078753492",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 20,
                          height: 20,
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
                        SizedBox(width: 5),
                        Text("runes"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "{4}/{2}/{4}",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    ],
                  ),
                  SizedBox(height: 5),
                  _buildDamageDealtBar(60, 100),
                  SizedBox(height: 5),
                  Text("{30} CS"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemsRow() {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
}

class RankIcon extends StatelessWidget {
  const RankIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://opgg-static.akamaized.net/images/medals_new/gold.png?image=q_auto,f_webp,w_144&v=1678078753677"))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';

class SummonerDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorPalette().secondary, //change your color here
        ),
        backgroundColor: ColorPalette().primary,
        title: Text(
          'Summoner Details',
          style: TextStyle(color: ColorPalette().secondary),
        ),
      ),
      body: Column(
        children: [
          // Header section
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Rank icon
                    Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://opgg-static.akamaized.net/images/medals_new/gold.png?image=q_auto,f_webp,w_144&v=1678078753677"))),
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rank name
                        Text(
                          'Gold II',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // LP and winrate
                        Text(
                          '54 LP, 60% WR',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Solo/Duo or Flex
                Text(
                  'Solo/Duo',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Refresh and graph buttons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.graphic_eq),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Match history section
          Expanded(
            child: ListView.builder(
              itemCount: 10, // TODO: Replace with actual match history data
              itemBuilder: (BuildContext context, int index) {
                return _test2();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _test2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color.fromARGB(255, 190, 226, 255),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Champion icon
            Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://opgg-static.akamaized.net/meta/images/lol/champion/Kaisa.png?image=c_crop,h_103,w_103,x_9,y_9/q_auto,f_webp,w_96&v=1678078753492",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                // Summoner spells
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://opgg-static.akamaized.net/meta/images/lol/spell/SummonerFlash.png?image=q_auto,f_webp,w_44&v=1678078753492",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://opgg-static.akamaized.net/meta/images/lol/spell/SummonerExhaust.png?image=q_auto,f_webp,w_44&v=1678078753492",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game mode and match length
                Text(
                  "{gameMode} - {matchLength}",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                // KDA
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '{K}/{D}/{A} {avg}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Match items
                Row(
                  children: [
                    for (var i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://opgg-static.akamaized.net/meta/images/lol/item/6671.png?image=q_auto,f_webp,w_44&v=1678078753492"),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://opgg-static.akamaized.net/meta/images/lol/item/3363.png?image=q_auto,f_webp,w_44&v=1678078753492"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            // Rune pages
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 32,
                  height: 32,
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
                SizedBox(height: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
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
    );
  }
}

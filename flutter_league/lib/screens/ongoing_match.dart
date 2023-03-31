import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';

import '../widgets/playercard.dart';

class OnGoingMatchPage extends StatelessWidget {
  const OnGoingMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Match Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'Team Blue',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          playerCard(
            playerImageUrl:
                'https://opgg-static.akamaized.net/meta/images/lol/champion/Veigar.png?image=c_crop,h_103,w_103,x_9,y_9/q_auto,f_webp,w_96&v=1679644970497',
            playerName: 'Player 1',
            championName: 'Jinx',
            kda: '2/1/3',
          ),
          playerCard(
            playerImageUrl:
                'https://opgg-static.akamaized.net/meta/images/lol/champion/Veigar.png?image=c_crop,h_103,w_103,x_9,y_9/q_auto,f_webp,w_96&v=1679644970497',
            playerName: 'Player 1',
            championName: 'Jinx',
            kda: '2/1/3',
          ),
          playerCard(
            playerImageUrl:
                'https://opgg-static.akamaized.net/meta/images/lol/champion/Veigar.png?image=c_crop,h_103,w_103,x_9,y_9/q_auto,f_webp,w_96&v=1679644970497',
            playerName: 'Player 1',
            championName: 'Jinx',
            kda: '2/1/3',
          ),
          playerCard(
            playerImageUrl:
                'https://opgg-static.akamaized.net/meta/images/lol/champion/Veigar.png?image=c_crop,h_103,w_103,x_9,y_9/q_auto,f_webp,w_96&v=1679644970497',
            playerName: 'Player 1',
            championName: 'Jinx',
            kda: '2/1/3',
          ),
          playerCard(
            playerImageUrl:
                'https://opgg-static.akamaized.net/meta/images/lol/champion/Veigar.png?image=c_crop,h_103,w_103,x_9,y_9/q_auto,f_webp,w_96&v=1679644970497',
            playerName: 'Player 1',
            championName: 'Jinx',
            kda: '2/1/3',
          ),
        ],
      ),
    );
  }

  Widget playerCard({
    required String playerImageUrl,
    required String playerName,
    required String championName,
    required String kda,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage("assets/champions/Kaisa.png"),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(4),
                              SizedBox(
                                height: 2.5,
                              ),
                              _buildRune(8005)
                            ],
                          ),
                          SizedBox(
                            width: 2.5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(3),
                              SizedBox(
                                height: 2.5,
                              ),
                              _buildRune(8005)
                            ],
                          ),
                          SizedBox(
                            width: 8.5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "10 Games",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[600]),
                              ),
                              Text("55%",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text("Gold 3",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[600]))
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/roles/TOP.png"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "10 Games",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[600]),
                              ),
                              Text("55%",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text("Gold 3",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[600]))
                            ],
                          ),
                          SizedBox(
                            width: 8.5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(4),
                              _buildRune(8005)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildSummonerSpell(3),
                              _buildRune(8005)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage("assets/champions/Kaisa.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 22.0,
                                height: 22.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/ranks/GOLD.png"),
                                  ),
                                ),
                              ),
                              Text(
                                "${playerName.length < 15 ? playerName : playerName.substring(0, 10) + '...'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'VS',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${playerName.length < 15 ? playerName : playerName.substring(0, 10) + '...'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                width: 22.0,
                                height: 22.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/ranks/GOLD.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Container _buildSummonerSpell(int summonerId) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      image: DecorationImage(
        image: AssetImage("assets/spells/$summonerId.png"),
      ),
    ),
  );
}

Container _buildRune(int runeId) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: ColorPalette().primary,
      image: DecorationImage(
        image: AssetImage("assets/runes/$runeId.png"),
      ),
    ),
  );
}

Widget _buildPlayerRow() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/champions/Kaisa.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '{matches} Matches, {winRate} Winrate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "summonerName",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette().primary,
                              image: DecorationImage(
                                image: AssetImage("assets/runes/8005.png"),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette().primary,
                              image: DecorationImage(
                                image: AssetImage("assets/runes/8005.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'VS',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("assets/champions/Kaisa.png"),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '{1}/{1}/{1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/ranks/GOLD.png"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: AssetImage("assets/spells/3.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: AssetImage("assets/spells/3.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

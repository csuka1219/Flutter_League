import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';

class MatchDetailsPage extends StatefulWidget {
  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorPalette().secondary),
        backgroundColor: ColorPalette().primary,
        title: Text(
          'Match Details',
          style: TextStyle(color: ColorPalette().secondary),
        ),
        bottom: TabBar(
          indicatorColor: ColorPalette().secondary,
          isScrollable: true,
          controller: _tabController,
          tabs: [
            Tab(text: 'Kills'),
            Tab(text: 'Gold'),
            Tab(text: 'Damage Dealt'),
            Tab(text: 'Damage Taken'),
            Tab(text: 'Wards'),
            Tab(text: 'CS'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTeamComparisonWidget(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('kills'),
                _buildTabContent('gold'),
                _buildTabContent('damageDealt'),
                _buildTabContent('damageTaken'),
                _buildTabContent('wards'),
                _buildTabContent('cs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String category) {
    double lineWidth = 0;
    int data = 100;
    // Replace this with your logic for fetching and processing the data for the specified category
    return ListView.builder(
      itemCount: 10, // Replace this with the number of players in the match
      itemBuilder: (BuildContext context, int index) {
        (index == 3) ? lineWidth = 2 : lineWidth = 0;
        data = (10000.0 / (index + 1)).round();
        double adder = 5000;
        Color color = (index.isEven) ? Colors.blue : Colors.red;
        (index == 0) ? adder = 0 : adder = 5000;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$data', // Replace this with the player's data for the specified category
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: data / (data + adder),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              // SizedBox(width: 16),
              // ,
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamComparisonWidget() {
    // Replace this with your logic for fetching and processing the data for the two teams
    int team1Data = 10000;
    int team2Data = 8000;

    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTeamDataWidget('Winner', team1Data, Colors.blue),
              SizedBox(width: 16),
              _buildTeamDataWidget('Loser', team2Data, Colors.red),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: team1Data / (team1Data + team2Data),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDataWidget(String teamName, int data, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          teamName,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 8),
        Text(
          '$data', // Replace this with the sum of the specified category for the team
          style: TextStyle(
              fontSize: 24, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/widgets/summoner_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riot_api/providers/drop_provider.dart';
import 'package:flutter_riot_api/widgets/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: context.watch<DropDownProvider>().dropdownOpen ? 0.5 : 1.0,
            curve: Curves.easeInOut,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  _buildSearchBar(width),
                  _buildSummonerInfo(),
                  _buildSummonerInfo(),
                  _test2(),
                  _test2(),
                ],
              ),
            ),
          ),
          _buildDropDownMenu(context, height),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: context.watch<DropDownProvider>().dropdownOpen ? 0.5 : 1.0,
        curve: Curves.easeInOut,
        child: AppBar(
          backgroundColor: ColorPalette().primary,
          elevation: 0,
          title: CustomAppBar(
            onPressed: () => context.read<DropDownProvider>().onButtonPressed(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.93,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: ColorPalette().primary),
                onPressed: () => {},
              ),
              Expanded(
                child: TextField(
                  //onChanged: onTextChanged,
                  decoration: InputDecoration(
                    hintText: "Search Summoner",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummonerInfo() {
    return SummonerInfo();
  }

  Widget _buildDropDownMenu(BuildContext context, double height) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      bottom:
          context.watch<DropDownProvider>().dropdownOpen ? 0 : -height * 0.5,
      left: 0,
      right: 0,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Colors.white,
          ),
          height: height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [_buildTitleBar(context), _buildDropdownList(context)],
            ),
          )),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Select Server",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<DropDownProvider>().setFalse();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownList(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView(
        children: [
          _buildListItem(context, "option 1"),
          _buildListItem(context, "option 2"),
          _buildListItem(context, "option 3"),
          _buildListItem(context, "option 4"),
          _buildListItem(context, "option 4"),
          _buildListItem(context, "option 4"),
          _buildListItem(context, "option 4"),
          _buildListItem(context, "option 4"),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String option) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<DropDownProvider>().setFalse();
        },
        child: Column(
          children: [
            ListTile(
              title: Text(
                option,
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
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

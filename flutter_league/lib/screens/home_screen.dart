import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
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
          GestureDetector(
            onTap: () => {
              context.read<DropDownProvider>().dropdownOpen
                  ? context.read<DropDownProvider>().setFalse()
                  : null
            },
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity:
                  context.watch<DropDownProvider>().dropdownOpen ? 0.5 : 1.0,
              curve: Curves.easeInOut,
              child: SingleChildScrollView(
                child: IgnorePointer(
                  ignoring: context.watch<DropDownProvider>().dropdownOpen,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      _buildSearchBar(context, width),
                      _buildSummonerInfo(),
                      _buildSummonerInfo(),
                    ],
                  ),
                ),
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

  Widget _buildSearchBar(BuildContext context, double width) {
    String summonerName = "";
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
                onPressed: () async {
                  Summoner? summonerInfo = await getSummonerByName(
                    context.read<DropDownProvider>().summomnerName,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MatchHistoryPage(
                              summonerInfo: summonerInfo!,
                            )),
                  );
                },
              ),
              Expanded(
                child: TextField(
                  onSubmitted: (value) async {
                    Summoner? summonerInfo = await getSummonerByName(value);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          //TODO nem létező summoner
                          builder: (context) => MatchHistoryPage(
                                summonerInfo: summonerInfo!,
                              )),
                    );
                  },
                  onChanged: (value) {
                    context.read<DropDownProvider>().summomnerName = value;
                  },
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
        ),
      ),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/model/summoner.dart';
import 'package:flutter_riot_api/providers/home_provider.dart';
import 'package:flutter_riot_api/screens/match_history.dart';
import 'package:flutter_riot_api/services/summoner_service.dart';
import 'package:flutter_riot_api/utils/config.dart';
import 'package:flutter_riot_api/utils/loldata_string.dart';
import 'package:flutter_riot_api/widgets/summoner_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riot_api/widgets/custom_appbar.dart';
import '../utils/storage.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  static final ColorPalette colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    // Retrieve the width and height of the screen
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Check if the HomeProvider has any summoners or if it is currently loading
    // If either of these conditions are true, then call the initSummoners() method
    if (context.read<HomeProvider>().summoners.isEmpty ||
        context.read<HomeProvider>().isLoading) {
      context.read<HomeProvider>().initSummoners();
    }
    if (!context.read<HomeProvider>().isLoading) {
      context.read<HomeProvider>().init();
    }

    // Build the UI using a Scaffold widget and a Stack widget
    return Scaffold(
      // Build the app bar using the _buildAppBar() method
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Add a GestureDetector widget for handling taps
          GestureDetector(
            onTap: () => {
              // Check if the dropdown menu is open
              // If it is, close it. Otherwise, do nothing.
              context.read<HomeProvider>().dropdownOpen
                  ? context.read<HomeProvider>().setFalse()
                  : null
            },
            child: AnimatedOpacity(
              // Animate the opacity of the widget
              duration: const Duration(milliseconds: 200),
              opacity: context.watch<HomeProvider>().dropdownOpen ? 0.5 : 1.0,
              curve: Curves.easeInOut,
              child: SingleChildScrollView(
                child: IgnorePointer(
                  // Ignore pointer events if the dropdown menu is open
                  ignoring: context.watch<HomeProvider>().dropdownOpen,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // Build the search bar using the _buildSearchBar() method
                      _buildSearchBar(context, width),
                      // If the HomeProvider is currently loading, display a progress indicator
                      // Otherwise, display the summoner information using the _buildSummonerInfo() method
                      context.read<HomeProvider>().isLoading == true
                          ? const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              children: [
                                for (Summoner? summoner
                                    in context.read<HomeProvider>().summoners)
                                  if (summoner != null)
                                    _buildSummonerInfo(
                                      summoner,
                                      context
                                          .read<HomeProvider>()
                                          .getFavouriteSummonerServerId(
                                              summoner.puuid),
                                    ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Build the dropdown menu using the _buildDropDownMenu() method
          IgnorePointer(
            ignoring: !context.watch<HomeProvider>().dropdownOpen,
            child: InkWell(
              onTap: () => {
                // Check if the dropdown menu is open
                // If it is, close it. Otherwise, do nothing.
                context.read<HomeProvider>().dropdownOpen
                    ? context.read<HomeProvider>().setFalse()
                    : null
              },
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              child: Container(
                height: double.infinity,
              ),
            ),
          ),
          _buildDropDownMenu(context, height),
        ],
      ),
    );
  }

  /// This method returns a custom AppBar widget with an animated opacity.
  PreferredSize _buildAppBar(BuildContext context) {
    // Create a PreferredSize widget with the given preferred size and child widget.
    return PreferredSize(
      preferredSize: preferredSize, // The preferred size of the widget
      child: AnimatedOpacity(
        // Animate the opacity of the widget
        duration: const Duration(milliseconds: 200),
        opacity: context.watch<HomeProvider>().dropdownOpen ? 0.5 : 1.0,
        curve: Curves.easeInOut,
        child: AppBar(
          // Customize the AppBar widget
          backgroundColor: colorPalette.primary, // Set the background color
          elevation: 0, // Remove the elevation shadow
          title: CustomAppBar(
            // Add a custom widget to the title section
            onPressed: () => context.read<HomeProvider>().onButtonPressed(),
          ),
        ),
      ),
    );
  }

  /// This widget builds the search bar, which consists of a container with a search icon and a search field.
  Row _buildSearchBar(BuildContext context, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // The width of the container is 93% of the available width.
          width: width * 0.93,
          decoration: BoxDecoration(
            // The container has a grey border, white background, and rounded corners.
            border: Border.all(color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              // The search icon button is a separate widget.
              _buildSearchIcon(context),
              // The search field is a separate widget.
              _buildSearchField(context),
            ],
          ),
        ),
      ],
    );
  }

  /// This widget builds the search icon button, which calls the search function when pressed.
  IconButton _buildSearchIcon(BuildContext context) {
    return IconButton(
      // The search icon is a Material icon with a custom primary color.
      icon: Icon(Icons.search, color: colorPalette.primary),
      onPressed: () async {
        // Call the s function to retrieve Summoner info based on the entered name.
        Summoner? summonerInfo = await getSummonerByName(
          context.read<HomeProvider>().summomnerName,
        );
        // If the summoner info is null, do nothing and return.
        if (summonerInfo == null) return; //TODO nem létező summoner
        // Check if the searched summoner is already a favorite.
        // ignore: use_build_context_synchronously
        bool isFavourite = context
            .read<HomeProvider>()
            .summonerServers
            .any((s) => s.puuid == summonerInfo.puuid);
        // Navigate to the match history page, passing the Summoner info and favorite status as arguments.
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchHistoryPage(
              summonerInfo: summonerInfo,
              isFavourite: isFavourite,
            ),
          ),
        );
      },
    );
  }

  /// This widget builds the search field, which is a text field that updates the entered Summoner name in the provider when changed.
  Expanded _buildSearchField(BuildContext context) {
    return Expanded(
      child: TextField(
        // When the user submits the search field, call the search function with the entered name.
        onSubmitted: (value) async {
          Summoner? summonerInfo = await getSummonerByName(value);
          // If the summoner info is null, do nothing and return.
          if (summonerInfo == null) return; //TODO nem létező summoner
          // Check if the searched summoner is already a favorite.
          // ignore: use_build_context_synchronously
          bool isFavourite = context
              .read<HomeProvider>()
              .summonerServers
              .any((s) => s.puuid == summonerInfo.puuid);
          // Navigate to the match history page, passing the Summoner info and favorite status as arguments.
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchHistoryPage(
                summonerInfo: summonerInfo,
                isFavourite: isFavourite,
              ),
            ),
          );
        },
        // When the text field is changed, update the Summoner name in the provider.
        onChanged: (value) {
          context.read<HomeProvider>().summomnerName = value;
        },
        decoration: const InputDecoration(
          hintText: 'Summoner name',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        ),
      ),
    );
  }

  SummonerInfo _buildSummonerInfo(Summoner summoner, [String? serverId]) {
    return SummonerInfo(
      summoner: summoner,
      serverId: serverId,
    );
  }

  /// This widget builds the dropdown menu, which is a container that animates up and down when opened and closed.
  AnimatedPositioned _buildDropDownMenu(BuildContext context, double height) {
    return AnimatedPositioned(
      // The animation duration is 200 milliseconds.
      duration: const Duration(milliseconds: 200),
      // The bottom position of the container is either 0 or -half the height of the container, based on the dropdownOpen bool in the provider.
      bottom: context.watch<HomeProvider>().dropdownOpen ? 0 : -height * 0.5,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          // The container has a grey shadow to create depth.
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
          // The container has rounded corners on the top.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          // The container has a white background color.
          color: Colors.white,
        ),
        // The container's height is half the height of the parent container.
        height: height * 0.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // The title bar is a separate widget.
              _buildTitleBar(context),
              // The dropdown list is a separate widget.
              _buildDropdownList(context),
            ],
          ),
        ),
      ),
    );
  }

  /// This widget builds the title bar for the dropdown menu, which displays the title and a close icon.
  SizedBox _buildTitleBar(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The title of the dropdown menu is displayed in the center of the row.
          const Padding(
            padding: EdgeInsets.all(16.0),
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
          // The close icon button is displayed on the right side of the row.
          IconButton(
            onPressed: () {
              // When the close icon button is pressed, set the dropdownOpen boolean in the HomeProvider to false.
              context.read<HomeProvider>().setFalse();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  final List<String> options = [
    "eun1",
    "euw1",
    "jp1",
    "br1",
    "kr",
    "la1",
    "la2",
    "na1",
    "oc1",
    "ph2",
    "ru",
    "sg2",
    "th2",
    "tr1",
    "tw2",
    "vn2",
  ];

  /// A widget that displays a list of options in a dropdown menu
  SizedBox _buildDropdownList(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView(
        children: [
          // Build each option as a list item
          for (String option in options) _buildListItem(context, option),
        ],
      ),
    );
  }

  /// A widget that displays a single option as a list item
  Material _buildListItem(BuildContext context, String option) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // When the user taps on an option, set the dropdown to be closed
        onTap: () async {
          Config.currentServer = option;
          saveServerId(option);
          context.read<HomeProvider>().serverName = option;
          context.read<HomeProvider>().setFalse();
        },
        child: Column(
          children: [
            // Display the option text as the title of the list item
            ListTile(
              title: Text(
                getServerName(option),
                textAlign: TextAlign.center,
              ),
            ),
            // Add a divider below the option
            const Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}

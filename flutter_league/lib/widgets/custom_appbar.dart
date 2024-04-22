import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';
import 'package:flutter_riot_api/providers/home_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  final Function onPressed;

  const CustomAppBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.0, // Set the height of the row
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Position the children at the start and end of the row
        children: [
          _buildAppTitle(), // Widget that displays the app title
          _buildServerSelect(), // Widget that displays the server selection dropdown
        ],
      ),
    );
  }

  Expanded _buildServerSelect() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add some empty space before the server selection button
          const SizedBox(width: 12.0),
          GestureDetector(
            // Handle the onTap event for the server selection button
            onTap: () {
              onPressed();
            },
            child: Container(
              // Set some padding for the button content
              padding: const EdgeInsets.all(7.0),
              height: 42.0,
              width: 84.0,
              decoration: BoxDecoration(
                // Set the background color and border radius of the button
                color: ColorPalette().secondary,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer<HomeProvider>(
                    // Consume the HomeProvider from the widget tree to display the selected server name
                    builder: (context, customAppBarData, child) {
                      // Check if the server name is available
                      if (customAppBarData.serverName == null) {
                        // If it's not available, display a "-" character
                        return _buildServerName("-");
                      }
                      // If it's available, display the server name
                      return _buildServerName(customAppBarData.serverName!);
                    },
                  ),
                  _buildSelectArrow(), // Display an arrow icon to indicate the dropdown menu
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Transform _buildSelectArrow() {
    // Returns a Transform widget that rotates the Icon by 90 degrees
    return Transform.rotate(
      angle: 90 * pi / 180, // 90 degrees in radians
      child: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Color.fromARGB(255, 44, 62, 80),
      ),
    );
  }

  Expanded _buildAppTitle() {
    // Returns an Expanded widget that contains the app title as a Text widget
    return Expanded(
      child: Text(
        'FlutterLeague',
        style: TextStyle(
          color: ColorPalette().secondary,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.2,
        ),
      ),
    );
  }

  Text _buildServerName(String text) {
    // Returns a Text widget with the server name
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Color.fromARGB(255, 44, 62, 80),
      ),
    );
  }
}

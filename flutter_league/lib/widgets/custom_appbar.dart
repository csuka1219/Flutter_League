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
      height: 65.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'FlutterLeage',
              style: TextStyle(
                color: ColorPalette().secondary,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 12.0),
                GestureDetector(
                  onTap: () {
                    onPressed();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    height: 42.0,
                    width: 84.0,
                    decoration: BoxDecoration(
                      color: ColorPalette().secondary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<HomeProvider>(
                          // Consume the MatchHistoryData from the widget tree
                          builder: (context, customAppBarData, child) {
                            if (customAppBarData.serverName == null) {
                              return const Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 44, 62, 80),
                                ),
                              );
                            }
                            return Text(
                              customAppBarData.serverName!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 44, 62, 80)),
                            );
                          },
                        ),
                        const Spacer(),
                        Transform.rotate(
                          angle: 90 * pi / 180, // 90 degrees in radians
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color.fromARGB(255, 44, 62, 80),
                          ),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

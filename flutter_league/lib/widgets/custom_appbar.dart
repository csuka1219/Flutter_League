import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riot_api/color_palette.dart';

class CustomAppBar extends StatelessWidget {
  final Function onPressed;

  CustomAppBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'JánosBook',
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
                    padding: EdgeInsets.all(7.0),
                    height: 42.0,
                    width: 84.0,
                    decoration: BoxDecoration(
                      color: ColorPalette().secondary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "EUNE",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 44, 62, 80)),
                        ),
                        Spacer(),
                        Transform.rotate(
                          angle: 90 * pi / 180, // 90 degrees in radians
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color.fromARGB(255, 44, 62, 80),
                          ),
                        ),
                        Spacer()
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

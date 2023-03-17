import 'package:flutter/material.dart';
import 'package:flutter_riot_api/providers/drop_provider.dart';
import 'package:flutter_riot_api/providers/matchhistory_provider.dart';
import 'package:flutter_riot_api/screens/home_screen.dart';
import 'package:flutter_riot_api/screens/summoner_details.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DropDownProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        //'/details': (context) => SummonerDetailsPage()
        //'/second': (context) => SecondScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riot_api/providers/home_provider.dart';
import 'package:flutter_riot_api/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

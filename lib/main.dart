import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:graphical_search_interface/screens/home_screen.dart';
import 'package:graphical_search_interface/screens/tutorial_screen.dart';
import 'package:graphical_search_interface/providers/appbar_provider.dart';
import 'package:graphical_search_interface/providers/offset_provider.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Graphical Search in Time Series',
      theme: ThemeData(
        primaryColor: const Color(0xff070d59),
        fontFamily: 'Product Sans',
      ),
      home: MyHomePage(),
      initialRoute: '/',
      routes: {
        TutorialScreen.routeName: (context) => TutorialScreen(),
      },
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => OffsetProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AppBarProvider(),
        ),
      ],
      child: HomeScreen(),
    );
  }
}

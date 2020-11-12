import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperapp/Screens/Categories.dart';
import 'package:wallpaperapp/Widgets/DashBoard.dart';
import 'Screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: DashBoardGrid(
          search: 'trending',
        ));
  }
}

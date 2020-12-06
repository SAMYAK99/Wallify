import 'package:flutter/material.dart';
import 'package:wallpaperapp/Widgets/grid.dart';

class Trending extends StatefulWidget {
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridPage(
        search: "trending",
        heading: "Trending",
      ),
    );
  }
}

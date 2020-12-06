import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperapp/Screens/Categories.dart';
import 'package:wallpaperapp/Screens/HomePage.dart';
import 'package:wallpaperapp/Screens/Trending.dart';
import 'package:wallpaperapp/Screens/settings.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  var screens = [
    Home(),
    CategoryScreen(),
    Trending(),
    Setting()
  ]; //screens for each tab

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BubbleBottomBar(
        //  backgroundColor: Color(0XFF37474F),
        backgroundColor: Colors.pinkAccent,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        // borderRadius: BorderRadius.vertical(
        //     top: Radius.circular(16), bottom: Radius.circular(32)),
        //border radius doesn't work when the notch is enabled.
        // elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.black45,
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.white60,
              ),
              title: Text(
                "Home",
                style: GoogleFonts.poppins(color: Colors.white60),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.black45,
              icon: Icon(
                Icons.category,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.category,
                color: Colors.white60,
              ),
              title: Text(
                "Categories",
                style: GoogleFonts.poppins(color: Colors.white60),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.black45,
              icon: Icon(
                Icons.trending_up,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.trending_up,
                color: Colors.white60,
              ),
              title: Text(
                "Trending",
                style: GoogleFonts.poppins(color: Colors.white60),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.black45,
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.settings,
                color: Colors.white60,
              ),
              title: Text(
                "Setting",
                style: GoogleFonts.poppins(color: Colors.white60),
              )),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}

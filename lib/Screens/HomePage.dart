import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/Widgets/StaggeredGrid.dart';
import 'package:wallpaperapp/Widgets/carosel_dashboard.dart';
import 'package:wallpaperapp/data/data.dart';
import 'package:wallpaperapp/models/CategoryModel.dart';
import 'package:wallpaperapp/models/PhotosModel.dart';

import 'dart:convert';

import 'Search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = new List();

  int noOfImageToLoad = 60;
  List<PhotosModel> photos = new List();

  getTrendingWallpaper() async {
    await http.get(
        "https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad&page=1",
        headers: {"Authorization": apiKEY}).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });
    });
  }

  TextEditingController searchController = new TextEditingController();

  Widget ad() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "812354409362722_875458466385649",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: 5000);
      },
    );
  }

  @override
  void initState() {
    ad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(top: 8),
              sliver:  SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 60.0,
                  elevation: 0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: EdgeInsets.only(left: 16, bottom: 16),
                      title: Text(
                        'Wallify',
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w700, fontSize: 24 ,
                            color: Theme.of(context).textTheme.bodyText1.color
                        ),
                      ),
                      background: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      )
                  )
              ),
            )
          ];
        },
        body:
        Container(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 160,
                  child: Dashboard(),
                ),
                SizedBox(
                  height: 16,
                ),
                // wallPaper(photos, context),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            hintText: "Search ", border: InputBorder.none),
                      )),
                      InkWell(
                          onTap: () {
                            if (searchController.text != "") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchView(
                                            search: searchController.text,
                                          )));
                            }
                          },
                          child: Container(child: Icon(Icons.search)))
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Popular',
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: DashBoardGrid(search: "popular")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

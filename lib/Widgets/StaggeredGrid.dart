import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/Screens/ImageView.dart';

class DashBoardGrid extends StatefulWidget {
  final String search;

  DashBoardGrid({@required this.search});

  @override
  _DashBoardGridState createState() => _DashBoardGridState();
}

class _DashBoardGridState extends State<DashBoardGrid> {
  List data;

  @override
  void initState() {
    getimages(widget.search);
    super.initState();
  }

  Future<String> getimages(String query) async {
    var getdata = await http.get(
        'https://api.unsplash.com/search/photos?per_page=30&client_id=LOspW8jcT27D-PLY4mFR22Hj9DIiKIkEbefVyeM3gZ8&query=$query');
    setState(() {
      var jsondata = json.decode(getdata.body);
      data = jsondata['results'];
    });
    return "Success";
  }

  static var _random = new Random();
  static var _axis = _random.nextInt(8) + 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data != null
          ? Container(
              child: new StaggeredGridView.countBuilder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                crossAxisCount: 3,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) => Material(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageView(
                                  imgPath: data[index]['urls']['regular'],
                                )));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                          imageUrl: data[index]['urls']['regular'],
                          placeholder: (context, url) => Container(
                                color: Color(0xfff5f8fd),
                              ),
                          fit: BoxFit.cover)),
                )),
                staggeredTileBuilder: (int index) => StaggeredTile.count(
                    (index % _axis == 0) ? 2 : 1,
                    (index % _axis == 0) ? 2 : 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 6.0,
              ),
            )
          : Center(
              child: new CircularProgressIndicator(),
            ),
    );
  }
}

class CarouselGrid extends StatefulWidget {
  final String search;

  CarouselGrid({@required this.search});

  @override
  _CarouselGridState createState() => _CarouselGridState();
}

class _CarouselGridState extends State<CarouselGrid> {
  List data;

  @override
  void initState() {
    getimages(widget.search);
    super.initState();
  }

  Future<String> getimages(String query) async {
    var getdata = await http.get(
        'https://api.unsplash.com/search/photos?per_page=30&client_id=LOspW8jcT27D-PLY4mFR22Hj9DIiKIkEbefVyeM3gZ8&query=$query');
    setState(() {
      var jsondata = json.decode(getdata.body);
      data = jsondata['results'];
    });
    return "Success";
  }

  static var _random = new Random();
  static var _axis = _random.nextInt(8) + 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 32,
              ),
              Container(
                child: data != null
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: new StaggeredGridView.countBuilder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 8),
                          crossAxisCount: 3,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Material(
                                  child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageView(
                                            imgPath: data[index]['urls']
                                                ['regular'],
                                          )));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                    imageUrl: data[index]['urls']['regular'],
                                    placeholder: (context, url) => Container(
                                          color: Color(0xfff5f8fd),
                                        ),
                                    fit: BoxFit.cover)),
                          )),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count((index % _axis == 0) ? 2 : 1,
                                  (index % _axis == 0) ? 2 : 1),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 6.0,
                        ),
                      )
                    : Center(
                        child: new CircularProgressIndicator(),
                      ),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: FacebookBannerAd(
            placementId: "812354409362722_875457533052409",
            bannerSize: BannerSize.STANDARD,
            listener: (result, value) {
              switch (result) {
                case BannerAdResult.ERROR:
                  print("Error: $value");
                  break;
                case BannerAdResult.LOADED:
                  print("Loaded: $value");
                  break;
                case BannerAdResult.CLICKED:
                  print("Clicked: $value");
                  break;
                case BannerAdResult.LOGGING_IMPRESSION:
                  print("Logging Impression: $value");
                  break;
              }
            },
          ),
        ),
      ],
    ));
  }
}

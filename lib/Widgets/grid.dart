import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperapp/Screens/ImageView.dart';
import 'package:wallpaperapp/models/PhotosModel.dart';
import 'package:http/http.dart' as http;

class GridPage extends StatefulWidget {
  final String search;
  final String heading;
  GridPage({@required this.search, @required this.heading});
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List data;

  Future<String> getimages(String keyQuery) async {
    var getdata = await http.get(
        'https://api.unsplash.com/search/photos?per_page=30&client_id=LOspW8jcT27D-PLY4mFR22Hj9DIiKIkEbefVyeM3gZ8&query=${keyQuery}');
    setState(() {
      var jsondata = json.decode(getdata.body);
      data = jsondata['results'];
    });
    return "Success";
  }

  @override
  void initState() {
    getimages(widget.search);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: data != null
            ? SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          widget.heading,
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w700, fontSize: 24),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: const EdgeInsets.all(4.0),
                            itemCount: data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.5,
                              mainAxisSpacing: 6.0,
                              crossAxisSpacing: 6.0,
                            ),
                            itemBuilder: (context, index) => GestureDetector(
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
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                      imageUrl: data[index]['urls']['regular'],
                                      placeholder: (context, url) => Container(
                                            color: Color(0xfff5f8fd),
                                          ),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        )
                      ],
                    )),
              )
            : new Center(
                child: new CircularProgressIndicator(),
              ));
  }
}

Widget wallPaper(List<PhotosModel> listPhotos, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 0.5,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
        children: listPhotos.map((PhotosModel photoModel) {
          return GridTile(
              child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            imgPath: photoModel.src.portrait,
                          )));
            },
            child: Hero(
              tag: photoModel.src.portrait,
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                        imageUrl: photoModel.src.portrait,
                        placeholder: (context, url) => Container(
                              color: Color(0xfff5f8fd),
                            ),
                        fit: BoxFit.cover)),
              ),
            ),
          ));
        }).toList()),
  );
}

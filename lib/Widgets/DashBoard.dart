import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

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
        'https://api.unsplash.com/search/photos?per_page=50&client_id=LOspW8jcT27D-PLY4mFR22Hj9DIiKIkEbefVyeM3gZ8&query=$query');
    setState(() {
      var jsondata = json.decode(getdata.body);
      data = jsondata['results'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Wallify'),
        ),
        body: data != null
            ? new StaggeredGridView.countBuilder(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                crossAxisCount: 4,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) => Material(
                    child: InkWell(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (context) => _onTapImage(
                    //         context, data[index]['urls']['small']));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      data[index]['urls']['regular'],
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
                staggeredTileBuilder: (int index) => StaggeredTile.count(
                    (index % 4 == 0) ? 2 : 1, (index % 4 == 0) ? 2 : 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 6.0,
              )
            : new Center(
                child: new CircularProgressIndicator(),
              ));
  }
}

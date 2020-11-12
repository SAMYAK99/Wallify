import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  final String search;

  CategoryScreen({@required this.search});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
            ? new StaggeredGridView.countBuilder(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 4,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) => Material(
                    elevation: 8.0,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    child: InkWell(
                      onTap: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) => _onTapImage(
                        //         context, data[index]['urls']['small']));
                      },
                      child: ClipRRect(
                        child: Image.network(
                          data[index]['urls']['regular'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 3 : 2),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              )
            : new Center(
                child: new CircularProgressIndicator(),
              ));
  }
}

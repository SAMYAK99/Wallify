import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperapp/Screens/ImageView.dart';
import 'package:wallpaperapp/models/PhotosModel.dart';

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

class HomePageGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Widget MainTitle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wallify",
        style: TextStyle(color: Colors.blue),
      ),
    ],
  );
}

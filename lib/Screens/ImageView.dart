import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ImageView extends StatefulWidget {
  final String imgPath;

  ImageView({@required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  String _localfile;
  File _imageFile;
  ByteData byteData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: widget.imgPath,
                placeholder: (context, url) => Container(
                  color: Color(0xfff5f8fd),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () async {
                  var request =
                      await HttpClient().getUrl(Uri.parse(widget.imgPath));
                  var response = await request.close();
                  Uint8List bytes =
                      await consolidateHttpClientResponseBytes(response);
                  await Share.file(
                      'Download Wallify Now!', 'amlog.jpg', bytes, 'image/jpg');
                },
                icon: Icon(
                  FontAwesomeIcons.share,
                  size: 34,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.80,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.05,
                    minWidth: MediaQuery.of(context).size.width * 0.60,
                    color: Colors.black54,
                    onPressed: () {
                      BottomSheet(context);
                    },
                    shape: StadiumBorder(),
                    child: Text(
                      "Apply",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _save(context);
                    },
                    icon: Icon(
                      FontAwesomeIcons.arrowCircleDown,
                      size: 34,
                      color: Colors.white60,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.88,
            left: MediaQuery.of(context).size.width * 0.35,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: MaterialButton(
                height: MediaQuery.of(context).size.height * 0.05,
                minWidth: MediaQuery.of(context).size.width * 0.30,
                color: Colors.black54,
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: StadiumBorder(),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _save(context) async {
    await _askPermission();
    var response = await Dio().get(widget.imgPath,
//in imageURL use your own image url variable
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    if (result != null) {
      var snackBar = SnackBar(content: Text('Wallpaper Downloaded'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    //Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */
      await PermissionHandler().requestPermissions([PermissionGroup.photos]);
    } else {
      PermissionHandler permission = PermissionHandler();
      await permission.requestPermissions([
        PermissionGroup.storage,
        PermissionGroup.camera,
        PermissionGroup.location
      ]);
      await permission.checkPermissionStatus(PermissionGroup.storage);
    }
  }

  void BottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        )),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.lock),
                  title: Text(
                    'Lock Screen',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    setWallpaperlock(context, widget.imgPath);
                  },
                ),
                ListTile(
                    leading: Icon(FontAwesomeIcons.home),
                    title: Text(
                      'Home Screen',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      setWallpaperhome(context, widget.imgPath);
                    }),
                ListTile(
                  leading: Icon(FontAwesomeIcons.android),
                  title: Text(
                    'Both',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () => {setWallpaperboth(context, widget.imgPath)},
                ),
              ],
            ),
          );
        });
  }

  void setWallpaperlock(BuildContext ctx, String image) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(image);

      int location = WallpaperManager.LOCK_SCREEN;

      String result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);

      if (result != null) {
        var snackBar = SnackBar(content: Text('Wallpaper set'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    } catch (e) {
      print("exception e");
    }
  }

  void setWallpaperhome(BuildContext ctx, String image) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(image);

      int location = WallpaperManager.HOME_SCREEN;

      String result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);

      if (result != null) {
        var snackBar = SnackBar(content: Text('Wallpaper set'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    } catch (e) {
      print("exception e");
    }
  }

  void setWallpaperboth(BuildContext ctx, String image) async {
    try {
      var file = await DefaultCacheManager().getSingleFile(image);

      int location = WallpaperManager.BOTH_SCREENS;

      String result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);

      if (result != null) {
        var snackBar = SnackBar(content: Text('Wallpaper set'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    } catch (e) {
      print("exception e");
    }
  }
}

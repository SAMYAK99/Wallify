import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

import 'package:wallpaperplugin/wallpaperplugin.dart';

class ImageView extends StatefulWidget {
  final String imgPath;

  ImageView({@required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;

  String _localPath;

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
            padding: EdgeInsets.all(30),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Share.share(widget.imgPath);
                  });
                },
                icon: Icon(FontAwesomeIcons.share),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.85,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.05,
                    minWidth: MediaQuery.of(context).size.width * 0.60,
                    color: Colors.black45,
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
                      _save();
                    },
                    icon: Icon(
                      FontAwesomeIcons.arrowCircleDown,
                      size: 32,
                      color: Colors.white60,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.94,
            left: MediaQuery.of(context).size.width * 0.45,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void BottomSheet(context) {
    showModalBottomSheet(
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
                ),
                ListTile(
                    leading: Icon(FontAwesomeIcons.home),
                    title: Text(
                      'Home Screen',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              _onTapProcess(context, widget.imgPath));
                    }),
                ListTile(
                  leading: Icon(FontAwesomeIcons.android),
                  title: Text(
                    'Both',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }

  _save() async {
    await _askPermission();
    var response = await Dio().get(widget.imgPath,
//in imageURL use your own image url variable
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _onTapProcess(context, values) {
    return CupertinoAlertDialog(
      title: new Text("Set As Wallpaper"),
      content: Text('click Yes to set wallpaper'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes!'),
          onPressed: () async {
            if (_checkAndGetPermission() != null) {
              Dio dio = Dio();
              final Directory appdirectory =
                  await getExternalStorageDirectory();
              final Directory directory =
                  await Directory(appdirectory.path + '/wallpapers')
                      .create(recursive: true);
              final String dir = directory.path;
              String localPath = '$dir/myImages.jpeg';
              try {
                dio.download(values, localPath);
                setState(() {
                  _localPath = localPath;
                });
                Wallpaperplugin.setAutoWallpaper(localFile: _localPath);
              } on PlatformException catch (e) {
                print(e);
              }
              Navigator.pop(context);
            } else {}
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
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

  static Future<bool> _checkAndGetPermission() async {
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      final Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return null;
      }
    }
    return true;
  }
}

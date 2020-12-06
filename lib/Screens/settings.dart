import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
            ),
            Text(
              'Setting',
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700, fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            ListTile(
              leading: Icon(
                Icons.brightness_6_sharp,
                size: 32,
              ),
              title: Text(
                'Theme',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
              trailing: toggle(),
            )
          ],
        ),
      )),
    );
  }

  Widget toggle() {
    return CupertinoSwitch(
      value: _switchValue,
      activeColor: Colors.blue,
      onChanged: (value) {
        setState(() {
          _switchValue = !_switchValue;
          changeBrightness();
        });
      },
    );
  }
}

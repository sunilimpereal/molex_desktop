import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:molex_desktop/login.dart';
import 'package:molex_desktop/screens/utils/SharePref.dart';
import 'package:molex_desktop/screens/utils/changeIp.dart';
import 'package:molex_desktop/screens/utils/colors.dart';
import 'package:molex_desktop/screens/utils/fonts.dart';
import 'package:molex_desktop/test_barcode.dart';

SharedPref sharedPref = new SharedPref();
Fonts fonts = new Fonts();
AppColors colors = new AppColors();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPref.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final String? logged;
  MyApp({this.logged});
  // This widget is the root of your application.
  static void reload(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.reload();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  void reload() {
    setState(() {
      log("Reloaded");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Molex',
        theme: ThemeData(
          // fontFamily: 'OpenSans',
          primarySwatch: Colors.blue,
        ),
        builder: (context, child) => Stack(
              children: [child!, DropdownAlert()],
            ),
        home: ChangeIp());
  }
}

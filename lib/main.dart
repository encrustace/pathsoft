import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:pathsoft/view/home.dart';
import 'package:pathsoft/view/init_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget home = WaitWidget();
  Future<void> checkInit() async {
    var databasePath = await getDatabasesPath();
    var path = databasePath + '/database.db';
    var dir = await io.File(path).exists();
    if (dir) {
      setState(() {
        home = Home(pageNumber: 0,);
      });
    } else {
      setState(() {
        home = InitPage();
      });
    }
  }

  @override
  void initState() {
    checkInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pathsoft',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: home,
    );
  }
}

class WaitWidget extends StatefulWidget {
  @override
  _WaitWidgetState createState() => _WaitWidgetState();
}

class _WaitWidgetState extends State<WaitWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(0.3),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/view/home.dart';
import 'package:sqflite/sqflite.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _pathOwner = TextEditingController();
  TextEditingController _pathMobile = TextEditingController();
  TextEditingController _pathEmail = TextEditingController();
  TextEditingController _pathName = TextEditingController();
  TextEditingController _pathAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.8),
      appBar: AppBar(
        title: Text('Add pathology details'),
      ),
      body: Center(
        child: Container(
          color: Colors.white.withOpacity(0.5),
          width: 400,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(18.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    autofocus: false,
                    controller: _pathOwner,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.userMd),
                      hintText: "Don't put 'Dr.' before name",
                      labelText: 'Owner',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _pathMobile,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.phone),
                      hintText: "9999999999",
                      labelText: 'Mobile',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _pathEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.mailBulk),
                      hintText: "abc@example.com",
                      labelText: 'Email',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _pathName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.clinicMedical),
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      hintText: 'Pathology name',
                      hintStyle: TextStyle(color: Colors.black45),
                    ),
                    validator: (value) => value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _pathAddress,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.home),
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Pathology address',
                      hintStyle: TextStyle(color: Colors.black45),
                    ),
                    maxLines: null,
                    validator: (value) => value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  ElevatedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      createDatabase();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createDatabase() async {
    if (formKey.currentState.validate()) {
      try {
        var databasePath = await getDatabasesPath();
        String path = databasePath + '/database.db';
        Database database = await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
          await db.execute('''PRAGMA foreign_keys = ON''');
          await db.execute('''CREATE TABLE pathology(
            path_id INTEGER NOT NULL PRIMARY KEY,
            path_name TEXT NOT NULL,
            path_email TEXT NOT NULL,
            path_owner TEXT NOT NULL,
            path_mobile TEXT NOT NULL,
            path_address TEXT NOT NULL)''');

          await db.execute('''CREATE TABLE doctor(
            doctor_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            doctor_name TEXT NOT NULL,
            doctor_email TEXT,
            doctor_gender TEXT NOT NULL,
            doctor_dob TEXT NOT NULL,
            doctor_mobile TEXT NOT NULL,
            doctor_address TEXT,
            doctor_share INTEGER NOT NULL
            )''');

          await db.execute('''CREATE TABLE test(
            test_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            test_category TEXT NOT NULL,
            test_name TEXT NOT NULL,
            test_price INTEGER NOT NULL,
            test_range TEXT,
            test_unit TEXT
            )''');

          await db.execute('''CREATE TABLE entry(
            entry_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            entry_name TEXT NOT NULL,
            entry_age INTEGER NOT NULL,
            entry_gender TEXT NOT NULL,
            entry_address TEXT NOT NULL,
            entry_status TEXT NOT NULL,
            entry_price INTEGER NOT NULL,
            entry_doc_status TEXT NOT NULL,
            entry_discount INTEGER NOT NULL,
            entry_date TEXT NOT NULL,
            entry_share INTEGER NOT NULL,
            doctor_id INTEGER NOT NULL,
            FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
            )''');

          await db.execute('''CREATE TABLE entry_item(
            entry_item_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            entry_item_data TEXT NOT NULL,
            entry_id INTEGER NOT NULL,
            test_id INTEGER NOT NULL,
            FOREIGN KEY (entry_id) REFERENCES entry(entry_id) ON DELETE CASCADE,
            FOREIGN KEY (test_id) REFERENCES test(test_id)
            )''');
        });
        await database.transaction((txn) async => {
              await txn.rawInsert('''INSERT INTO pathology(
            path_name,
            path_email,
            path_owner,
            path_mobile,
            path_address)
            VALUES(
            "${_pathName.text}",
            "${_pathEmail.text}",
            "${_pathOwner.text}",
            "${_pathMobile.text}",
            "${_pathAddress.text}"
            );''')
            });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Home(
                      pageNumber: 0,
                    )),
            (Route<dynamic> route) => false);
      } catch (err) {
        log(err);
      }
    }
  }
}

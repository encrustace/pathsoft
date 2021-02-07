import 'dart:io';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/model/doc_model.dart';
import 'package:pathsoft/model/entry_item_model.dart';
import 'package:pathsoft/model/entry_model.dart';
import 'package:pdf/widgets.dart' as pw;

class Report extends StatefulWidget {
  Report({
    @required this.entryId,
  });
  final entryId;

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController orgName = TextEditingController();
  TextEditingController orgAddress = TextEditingController();
  TextEditingController orgOwner = TextEditingController();
  EntryModel entryData;
  DoctorModel docData;
  List<EntryItemModel> entryItemList = [];
  List<String> testNameList = [];
  List<String> testUnitList = [];
  List<String> testRangeList = [];

  Future<void> getOrgData() async {
    List<Map> list = await database.rawQuery('''SELECT * FROM pathology''');
    orgName.text = list[0]['path_name'];
    orgAddress.text = list[0]['path_address'];
    setState(() {});
    getEntryData();
  }

  Future<void> getEntryData() async {
    List<Map> list = await database
        .rawQuery('''SELECT * FROM entry WHERE entry_id = ${widget.entryId}''');

    entryData = EntryModel(
      list[0]['entry_id'],
      list[0]['entry_name'],
      list[0]['entry_age'],
      list[0]['entry_gender'],
      list[0]['entry_address'],
      list[0]['entry_status'],
      list[0]['entry_doc_status'],
      list[0]['entry_price'],
      list[0]['entry_discount'],
      list[0]['entry_share'],
      list[0]['entry_date'],
      list[0]['doctor_id'],
    );
    setState(() {});
    getDocData();
  }

  Future<void> getDocData() async {
    List<Map> list = await database.rawQuery(
        '''SELECT * FROM doctor WHERE doctor_id = ${entryData.doctorId}''');
    docData = DoctorModel(
      list[0]['doctor_id'],
      list[0]['doctor_name'],
      list[0]['doctor_dob'],
      list[0]['doctor_mobile'],
      list[0]['doctor_email'],
      list[0]['doctor_share'],
      list[0]['doctor_address'],
      list[0]['doctor_gender'],
    );
    setState(() {});
    getEntryItems();
  }

  getEntryItems() async {
    List<Map> list = await database.rawQuery(
        '''SELECT * FROM entry_item WHERE entry_id = ${widget.entryId}''');
    for (var i = 0; i < list.length; i++) {
      entryItemList.add(
        EntryItemModel(
          list[i]['entry_item_id'],
          list[i]['entry_item_data'],
          list[i]['path_id'],
          list[i]['entry_id'],
          list[i]['test_id'],
        ),
      );
    }
    setState(() {});
    getTestDetails();
  }

  void getTestDetails() async {
    for (var i = 0; i < entryItemList.length; i++) {
      List<Map> list = await database.rawQuery(
          '''SELECT * FROM test WHERE test_id = ${entryItemList[i].testId}''');
      testNameList.add(list[0]['test_name']);
      testUnitList.add(list[0]['test_unit']);
      testRangeList.add(list[0]['test_range']);
    }
    setState(() {});
  }

  Future<void> getPdf() async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Container(
          padding: pw.EdgeInsets.all(24.0),
          child: pw.Column(
            children: <pw.Widget>[
              ////Org Section
              pw.Center(
                child: pw.Text(
                  orgName.text,
                  style: pw.TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              pw.Divider(thickness: 2.0),
              pw.Container(
                child: pw.Column(
                  children: <pw.Widget>[
                    pw.Row(
                      children: <pw.Widget>[
                        pw.Expanded(
                          child: pw.Text(
                            'Ref by: Dr. ${docData.doctorName}',
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            'Name: ${entryData.entryName}',
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: <pw.Widget>[
                        pw.Expanded(
                          child: pw.Text(
                            'Age: ${entryData.entryAge}',
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            'Gender: ${entryData.entryGender}',
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: <pw.Widget>[
                        pw.Expanded(
                          child: pw.Text(
                            'Test performed by:',
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            'Dr. ${orgOwner.text}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Divider(thickness: 2.0),

              ////Test Section
              pw.Expanded(
                child: pw.Column(
                  children: <pw.Widget>[
                    pw.Row(
                      children: <pw.Widget>[
                        pw.Expanded(
                          child: pw.Text(
                            'Test Name',
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            'Result',
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            'Range',
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(
                      thickness: 0.5,
                    ),
                    pw.Expanded(
                      child: pw.ListView.builder(
                        itemBuilder: (pw.Context context, int index) {
                          return pw.Row(
                            children: <pw.Widget>[
                              pw.Expanded(
                                child: pw.Text(
                                  testNameList[index],
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  entryItemList[index].entryItemData +
                                      " " +
                                      testUnitList[index],
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  testRangeList[index],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: entryItemList.length,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(thickness: 1.0),
              pw.Center(
                child: pw.Text(
                  orgAddress.text,
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Directory tempDir = await getDownloadsDirectory();
    String tempPath = tempDir.path + '/Report';
    if (await io.Directory(tempPath).exists()) {
      final file = File(tempPath +
          '/' +
          entryData.entryName +
          '_report' +
          entryData.entryId.toString() +
          ".pdf");
      await file.writeAsBytes(await doc.save());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          'Report has been saved in Downloads folder!',
          textAlign: TextAlign.center,
        ),
      ));
    } else {
      await io.Directory(tempPath).create();
      final file = File(tempPath +
          '/' +
          entryData.entryName +
          '_report' +
          entryData.entryId.toString() +
          ".pdf");
      await file.writeAsBytes(await doc.save());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          'Report has been saved in Downloads folder!',
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  @override
  void initState() {
    getOrgData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (testRangeList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Report'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                getPdf();
              },
              icon: Icon(Icons.print),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              ////Org Section
              Center(
                child: Text(
                  orgName.text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black),
                ),
              ),
              Divider(thickness: 2.0, color: Colors.black),
              Container(
                child: Column(
                  children: <Widget>[
                    NewWidget(
                        name: 'Ref by: Dr. ${docData.doctorName}',
                        data: 'Name: ${entryData.entryName}'),
                    NewWidget(
                        name: 'Age: ${entryData.entryAge}',
                        data: 'Gender: ${entryData.entryGender}'),
                    NewWidget(
                      name: 'Test performed by:',
                      data: 'Dr. ${orgOwner.text}',
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2.0, color: Colors.black),

              ////Test Section
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Test Name',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Result',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Range',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  testNameList[index],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entryItemList[index].entryItemData +
                                      " " +
                                      testUnitList[index],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  testRangeList[index],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: entryItemList.length,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1.0, color: Colors.black),
              Center(
                child: Text(
                  orgAddress.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class NewWidget extends StatelessWidget {
  NewWidget({
    @required this.name,
    @required this.data,
  });

  final name;
  final data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: Text(
            data,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

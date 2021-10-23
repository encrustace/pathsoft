import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/model/doc_model.dart';
import 'package:pathsoft/model/test_model.dart';
import 'package:pathsoft/view/home.dart';

class NewEntry extends StatefulWidget {
  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _entryName = TextEditingController();
  TextEditingController _entryAge = TextEditingController();
  TextEditingController _entryGender = TextEditingController();
  TextEditingController _entryAddress = TextEditingController();
  TextEditingController _entryDiscount = TextEditingController();

  List<DoctorModel> doctList = [];
  List<TestModel> testList = [];
  List<int> selectedTestId = [];
  int selectedDoc;
  int entryShare = 0;
  int totalPrice = 0;

  @override
  void initState() {
    _entryGender.text = 'Male';
    getTest();
    getDoctor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Enrty'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _entryName,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.userAlt),
                              labelText: 'Name',
                              hintText: 'Patient name',
                              hintStyle: TextStyle(color: Colors.black45),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Required' : null,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            autofocus: false,
                            controller: _entryAge,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.birthdayCake),
                              hintText: 'xx',
                              labelText: 'Age',
                              hintStyle: TextStyle(color: Colors.black45),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _entryAddress,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.home),
                              labelText: 'Address',
                              hintText: 'Village/Town',
                              hintStyle: TextStyle(color: Colors.black45),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Required' : null,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _entryDiscount,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.percentage),
                              labelText: 'Discount',
                              hintText: 'XX',
                              hintStyle: TextStyle(color: Colors.black45),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: _entryGender.text,
                          groupValue: 'Male',
                          onChanged: (val) {
                            setState(() {
                              _entryGender.text = 'Male';
                            });
                          },
                        ),
                        Text('Male'),
                        Radio(
                          value: _entryGender.text,
                          groupValue: 'Female',
                          onChanged: (val) {
                            setState(() {
                              _entryGender.text = 'Female';
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.blue.withOpacity(0.5),
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                                value: testList[index].selected,
                                onChanged: (value) {
                                  setState(() {
                                    testList[index].selected = value;
                                    if (value) {
                                      selectedTestId
                                          .add(testList[index].testId);
                                      totalPrice = totalPrice +
                                          testList[index].testPrice;
                                    } else {
                                      selectedTestId
                                          .remove(testList[index].testId);
                                      totalPrice = totalPrice -
                                          testList[index].testPrice;
                                    }
                                  });
                                }),
                            Container(
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Category: ${testList[index].testCategory}',
                                    ),
                                    Text(
                                      'Name: ${testList[index].testName}',
                                    ),
                                    Text(
                                      'Range: ${testList[index].testRange}',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      );
                    },
                    itemCount: testList.length,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.all(8),
                        color: Colors.blue.withOpacity(0.5),
                        child: Row(
                          children: [
                            Radio(
                              value: doctList[index].doctorId,
                              groupValue: selectedDoc,
                              onChanged: (s) {
                                selectedDoc = doctList[index].doctorId;
                                entryShare = doctList[index].doctorShare;
                                setState(() {});
                              },
                            ),
                            Text(
                              '${doctList[index].doctorId}: ${doctList[index].doctorName}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: doctList.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!_formKey.currentState.validate()) {
            } else if (selectedDoc == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text(
                    'Please select doctor!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (selectedTestId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text(
                    'Please select atleast one test!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              saveEntryData();
            }
          },
          child: Icon(FontAwesomeIcons.upload)),
    );
  }

  ///////Methods/////////
  void getDoctor() async {
    List<Map> list = await database.rawQuery('''SELECT * FROM doctor''');
    for (var i = 0; i < list.length; i++) {
      doctList.add(
        DoctorModel(
          list[0]['doctor_id'],
          list[0]['doctor_name'],
          list[0]['doctor_dob'],
          list[0]['doctor_mobile'],
          list[0]['doctor_email'],
          list[0]['doctor_share'],
          list[0]['doctor_address'],
          list[0]['doctor_gender'],
        ),
      );
    }
    setState(() {});
  }

  getTest() async {
    List<Map> list = await database.rawQuery('''SELECT * FROM test''');
    for (var i = 0; i < list.length; i++) {
      testList.add(
        TestModel(
          list[i]['test_id'],
          list[i]['test_name'],
          list[i]['test_category'],
          list[i]['test_price'],
          list[i]['test_range'],
          list[i]['test_unit'],
          false,
        ),
      );
    }
    setState(() {});
  }

  Future<void> saveEntryData() async {
    int entryId;
    await database.transaction((txn) async => {
          entryId = await txn.rawInsert('''INSERT INTO entry(
              doctor_id,
              entry_name,
              entry_age,
              entry_gender,
              entry_address,
              entry_price,
              entry_status,
              entry_doc_status,
              entry_discount,
              entry_share,
              entry_date
            )
            VALUES(
              "$selectedDoc",
              "${_entryName.text}",
              ${int.parse(_entryAge.text)},
              "${_entryGender.text}",
              "${_entryAddress.text}",
              $totalPrice,
              "Pending",
              "Pending",
              ${int.parse(_entryDiscount.text)},
              $entryShare,
              "${DateTime.now().toString()}"
              )
            ''')
        });

    for (var i = 0; i < selectedTestId.length; i++) {
      await database.transaction((txn) async => {
            await txn.rawInsert('''INSERT INTO entry_item(
              entry_item_data,
              entry_id,
              test_id
            )
            VALUES(
              "NULL",
              $entryId,
              ${selectedTestId[i]}
              )
            ''')
          });
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Home(
                  pageNumber: 0,
                )),
        (Route<dynamic> route) => false);
  }

  ////Methods end////////////
}

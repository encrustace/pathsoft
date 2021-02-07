import 'package:flutter/material.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/view/home.dart';

class NewTest extends StatefulWidget {
  @override
  _NewTestState createState() => _NewTestState();
}

class _NewTestState extends State<NewTest> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _testName = TextEditingController();
  TextEditingController _testPrice = TextEditingController();
  TextEditingController _testRange = TextEditingController();
  String _testCat = 'Bio-Chemical';
  String _testUnit = 'mg/dl';

  void addTest() async {
    if (formKey.currentState.validate()) {
      await database.transaction((txn) async => {
            await txn.rawInsert('''INSERT INTO test(
              test_category,
              test_name,
              test_price,
              test_range,
              test_unit
            )
            VALUES(
              "$_testCat",
              "${_testName.text}",
              "${_testPrice.text}",
              "${_testRange.text}",
              "$_testUnit"
              )
            ''')
          });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home(pageNumber: 1,)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new test',
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
          ),
          color: Colors.blueAccent.withOpacity(0.5),
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(32),
              shrinkWrap: true,
              children: <Widget>[
                DropdownButton(
                  value: _testCat,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _testCat = newValue;
                    });
                  },
                  items: <String>[
                    'Bio-Chemical',
                    'Serology',
                    'Hematology',
                    'Urine'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _testName,
                        decoration: InputDecoration(
                          labelText: 'Test name',
                          hintStyle: TextStyle(color: Colors.black45),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value.isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton(
                        value: _testUnit,
                        elevation: 16,
                        underline: Container(),
                        onChanged: (newValue) {
                          setState(() {
                            _testUnit = newValue;
                          });
                        },
                        items: <String>[
                          'N/A',
                          'mg/dl',
                          'gm/dl',
                          'U/L',
                          'mEq/L',
                          'IU/L',
                          'HPF',
                          'cell/cu mm',
                          '%',
                          'mill/cu mm',
                          'lack/cu mm',
                          'fl',
                          'pg',
                          'min',
                          'sec'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _testPrice,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '00.00',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value.isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _testRange,
                  decoration: InputDecoration(
                    labelText: 'Range',
                    hintText: 'XX-YY',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value.isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: 24.0,
                ),
                ElevatedButton(
                  child: Text(
                    'Add',
                  ),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      addTest();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

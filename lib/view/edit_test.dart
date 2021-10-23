import 'package:flutter/material.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/view/home.dart';

class EditTest extends StatefulWidget {
  EditTest({
    @required this.testCat,
    @required this.testName,
    @required this.testUnit,
    @required this.testRange,
    @required this.testPrice,
    @required this.testId,
  });

  final testCat;
  final testName;
  final testUnit;
  final testRange;
  final testPrice;
  final testId;

  @override
  _EditTestState createState() => _EditTestState();
}

class _EditTestState extends State<EditTest> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _testName = TextEditingController();
  TextEditingController _testPrice = TextEditingController();
  TextEditingController _testRange = TextEditingController();
  String _testCat = 'Bio-Chemical';
  String _testUnit = 'mg/dl';

  void updateTest() async {
    if (formKey.currentState.validate()) {
      await database.rawUpdate('''UPDATE test SET
      test_name = "${_testName.text}",
      test_category = "$_testCat",
      test_unit = "$_testUnit",
      test_range = "${_testRange.text}",
      test_price = "${int.parse(_testPrice.text)}"
      WHERE test_id = ${widget.testId}
      ''');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home(pageNumber: 1,)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    _testCat = widget.testCat;
    _testName.text = widget.testName;
    _testUnit = widget.testUnit;
    _testRange.text = widget.testRange;
    _testPrice.text = widget.testPrice.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit test',
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
                    'Update',
                  ),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      updateTest();
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

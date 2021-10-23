import 'package:flutter/material.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/model/entry_item_model.dart';
import 'package:pathsoft/view/home.dart';


class EntryCompletion extends StatefulWidget {
  EntryCompletion({
    @required this.entryId,
  });
  final entryId;

  @override
  _EntryCompletionState createState() => _EntryCompletionState();
}

class _EntryCompletionState extends State<EntryCompletion> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EntryItemModel> entryItemList = [];
  List<String> testNameList = [];
  List<String> testUnitList = [];
  List<int> testIdList = [];
  List<TextEditingController> editContList;

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
      testIdList.add(list[0]['test_id']);
    }
    editContList =
        List.generate(testIdList.length, (index) => TextEditingController());
    setState(() {});
  }

  void updateEntryData() async {
    if (_formKey.currentState.validate()) {
      await database.rawUpdate(
          '''UPDATE entry SET entry_status = "Done" WHERE entry_id = ${widget.entryId}''');

      for (var i = 0; i < testIdList.length; i++) {
        await database.rawUpdate(
            '''UPDATE entry_item SET entry_item_data = "${editContList[i].text}" WHERE entry_item_id = ${entryItemList[i].entryItemId}''');
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home(pageNumber: 0,)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    getEntryItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (testNameList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Entry Completion',
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.blue.withOpacity(0.5),
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(top: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 350,
                          child: TextFormField(
                            controller: editContList[index],
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: testNameList[index],
                              hintStyle: TextStyle(color: Colors.black45),
                              border: OutlineInputBorder(),
                              prefixIcon: Container(
                                width: 100,
                                height: 65,
                                margin: EdgeInsets.only(right: 8),
                                color: Colors.blue.withOpacity(0.4),
                                child: Center(child: Text(testUnitList[index])),
                              ),
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: entryItemList.length,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            updateEntryData();
          },
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

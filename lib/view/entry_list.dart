import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/view/init_page.dart';
import 'package:pathsoft/widgets/entry_widget.dart';
import 'package:sqflite/sqflite.dart';

class EntryList extends StatefulWidget {
  @override
  _EntryListState createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  final _searchController = TextEditingController();

  bool _isSearch = false;

  Widget searchWidget() {
    if (_isSearch) {
      return Container(
        height: 40.0,
        margin: EdgeInsets.all(4),
        child: TextField(
          autofocus: false,
          onChanged: (val) {
            setState(() {});
          },
          controller: _searchController,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Patient name...',
              hintStyle: TextStyle(fontSize: 12)),
        ),
      );
    } else {
      return Container(
        height: 40.0,
        color: Colors.blue.withOpacity(0.5),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        child: Text('All entries are listed here!!'),
      );
    }
  }

  Future getEntryData() async {
    List<Map> list;
    try {
      var dbPath = await getDatabasesPath();
      String path = dbPath + '/database.db';
      Database database = await openDatabase(path);
      list = await database
          .rawQuery('''SELECT * FROM entry ORDER BY entry_id DESC''');
    } catch (err) {}
    if (list != null) {
      return list;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => InitPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getEntryData();
        setState(() {});
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 85,
                child: searchWidget(),
              ),
              Expanded(
                flex: 15,
                child: IconButton(
                    icon: Icon(FontAwesomeIcons.search),
                    onPressed: () {
                      setState(() {
                        if (_isSearch) {
                          _isSearch = false;
                        } else {
                          _isSearch = true;
                        }
                      });
                    }),
              )
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue.withOpacity(0.2),
                    margin: EdgeInsets.all(4),
                    child: FutureBuilder(
                      future: getEntryData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data.isEmpty) {
                          return Center(
                            child: Icon(Icons.clear),
                          );
                        }
                        final entries = snapshot.data;
                        List<EntryWidget> pendingEntryWidgetWidgetList = [];
                        for (var entry in entries) {
                          final pendingEntryWidget = EntryWidget(
                            eid: entry['entry_id'],
                            name: entry['entry_name'],
                            age: entry['entry_age'],
                            gender: entry['entry_gender'],
                            address: entry['entry_address'],
                            date: entry['entry_date'],
                            price: entry['entry_price'],
                            status: entry['entry_status'],
                            mIcon: FontAwesomeIcons.edit,
                          );
                          if (entry['entry_status'] == 'Pending' &&
                              entry['entry_name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase())) {
                            pendingEntryWidgetWidgetList
                                .add(pendingEntryWidget);
                          }
                        }
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return pendingEntryWidgetWidgetList[index];
                          },
                          itemCount: pendingEntryWidgetWidgetList.length,
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue.withOpacity(0.2),
                    margin: EdgeInsets.all(4),
                    child: FutureBuilder(
                      future: getEntryData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data.isEmpty) {
                          return Center(
                            child: Icon(Icons.clear),
                          );
                        }
                        final entries = snapshot.data;
                        List<EntryWidget> doneEntryWidgetWidgetList = [];
                        for (var entry in entries) {
                          final doneEntryWidget = EntryWidget(
                            eid: entry['entry_id'],
                            name: entry['entry_name'],
                            age: entry['entry_age'],
                            gender: entry['entry_gender'],
                            address: entry['entry_address'],
                            date: entry['entry_date'],
                            price: entry['entry_price'],
                            status: entry['entry_status'],
                            mIcon: FontAwesomeIcons.notesMedical,
                          );
                          if (entry['entry_status'] == 'Done' &&
                              entry['entry_name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase())) {
                            doneEntryWidgetWidgetList.add(doneEntryWidget);
                          }
                        }
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return doneEntryWidgetWidgetList[index];
                          },
                          itemCount: doneEntryWidgetWidgetList.length,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

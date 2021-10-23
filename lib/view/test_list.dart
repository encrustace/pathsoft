import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/widgets/test_widget.dart';

class TestList extends StatefulWidget {
  @override
  _TestListState createState() => _TestListState();
}

class _TestListState extends State<TestList> {
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
              hintText: 'Test name...',
              hintStyle: TextStyle(fontSize: 12)),
        ),
      );
    } else {
      return Container(
        height: 40.0,
        color: Colors.blue.withOpacity(0.5),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        child: Text('All tests are listed here!!'),
      );
    }
  }

  Future getTest() async {
    List<Map> list = await database.rawQuery('''SELECT * FROM test''');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getTest();
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
            child: FutureBuilder(
              future: getTest(),
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
                final tests = snapshot.data;
                List<TestWidget> testWidgetList = [];
                for (var test in tests) {
                  final testWidget = TestWidget(
                    testId: test['test_id'],
                    testCategory: test['test_category'],
                    testName: test['test_name'],
                    testRange: test['test_range'],
                    testUnit: test['test_unit'],
                    testPrice: test['test_price'],
                  );
                  if (test['test_name']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) {
                    testWidgetList.add(testWidget);
                  }
                }
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return testWidgetList[index];
                  },
                  itemCount: testWidgetList.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

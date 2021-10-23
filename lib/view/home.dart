import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/view/edit_path.dart';
import 'package:pathsoft/view/entry_list.dart';
import 'package:pathsoft/view/doctor_list.dart';
import 'package:pathsoft/widgets/float_button.dart';
import 'package:pathsoft/view/test_list.dart';

class Home extends StatefulWidget {
  Home({@required this.pageNumber});
  final pageNumber;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController pathId = TextEditingController();
  TextEditingController pathName = TextEditingController();
  TextEditingController pathOwner = TextEditingController();
  TextEditingController pathMobile = TextEditingController();
  TextEditingController pathEmail = TextEditingController();
  TextEditingController pathAddress = TextEditingController();
  int selectedIndex;
  List<StatefulWidget> widgetOptions = [
    EntryList(),
    TestList(),
    DoctorList(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> getPathData() async {
    selectedIndex = widget.pageNumber;
    await setConnection();
    List<Map> list = await database.rawQuery('''SELECT * FROM pathology''');
    pathId.text = list[0]['path_id'].toString();
    pathName.text = list[0]['path_name'];
    pathOwner.text = list[0]['path_owner'];
    pathMobile.text = list[0]['path_mobile'];
    pathEmail.text = list[0]['path_email'];
    pathAddress.text = list[0]['path_address'];
    widgetOptions = [
      EntryList(),
      TestList(),
      DoctorList(),
    ];
    setState(() {});
  }

  @override
  initState() {
    getPathData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pathName.text,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.userCircle),
              onPressed: () async {
                getPathData();
                showDialog(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return Dialog(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 250,
                          width: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(8),
                                color: Colors.blue.withOpacity(0.5),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.userAlt),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Text('Dr. ${pathOwner.text}'),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(8),
                                color: Colors.blue.withOpacity(0.5),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.clinicMedical),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Text(
                                      pathName.text,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(8),
                                color: Colors.blue.withOpacity(0.5),
                                child: Row(
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.city),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        pathAddress.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPath(
                                        pathId: pathId.text,
                                        pathOwner: pathOwner.text,
                                        pathMobile: pathMobile.text,
                                        pathEmail: pathEmail.text,
                                        pathName: pathName.text,
                                        pathAddress: pathAddress.text,
                                      ),
                                    ),
                                  ).then((value) => (_) {
                                        getPathData();
                                      });
                                },
                                child: Icon(FontAwesomeIcons.edit),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ],
      ),
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.list),
            label: "Entries",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.notesMedical),
            label: "Tests",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userMd),
            label: "Doctors",
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          onItemTapped(index);
        },
      ),
      floatingActionButton: CustomFloatButton(),
    );
  }
}

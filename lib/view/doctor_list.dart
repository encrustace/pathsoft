import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/widgets/doctor_widget.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  TextEditingController _searchController = TextEditingController();

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
              hintText: 'Doctor name..',
              hintStyle: TextStyle(fontSize: 12)),
        ),
      );
    } else {
      return Container(
        height: 40.0,
        color: Colors.blue.withOpacity(0.5),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        child: Text('All doctores are listed here!!'),
      );
    }
  }

  Future getDoctor() async {
    List<Map> list = await database.rawQuery('''SELECT * FROM doctor''');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getDoctor();
        setState(() {});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              future: getDoctor(),
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
                final doctors = snapshot.data;
                List<DoctorWidget> doctorWidgetList = [];
                for (var doctor in doctors) {
                  final doctorWidget = DoctorWidget(
                    doctorId: doctor['doctor_id'],
                    doctorName: doctor['doctor_name'],
                    doctorDob: doctor['doctor_dob'],
                    doctorGender: doctor['doctor_gender'],
                    doctorMobile: doctor['doctor_mobile'],
                    doctorEmail: doctor['doctor_email'],
                    doctorShare: doctor['doctor_share'],
                    doctorAddress: doctor['doctor_address'],
                  );
                  if (doctor['doctor_name']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) {
                    doctorWidgetList.add(doctorWidget);
                  }
                }

                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return doctorWidgetList[index];
                  },
                  itemCount: doctorWidgetList.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

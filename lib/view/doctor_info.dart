import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/view/edit_doctor.dart';

class DoctorInfo extends StatefulWidget {
  DoctorInfo({
    @required this.doctorId,
  });
  final doctorId;
  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> with TickerProviderStateMixin {
  TextEditingController doctorName = TextEditingController();
  TextEditingController doctorMobile = TextEditingController();
  TextEditingController doctorEmail = TextEditingController();
  TextEditingController doctorShare = TextEditingController();
  TextEditingController doctorAddress = TextEditingController();
  TextEditingController doctorDob = TextEditingController();
  TextEditingController doctorGender = TextEditingController();
  TabController _tabController;
  int totalRefs = 0;
  double pendingAmount = 0.0;
  double paidAmount = 0.0;

  Future getEntryData() async {
    List<Map> list = await database.rawQuery(
        '''SELECT * FROM entry WHERE doctor_id = ${widget.doctorId}''');
    totalRefs = list.length;
    setState(() {});
    return list;
  }

  Future<void> getDocData() async {
    List<Map> list = await database.rawQuery(
        '''SELECT * FROM doctor WHERE doctor_id = ${widget.doctorId}''');
    doctorName.text = list[0]['doctor_name'];
    doctorDob.text = list[0]['doctor_dob'];
    doctorMobile.text = list[0]['doctor_mobile'];
    doctorEmail.text = list[0]['doctor_email'];
    doctorShare.text = list[0]['doctor_share'].toString();
    doctorAddress.text = list[0]['doctor_address'];
    doctorGender.text = list[0]['doctor_gender'];
    getAmounts();
  }

  Future<void> getAmounts() async {
    List<Map> pendList = await database.rawQuery(
        '''SELECT SUM((entry_price - (entry_price * entry_discount)/100) * entry_share/100) AS mSum FROM entry WHERE doctor_id = ${widget.doctorId} AND entry_doc_status = "Pending"''');
    List<Map> paidList = await database.rawQuery(
        '''SELECT SUM((entry_price - (entry_price * entry_discount)/100) * entry_share/100) AS mSum FROM entry WHERE doctor_id = ${widget.doctorId} AND entry_doc_status = "Done"''');
    if (pendList[0]['mSum'] != null) {
      pendingAmount = double.parse(pendList[0]['mSum'].toString());
    }
    if (paidList[0]['mSum'] != null) {
      paidAmount = double.parse(paidList[0]['mSum'].toString());
    }
    setState(() {});
  }

  Future<void> updateAllEntry() async {
    await database.rawUpdate(
        '''UPDATE entry SET entry_doc_status = "Done" WHERE doctor_id = ${widget.doctorId}''');
    Navigator.pop(context);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getDocData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Details',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDoctor(
                    doctorId: widget.doctorId,
                    doctorName: doctorName.text,
                    doctorDob: doctorDob.text,
                    doctorMobile: doctorMobile.text,
                    doctorEmail: doctorEmail.text,
                    doctorShare: doctorShare.text,
                    doctorAddress: doctorAddress.text,
                    doctorGender: doctorGender.text,
                  ),
                ),
              ).then((value) => (_) {
                    getDocData();
                  });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.userMd,
                    size: 80.0,
                  ),
                  Text(
                    'Dr. ${doctorName.text}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DataFieldWidget(
                        name: 'Dr. ID',
                        value: widget.doctorId.toString(),
                      ),
                      DataFieldWidget(
                        name: 'Total refs',
                        value: totalRefs.toString(),
                      ),
                      DataFieldWidget(
                        name: 'Share',
                        value: '${doctorShare.text}%',
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext buildContext) {
                              return AlertDialog(
                                title: Center(
                                    child: Text(
                                  'Want to make all payment?',
                                )),
                                content: Text(
                                  'Total amount: $pendingAmount',
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      updateAllEntry();
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: DataFieldWidget(
                          name: 'Pending amount',
                          value: '₹$pendingAmount',
                        ),
                      ),
                      DataFieldWidget(
                        name: 'Paid amount',
                        value: '₹$paidAmount',
                      ),
                      DataFieldWidget(
                        name: 'Address',
                        value: doctorAddress.text,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        FontAwesomeIcons.clock,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        FontAwesomeIcons.list,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      FutureBuilder(
                        future: getEntryData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.clear),
                                  Text('No refs available')
                                ],
                              ),
                            );
                          }
                          final entries = snapshot.data;
                          List<DocRefsWidget> entryWidgetList = [];
                          for (var entry in entries) {
                            final entryWidget = DocRefsWidget(
                              entryId: entry['entry_id'],
                              entryDate: entry['entry_date'],
                              entryPrice: entry['entry_price'],
                              entryDiscount: entry['entry_discount'],
                              entryShare: entry['entry_share'],
                              entryDocStatus: entry['entry_doc_status'],
                              icon: FontAwesomeIcons.circle,
                            );
                            if (entry['entry_doc_status'] == 'Pending') {
                              entryWidgetList.add(entryWidget);
                            }
                          }
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return entryWidgetList[index];
                            },
                            itemCount: entryWidgetList.length,
                          );
                        },
                      ),
                      ////Second
                      FutureBuilder(
                        future: getEntryData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.clear),
                                  Text('No refs available')
                                ],
                              ),
                            );
                          }
                          final entries = snapshot.data;
                          List<DocRefsWidget> entryWidgetList = [];
                          for (var entry in entries) {
                            final entryWidget = DocRefsWidget(
                              entryId: entry['entry_id'],
                              entryDate: entry['entry_date'],
                              entryPrice: entry['entry_price'],
                              entryDiscount: entry['entry_discount'],
                              entryShare: entry['entry_share'],
                              entryDocStatus: entry['entry_doc_status'],
                              icon: FontAwesomeIcons.checkCircle,
                            );
                            if (entry['entry_doc_status'] == 'Done') {
                              entryWidgetList.add(entryWidget);
                            }
                          }
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return entryWidgetList[index];
                            },
                            itemCount: entryWidgetList.length,
                          );
                        },
                      ),
                    ],
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

class DocRefsWidget extends StatefulWidget {
  DocRefsWidget({
    @required this.entryId,
    @required this.entryDate,
    @required this.entryPrice,
    @required this.entryDiscount,
    @required this.entryShare,
    @required this.entryDocStatus,
    @required this.icon,
  });

  final entryId;
  final entryDate;
  final entryPrice;
  final entryDiscount;
  final entryShare;
  final entryDocStatus;
  final icon;

  @override
  _DocRefsWidgetState createState() => _DocRefsWidgetState();
}

class _DocRefsWidgetState extends State<DocRefsWidget> {
  double calcShare() {
    double discountPrice = widget.entryPrice * widget.entryDiscount / 100;
    double sharableAmount = widget.entryPrice - discountPrice;
    return sharableAmount * widget.entryShare / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Entry ID',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.entryId.toString(),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Entry Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatDate((DateTime.parse(widget.entryDate)),
                    [dd, '-', mm, '-', yyyy]),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${widget.entryPrice}',
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Doctor Share',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.entryShare}%',
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Patient Discount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.entryDiscount}%',
              ),
            ],
          ),
          IconButton(
            icon: Icon(widget.icon),
            onPressed: () {
              if (widget.entryDocStatus == 'Pending') {
                showDialog(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return AlertDialog(
                      title: Center(
                          child: Text(
                        'Make payment!',
                      )),
                      content: Text(
                        'Sharing amount: ${calcShare()}',
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            updateEntry();
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext buildContext) {
                    return AlertDialog(
                      title: Center(
                          child: Text(
                        'Already paid!',
                      )),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateEntry() async {
    await database.rawUpdate(
        '''UPDATE entry SET entry_doc_status = "Done" WHERE entry_id = ${widget.entryId}''');
    Navigator.pop(context);
  }
}

class DataFieldWidget extends StatelessWidget {
  DataFieldWidget({
    @required this.name,
    @required this.value,
  });

  final name;
  final value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
        ),
      ],
    );
  }
}

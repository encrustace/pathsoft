import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/view/home.dart';

class NewDoctor extends StatefulWidget {
  @override
  _NewDoctorState createState() => _NewDoctorState();
}

class _NewDoctorState extends State<NewDoctor> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _doctorName = TextEditingController();
  TextEditingController _doctorMobile = TextEditingController();
  TextEditingController _doctorEmail = TextEditingController();
  TextEditingController _doctorShare = TextEditingController();
  TextEditingController _doctorAddress = TextEditingController();
  TextEditingController _doctorDob = TextEditingController();
  TextEditingController _doctorGender = TextEditingController();

  @override
  void initState() {
    _doctorGender.text = 'Male';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new doc',
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.2,
              right: MediaQuery.of(context).size.width * 0.2,
              top: 24.0,
              bottom: 24.0),
          color: Colors.blueAccent.withOpacity(0.5),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(32.0),
              children: <Widget>[
                TextFormField(
                  autofocus: false,
                  controller: _doctorName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.userMd),
                    hintText: "Don't put 'Dr.' before Name.",
                    labelText: 'Name',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value.isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  autofocus: false,
                  controller: _doctorDob,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.birthdayCake),
                    hintText: 'yyyy-mm-dd',
                    labelText: 'DOB',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value.isEmpty ? 'Required' : null,
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1947),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.light(),
                          child: child,
                        );
                      },
                    );
                    setState(() {
                      if (d != null) {
                        _doctorDob.text = formatDate(
                            (DateTime.parse(d.toString())),
                            [yyyy, '-', mm, '-', dd]);
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  autofocus: false,
                  controller: _doctorMobile,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.mobileAlt),
                    border: OutlineInputBorder(),
                    labelText: 'Mobile',
                    hintText: 'Without country code.',
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required';
                    }
                    if (value.length > 10 || value.length < 10) {
                      return 'Number has ${value.length} digit, It must have 10 digit';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  autofocus: false,
                  controller: _doctorEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.mailBulk),
                    hintText: 'abc@example.com',
                    labelText: 'Email',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value.isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  autofocus: false,
                  controller: _doctorShare,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.percentage),
                    hintText: 'XX',
                    labelText: 'Share',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value.isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextFormField(
                  autofocus: false,
                  controller: _doctorAddress,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.home),
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    hintText: 'Location.',
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                  maxLines: null,
                  validator: (value) => value.isEmpty ? 'Required' : null,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: _doctorGender.text,
                      groupValue: 'Male',
                      onChanged: (val) {
                        setState(() {
                          _doctorGender.text = 'Male';
                        });
                      },
                    ),
                    Text(
                      'Male',
                    ),
                    Radio(
                      value: _doctorGender.text,
                      groupValue: 'Female',
                      onChanged: (val) {
                        setState(() {
                          _doctorGender.text = 'Female';
                        });
                      },
                    ),
                    Text(
                      'Female',
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                ElevatedButton(
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    addDoctor();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addDoctor() async {
    if (formKey.currentState.validate()) {
      await database.transaction((txn) async => {
            await txn.rawInsert('''INSERT INTO doctor(
              doctor_name,
              doctor_dob,
              doctor_mobile,
              doctor_email,
              doctor_share,
              doctor_address,
              doctor_gender
            )
            VALUES(
              "${_doctorName.text}",
              "${_doctorDob.text}",
              "${_doctorMobile.text}",
              "${_doctorEmail.text}",
              "${_doctorShare.text}",
              "${_doctorAddress.text}",
              "${_doctorGender.text}"
              )
            ''')
          });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home(pageNumber: 2,)),
          (Route<dynamic> route) => false);
    }
  }
}

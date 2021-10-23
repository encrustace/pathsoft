import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';


class EditDoctor extends StatefulWidget {
  EditDoctor({
    @required this.doctorId,
    @required this.doctorName,
    @required this.doctorDob,
    @required this.doctorMobile,
    @required this.doctorEmail,
    @required this.doctorShare,
    @required this.doctorAddress,
    @required this.doctorGender,
  });
  final doctorId;
  final doctorName;
  final doctorDob;
  final doctorMobile;
  final doctorEmail;
  final doctorShare;
  final doctorAddress;
  final doctorGender;
  @override
  _EditDoctorState createState() => _EditDoctorState();
}

class _EditDoctorState extends State<EditDoctor> {
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
    _doctorName.text = widget.doctorName;
    _doctorMobile.text = widget.doctorMobile;
    _doctorEmail.text = widget.doctorEmail;
    _doctorShare.text = widget.doctorShare.toString();
    _doctorAddress.text = widget.doctorAddress;
    _doctorDob.text = widget.doctorDob;
    _doctorGender.text = widget.doctorGender;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit doc details',
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
                    'Update',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    updateDoctor();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateDoctor() async {
    if (formKey.currentState.validate()) {
      if (formKey.currentState.validate()) {
        await database.rawUpdate('''UPDATE doctor SET
            doctor_name = "${_doctorName.text}",
            doctor_email = "${_doctorEmail.text}",
            doctor_gender = "${_doctorGender.text}",
            doctor_dob = "${_doctorDob.text}",
            doctor_mobile = "${_doctorMobile.text}",
            doctor_share = "${int.parse(_doctorShare.text)}",
            doctor_address = "${_doctorAddress.text}"
            WHERE doctor_id = ${widget.doctorId}
            ''');
        Navigator.pop(context);
      }
    }
  }
}

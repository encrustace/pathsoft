import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';

class EditPath extends StatefulWidget {
  EditPath({
    @required this.pathId,
    @required this.pathOwner,
    @required this.pathMobile,
    @required this.pathEmail,
    @required this.pathName,
    @required this.pathAddress,
  });

  final pathId;
  final pathOwner;
  final pathMobile;
  final pathEmail;
  final pathName;
  final pathAddress;
  @override
  _EditPathState createState() => _EditPathState();
}

class _EditPathState extends State<EditPath> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _pathOwner = TextEditingController();
  TextEditingController _pathMobile = TextEditingController();
  TextEditingController _pathEmail = TextEditingController();
  TextEditingController _pathName = TextEditingController();
  TextEditingController _pathAddress = TextEditingController();

  @override
  void initState() {
    _pathOwner.text = widget.pathOwner;
    _pathMobile.text = widget.pathMobile;
    _pathEmail.text = widget.pathEmail;
    _pathName.text = widget.pathName;
    _pathAddress.text = widget.pathAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.8),
      appBar: AppBar(
        title: Text('Edit pathology details'),
      ),
      body: Center(
        child: Container(
          color: Colors.white.withOpacity(0.5),
          width: 400,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(18.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    autofocus: false,
                    controller: _pathOwner,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.userMd),
                      hintText: "Don't put 'Dr.' before Name.",
                      labelText: 'Owner',
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
                    controller: _pathMobile,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.phone),
                      hintText: "9999999999",
                      labelText: 'Mobile',
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
                    controller: _pathEmail,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.mailBulk),
                      hintText: "abc@example.com",
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
                    controller: _pathName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.clinicMedical),
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      hintText: 'Without country code.',
                      hintStyle: TextStyle(color: Colors.black45),
                    ),
                    validator: (value) => value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _pathAddress,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.home),
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Pathology location.',
                      hintStyle: TextStyle(color: Colors.black45),
                    ),
                    maxLines: null,
                    validator: (value) => value.isEmpty ? 'Required' : null,
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
                      updatePath();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updatePath() async {
    if (formKey.currentState.validate()) {
      await database.rawUpdate('''UPDATE pathology SET
     path_name = "${_pathName.text}",
     path_owner = "${_pathOwner.text}",
     path_mobile = "${_pathMobile.text}",
     path_email = "${_pathEmail.text}",
     path_address = "${_pathAddress.text}"
     WHERE path_id = ${widget.pathId}
     ''');
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}

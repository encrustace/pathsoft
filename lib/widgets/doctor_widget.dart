import 'package:flutter/material.dart';
import 'package:pathsoft/view/doctor_info.dart';

class DoctorWidget extends StatelessWidget {
  DoctorWidget({
    @required this.doctorId,
    @required this.doctorName,
    @required this.doctorGender,
    @required this.doctorDob,
    @required this.doctorMobile,
    @required this.doctorEmail,
    @required this.doctorShare,
    @required this.doctorAddress,
  });

  final doctorId;
  final doctorName;
  final doctorGender;
  final doctorDob;
  final doctorMobile;
  final doctorEmail;
  final doctorShare;
  final doctorAddress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 120.0,
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(8),
        color: Colors.blue,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white.withOpacity(0.3),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorId.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Dr. ${doctorName.toString()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                color: Colors.white.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Mobile: $doctorMobile',
                      maxLines: 1,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Address: $doctorAddress',
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'DOB: $doctorDob',
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Gender: $doctorGender',
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorInfo(
              doctorId: doctorId,
            ),
          ),
        );
      },
    );
  }
}

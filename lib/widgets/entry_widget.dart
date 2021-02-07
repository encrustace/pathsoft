import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pathsoft/connection.dart';
import 'package:pathsoft/view/entry_completion.dart';
import 'package:pathsoft/view/invoice.dart';
import 'package:pathsoft/view/report.dart';


class EntryWidget extends StatefulWidget {
  EntryWidget({
    @required this.name,
    @required this.age,
    @required this.gender,
    @required this.address,
    @required this.date,
    @required this.eid,
    @required this.price,
    @required this.status,
    @required this.mIcon,
  });

  final name;
  final age;
  final gender;
  final address;
  final date;
  final eid;
  final price;
  final status;
  final mIcon;

  @override
  _EntryWidgetState createState() => _EntryWidgetState();
}

class _EntryWidgetState extends State<EntryWidget> {
  Future<void> deleteEntry() async {
    await database.rawDelete('''DELETE FROM entry WHERE entry_id = ${widget.eid}''');

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.blue,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            padding: EdgeInsets.all(8),
            color: Colors.white.withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name: ${widget.name}',
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                Text(
                  'Age: ${widget.age}',
                  maxLines: 1,
                ),
                Divider(),
                Text(
                  'Price: ₹ ${widget.price}',
                  maxLines: 1,
                ),
                Divider(),
                Text(
                  'Date: ' +
                      formatDate((DateTime.parse(widget.date)),
                          [dd, '-', mm, '-', yyyy]),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.fileInvoiceDollar,
                  size: 40.0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Invoice(
                        entryId: widget.eid,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  widget.mIcon,
                  size: 40.0,
                ),
                onPressed: () {
                  if (widget.status == 'Pending') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EntryCompletion(entryId: widget.eid),
                      ),
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Report(entryId: widget.eid)));
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.trash,
                  size: 40.0,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return AlertDialog(
                          title: Center(
                              child: Text(
                            'Delete!',
                          )),
                          content: Text(
                            'Are you sure?',
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                deleteEntry();
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
                      });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

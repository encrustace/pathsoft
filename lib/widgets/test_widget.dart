import 'package:flutter/material.dart';
import 'package:pathsoft/view/edit_test.dart';

class TestWidget extends StatelessWidget {
  TestWidget({
    @required this.testId,
    @required this.testCategory,
    @required this.testName,
    @required this.testRange,
    @required this.testUnit,
    @required this.testPrice,
  });

  final testId;
  final testCategory;
  final testName;
  final testRange;
  final testUnit;
  final testPrice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTest(
              testCat: testCategory,
              testName: testName,
              testUnit: testUnit,
              testRange: testRange,
              testPrice: testPrice,
              testId: testId,
            ),
          ),
        );
      },
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
                padding: EdgeInsets.all(8),
                width: double.infinity,
                color: Colors.white.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      testId.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Divider(),
                    Text(
                      testCategory,
                      textAlign: TextAlign.start,
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
              flex: 4,
              child: Container(
                  color: Colors.white.withOpacity(0.3),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Name: $testName',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        'Range: $testRange',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'Price: $testPrice',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

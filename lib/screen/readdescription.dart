import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../const/const.dart';

class Description extends StatelessWidget {
  final String head, descript, timestamp, time;

  const Description(
      {Key? key,
      required this.head,
      required this.descript,
      required this.timestamp,
      required this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime parsedTime = DateTime.parse(time);

    String formattedTime = DateFormat.Hm().format(parsedTime);
    DateTime parsedTimestamp = DateTime.parse(timestamp);

    String formattedTimestamp =
        DateFormat('yyyy-MM-dd HH:mm').format(parsedTimestamp);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: readTask.text
                          .color(Colors.white)
                          .fontWeight(FontWeight.bold)
                          .size(30)
                          .make(),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(Icons.backspace),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
                50.heightBox,
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 20.0,
                        spreadRadius: 5.0,
                        offset: Offset(
                          10.0,
                          15.0,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                'Title : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  head,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                  maxLines:
                                      10, // Set the maximum number of lines (adjust as needed)
                                ),
                              )
                            ],
                          )),
                      20.heightBox,
                      Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  descript,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                  maxLines:
                                      10, // Set the maximum number of lines (adjust as needed)
                                ),
                              )
                            ],
                          )),
                      10.heightBox,
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Edit : ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formattedTimestamp,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 20.0,
                        spreadRadius: 5.0,
                        offset: Offset(
                          10.0,
                          15.0,
                        ),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Time Notification : ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(formattedTime),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

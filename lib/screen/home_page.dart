import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../const/const.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FocusNode _textFieldFocus = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late String uid;

  @override
  void dispose() {
    _textFieldFocus.dispose();
    super.dispose();
  }

  bool isButtonOnTop = true;

  void toggleButtonPosition() {
    setState(() {
      isButtonOnTop = !isButtonOnTop;
    });
  }

  @override
  void initState() {
    _user = _auth.currentUser!;
    uid = _user.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var timeNow = DateTime.now();
    String formattedTime = DateFormat.yMMMMd('en_US').format(timeNow);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      child: appLogo.text
                          .fontWeight(FontWeight.bold)
                          .size(50)
                          .make()),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            orenge1,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide.none),
                          )),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      child: Text('Log Out'),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 60),
                    child: appLogo1.text
                        .fontWeight(FontWeight.bold)
                        .color(Colors.white)
                        .size(20)
                        .make(),
                  ),
                ],
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      formattedTime,
                      style:
                          TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              10.heightBox,
              Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(uid)
                      .collection('mytasks')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          String head = docs[index]['head'];
                          String selectedtime = docs[index]['selectedtime'];

                          var time =
                              (docs[index]['timestamp'] as Timestamp).toDate();

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Description(
                                          head: docs[index]['head'],
                                          descript: docs[index]['descript'],
                                          timestamp: docs[index]['timestamp'],
                                          time: selectedtime)));
                            },
                            child: Container(
                              child: Card(
                                child: ListTile(
                                  title: Text('Head: $head'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Last Edit : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              DateFormat.yMd()
                                                  .add_jm()
                                                  .format(time),
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                              softWrap: true,
                                              maxLines: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Time Notification: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              selectedtime,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                              softWrap: true,
                                              maxLines: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    height: 50,
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditTask(
                                                          taskDocument:
                                                              docs[index],
                                                        )));
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(uid)
                                                .collection('mytasks')
                                                .doc(docs[index]['time'])
                                                .delete();
                                          },
                                          icon: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 2))),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
        )),

        //***********************************************
        floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 61, 60, 60),
              borderRadius: BorderRadius.all(Radius.circular(100))),
          padding: EdgeInsets.all(30),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddTask()));
            },
            child: Text(
              'ADD',
              style: TextStyle(color: orenge1, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        floatingActionButtonLocation: isButtonOnTop
            ? FloatingActionButtonLocation.centerFloat
            : FloatingActionButtonLocation.endFloat,

        //***********************************************
      ),
    );
  }
}

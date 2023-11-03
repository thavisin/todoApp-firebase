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
                          String descript = docs[index]['descript'];
                          // String time = docs[index]['formattedtime'];
                          var time =
                              (docs[index]['timestamp'] as Timestamp).toDate();

                          return Card(
                            child: ListTile(
                              title: Text('Head: $head'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Description: $descript'),
                                  Row(
                                    children: [
                                      Text("Time Edit : "),
                                      Text(DateFormat.yMd()
                                          .add_jm()
                                          .format(time)),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(uid)
                                        .collection('mytasks')
                                        .doc(docs[index]['time'])
                                        .delete();
                                  },
                                  icon: Icon(Icons.delete)),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        )),

        //***********************************************
        floatingActionButton: FloatingActionButton(
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
        floatingActionButtonLocation: isButtonOnTop
            ? FloatingActionButtonLocation.endDocked
            : FloatingActionButtonLocation.endFloat,

        //***********************************************
      ),
    );
  }
}

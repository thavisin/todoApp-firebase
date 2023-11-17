import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../const/const.dart';

class Addgoal extends StatefulWidget {
  const Addgoal({super.key});

  @override
  State<Addgoal> createState() => _AddgoalState();
}

class _AddgoalState extends State<Addgoal> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late String uid;
  TextEditingController goalController = TextEditingController();

  @override
  void initState() {
    _user = _auth.currentUser!;
    uid = _user.uid;
    super.initState();
  }

  addgoaltofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mygoals')
        .doc()
        .set({
      'goals': goalController.text,
      'time': time.toString(),
    });
    goalController.clear();
    Fluttertoast.showToast(msg: 'Goal Added');
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
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      child: Text(
                    "Goals in this week",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              20.heightBox,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(uid)
                              .collection('mygoals')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                  String goal = docs[index]['goals'];

                                  return Container(
                                    child: Text(
                                      goal,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontSize: 20),
                                      softWrap: true,
                                      maxLines: 10,
                                    ),
                                  );
                                },
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
              10.heightBox,
              Container(
                child: TextField(
                  controller: goalController,
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: "Your Goals",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    child: Text('Add Goals'),
                    onPressed: (() {
                      addgoaltofirebase();
                    }),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    child: Text('Clear Goals'),
                    onPressed: (() async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('tasks')
                          .doc(uid)
                          .collection('mygoals')
                          .get();

                      for (QueryDocumentSnapshot documentSnapshot
                          in querySnapshot.docs) {
                        await documentSnapshot.reference.delete();
                      }
                    }),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}

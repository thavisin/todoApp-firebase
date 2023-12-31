import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../const/const.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController headController = TextEditingController();
  TextEditingController descriptController = TextEditingController();
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = DateTime.now();
  }

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    String hm = DateFormat.Hm().format(selectedTime);

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'head': headController.text,
      'descript': descriptController.text,
      'time': time.toString(),
      'timestamp': time,
      'selectedtime': hm.toString()
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }

  noselecttime() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    var nopick = '--:--:--';

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'head': headController.text,
      'descript': descriptController.text,
      'time': time.toString(),
      'timestamp': time,
      'selectedtime': nopick
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }

  bool visiBle = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: headTask.text
                              .color(Colors.white)
                              .fontWeight(FontWeight.bold)
                              .size(40)
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
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: headController,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: "Head Task",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    20.heightBox,
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: descriptController,
                        maxLines: 10,
                        decoration: InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    20.heightBox,
                    Switch(
                      value: visiBle,
                      activeColor: orenge1,
                      onChanged: (bool value) {
                        setState(() {
                          visiBle = value;
                        });
                      },
                    ),
                    if (visiBle)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ALERT TIME : "),
                          CupertinoButton(
                              child: Text(
                                "${selectedTime.hour}:${selectedTime.minute}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) => SizedBox(
                                          height: 250,
                                          child: CupertinoDatePicker(
                                            backgroundColor: Colors.black,
                                            initialDateTime: selectedTime,
                                            onDateTimeChanged:
                                                (DateTime newTime) {
                                              setState(() {
                                                selectedTime = newTime;
                                              });
                                            },
                                            use24hFormat: true,
                                            mode: CupertinoDatePickerMode.time,
                                          ),
                                        ));
                              }),
                        ],
                      ),
                    50.heightBox,
                    Container(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              orenge1,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide.none),
                            )),
                        child: Text('Add Task'),
                        onPressed: () {
                          if (visiBle) addtasktofirebase();
                          if (!visiBle) noselecttime();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

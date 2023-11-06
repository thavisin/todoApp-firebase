import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../const/const.dart';

class EditTask extends StatefulWidget {
  final DocumentSnapshot taskDocument;

  EditTask({required this.taskDocument});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController headController = TextEditingController();
  TextEditingController descriptController = TextEditingController();
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = DateTime.now();
    fetchTaskDetails();
  }

  void fetchTaskDetails() {
    final taskData = widget.taskDocument.data() as Map<String, dynamic>;

    setState(() {
      headController.text = taskData['head'];
      descriptController.text = taskData['descript'];
    });
  }

  void editTaskInFirebase() async {
    await widget.taskDocument.reference.update({
      'head': headController.text,
      'descript': descriptController.text,
      'timestamp': DateTime.now(),
      'selectedtime': selectedTime
    }).then((_) {
      Fluttertoast.showToast(msg: 'Data Edited');
      Navigator.of(context).pop();
    }).catchError((error) {
      print("Error updating document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: editTask.text
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
                TextField(
                  controller: headController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "Head Task",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: descriptController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                20.heightBox,
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
                                      onDateTimeChanged: (DateTime newTime) {
                                        setState(
                                          () => selectedTime = newTime,
                                        );
                                      },
                                      use24hFormat: true,
                                      mode: CupertinoDatePickerMode.time,
                                    ),
                                  ));
                        }),
                  ],
                ),
                SizedBox(height: 20),
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
                  child: Text('Edit Task'),
                  onPressed: editTaskInFirebase,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

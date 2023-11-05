import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  final DocumentSnapshot taskDocument;

  EditTask({required this.taskDocument});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController headController = TextEditingController();
  TextEditingController descriptController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
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
    );
  }
}

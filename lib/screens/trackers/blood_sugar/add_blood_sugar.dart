import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_app/models/tracker.dart';
import 'package:elderly_app/screens/trackers/blood_sugar/blood_sugar_tracker_screen.dart';
import 'package:elderly_app/widgets/app_default.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBloodSugarScreen extends StatefulWidget {
  @override
  _AddBloodSugarScreenState createState() => _AddBloodSugarScreenState();
}

class _AddBloodSugarScreenState extends State<AddBloodSugarScreen> {
  final _trackerKey = GlobalKey<FormState>();
  TextEditingController bloodSugar, notes;
  BloodSugarTracker bloodSugarTracker;

  @override
  void initState() {
    bloodSugarTracker = BloodSugarTracker();
    bloodSugar = TextEditingController(text: '');
    notes = TextEditingController(text: '');
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Text(
                  'Add Blood Sugar Data',
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xff3d5afe),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _trackerKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: bloodSugar,
                      decoration: InputDecoration(
                        hintText: 'Blood sugar in mg/dL',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                      ),
                      onChanged: (v) {
                        _trackerKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter value';
                        } else {
                          if (!isNumeric(value)) {
                            return 'Enter numeric value';
                          }

                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      onChanged: (v) {
                        _trackerKey.currentState.validate();
                      },
                      controller: notes,
                      decoration: InputDecoration(
                        hintText: 'Notes about Blood Sugar ',
                        border: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter value';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            // RaisedButton.icon(
            //     color: Color(0xff3d5afe),
            //     onPressed: () async {
            //       _trackerKey.currentState.validate();
            //       await saveData();
            //       Navigator.pop(context);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => BloodSugarTrackerScreen()));
            //     },
            //     textColor: Colors.white,
            //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)),
            //     icon: Icon(Icons.add),
            //     label: Text('Add Data')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recommended value .'),
            )
          ],
        ),
      ),
      appBar: ElderlyAppBar(),
      drawer: AppDrawer(),
    );
  }

  saveData() async {
    bloodSugarTracker.bloodSugar = BloodSugar(
        bloodSugar: int.parse(bloodSugar.text),
        notes: notes.text,
        dateTime: DateTime.now());
    await Firestore.instance
        .collection('tracker')
        .document(userId)
        .collection('blood_sugar')
        .add(bloodSugarTracker.toMap());
  }

  getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });
  }

  String userId;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tangteevs/profile/Profile.dart';
import 'package:tangteevs/profile/profileback.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../helper/helper_function.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

import 'package:image_picker/image_picker.dart';

class EditAct extends StatefulWidget {
  final String postid;
  const EditAct({Key? key, required this.postid}) : super(key: key);

  @override
  _EditActState createState() => _EditActState();
}

class _EditActState extends State<EditAct> {
  final user = FirebaseAuth.instance.currentUser;
  String activityName = "";
  String place = "";
  String location = "";
  String detail = "";
  String people = "";
  DatabaseService databaseService = DatabaseService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  final CollectionReference _post =
      FirebaseFirestore.instance.collection('post');

  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _peopleLimitController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  var postData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postid)
          .get();

      postData = postSnap.data()!;

      _activityNameController.text = postData['activityName'].toString();
      _dateController.text = postData['date'].toString();
      _detailController.text = postData['detail'].toString();
      _locationController.text = postData['location'].toString();
      _peopleLimitController.text = postData['peopleLimit'].toString();
      _placeController.text = postData['place'].toString();
      _timeController.text = postData['time'].toString();

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: mobileSearchColor),
                onPressed: () => {nextScreen(context, MyHomePage())},
              ),
              toolbarHeight: 120,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                "Edit Activity",
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: purple,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: unselected,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
              ),
              // ignore: prefer_const_constructors
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(-20),
                child: const Text("แก้ไขกิจกรรมของคุณ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: unselected)),
              ),
            ),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: mobileBackgroundColor,
                  ))
                : Container(
                    color: mobileBackgroundColor,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                width: 360,
                                child: TextFormField(
                                  controller: _activityNameController,
                                  decoration: textInputDecorationp.copyWith(
                                      hintText: 'Activity Name',
                                      prefixIcon: Icon(
                                        Icons.title,
                                        color: lightPurple,
                                        //color: Theme.of(context).primaryColor,
                                      )),
                                  validator: (val) {
                                    if (val!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "plase Enter Activity Name";
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      activityName = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _placeController,
                                decoration: textInputDecorationp.copyWith(
                                    hintText: 'place',
                                    prefixIcon: Icon(
                                      Icons.maps_home_work,
                                      color: lightPurple,
                                    )),
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "plase Enter Your Place";
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    place = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _locationController,
                                decoration: textInputDecorationp.copyWith(
                                  hintText: 'location',
                                  prefixIcon: Icon(
                                    Icons.place,
                                    color: lightPurple,
                                  ),
                                ),
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "plase Enter Your location";
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    location = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _dateController,
                                decoration: textInputDecorationp.copyWith(
                                  hintText: 'Date',
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: lightPurple,
                                  ),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101));

                                  if (pickedDate != null) {
                                    print(pickedDate);
                                    String formattedDate =
                                        DateFormat('yyyy/MM/dd')
                                            .format(pickedDate);
                                    print(formattedDate);

                                    setState(() {
                                      _dateController.text = formattedDate;
                                    });
                                  } else {
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _timeController,
                                decoration: textInputDecorationp.copyWith(
                                  hintText: "Time)",
                                  prefixIcon: Icon(
                                    Icons.query_builder,
                                    color: lightPurple,
                                  ),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    print(pickedTime.format(context));
                                    setState(() {
                                      _timeController.text = pickedTime.format(
                                          context); //set the value of text field.
                                    });
                                  } else {
                                    print("Time is not selected");
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _detailController,
                                decoration: textInputDecorationp.copyWith(
                                    hintText: 'Detail',
                                    prefixIcon: Icon(
                                      Icons.pending,
                                      color: lightPurple,
                                    )),
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "plase Enter Your Place";
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    detail = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _peopleLimitController,
                                decoration: textInputDecorationp.copyWith(
                                    hintText: 'People Limit',
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: lightPurple,
                                    )),
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "plase Enter Your Place";
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    people = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: mobileBackgroundColor,
                                  side: const BorderSide(
                                    width: 2.0,
                                    color: Colors.purple,
                                  ),
                                  minimumSize: const Size(307, 49),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "save",
                                style: TextStyle(
                                    color: Colors.purple, fontSize: 24),
                              ),
                              onPressed: () {
                                Updata();
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
  }

  Updata() async {
    final String activityName = _activityNameController.text;
    final String place = _placeController.text;
    final String location = _locationController.text;
    final String date = _dateController.text;
    final String time = _timeController.text;
    final String detail = _detailController.text;
    final String peopleLimit = _peopleLimitController.text;

    if (_formKey.currentState!.validate()) {
      await _post.doc(widget.postid).update({
        'activityName': activityName,
        'place': place,
        'location': location,
        'date': date,
        'time': time,
        'detail': detail,
        'peopleLimit': peopleLimit,
        'timeStamp': FieldValue.serverTimestamp(),
      });

      _activityNameController.text = '';
      _placeController.text = '';
      _locationController.text = '';
      _dateController.text = '';
      _timeController.text = '';
      _detailController.text = '';
      _peopleLimitController.text = '';

      nextScreen(context, MyHomePage());
    }
  }
}

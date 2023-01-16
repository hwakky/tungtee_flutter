import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/model/post_model.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:tangteevs/helper/helper_function.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';

import 'utils/color.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool _isLoading = false;
  final _post = FirebaseFirestore.instance.collection('post').doc();

  final _formKey = GlobalKey<FormState>();
  // late String _activityName;
  // late String _place;
  // late String _location;
  // late DateTime _date;
  // late TimeOfDay _time;
  // late String _detail;
  // late int _peopleLimit;
  // late final uid = FirebaseAuth.instance.currentUser?.uid;

  final _activityName = TextEditingController();
  final _place = TextEditingController();
  final _location = TextEditingController();
  final dateController = TextEditingController();
  final _time = TextEditingController();
  final _detail = TextEditingController();
  final _peopleLimit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              elevation: 1,
              centerTitle: true,
              title: Text(
                'Create Event',
                style: TextStyle(color: unselected),
              )),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _activityName,
                    decoration: InputDecoration(labelText: 'Activity Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid activity name';
                      }
                      return null;
                    },
                    //onSaved: (value) => _activityName = value!,
                  ),

                  TextFormField(
                    controller: _place,
                    decoration: InputDecoration(labelText: 'Place'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid place';
                      }
                      return null;
                    },
                    //onSaved: (value) => _place = value!,
                  ),
                  // Add a Google Maps widget to select the location
                  // ...

                  TextFormField(
                    controller: _location,
                    decoration: InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid location';
                      }
                      return null;
                    },
                    //onSaved: (value) => _location = value!,
                  ),

                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter Date"),
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
                            DateFormat('yyyy/MM/dd').format(pickedDate);
                        print(formattedDate);

                        setState(() {
                          dateController.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),

                  TextField(
                    controller: _time,
                    decoration: const InputDecoration(
                        icon: Icon(
                          Icons.query_builder,
                        ),
                        labelText: 'Time'),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        print(pickedTime.format(context));
                        // DateTime parsedTime = DateFormat.jm()
                        //     .parse(pickedTime.format(context).toString());
                        // String formattedTime =
                        //     DateFormat('HH:mm:ss').format(parsedTime);
                        // print(formattedTime);
                        setState(() {
                          _time.text = pickedTime
                              .format(context); //set the value of text field.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),

                  TextFormField(
                    controller: _detail,
                    decoration: InputDecoration(labelText: 'Detail'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid detail';
                      }
                      return null;
                    },
                    //onSaved: (value) => _detail = value!,
                  ),

                  TextFormField(
                      controller: _peopleLimit,
                      decoration: InputDecoration(labelText: 'People Limit'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid people limit';
                        } else if (int.parse(value) >= 100) {
                          return 'people must less than 100';
                        } else {
                          return null;
                        }
                      }),

                  const SizedBox(
                    height: 32,
                    width: 22,
                  ),
                  ElevatedButton(
                    child: Text("Post"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() == true) {
                        setState(() {
                          _isLoading = true;
                        });
                        await _post.set({
                          'postid': _post.id,
                          'activityName': _activityName.text,
                          'place': _place.text,
                          'location': _location.text,
                          'date': dateController.text,
                          'time': _time.text,
                          'detail': _detail.text,
                          'peopleLimit': _peopleLimit.text,
                          'likes': [],
                          'timeStamp': FieldValue.serverTimestamp(),
                          'uid': FirebaseAuth.instance.currentUser?.uid,
                        }).whenComplete(() {
                          nextScreenReplaceOut(context, MyHomePage());
                        });
                        //await _post.set(post);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // post() async {
  //   if (_formKey.currentState!.validate() == true) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await _post.add({
  //       //'postid': datasnapchot.key,
  //       'activityName': _activityName.text,
  //       'place': _place.text,
  //       'location': _location.text,
  //       'date': dateController.text,
  //       'time': _time.text,
  //       'detail': _detail.text,
  //       'peopleLimit': _peopleLimit.text,
  //       'timeStamp': FieldValue.serverTimestamp(),
  //       'uid': FirebaseAuth.instance.currentUser?.uid,
  //     }).whenComplete(() {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (_) => FeedPage()));
  //     });
  //   }
  // }

  void initState() {
    dateController.text = "";
    _time.text = "";
    super.initState();
  }
}

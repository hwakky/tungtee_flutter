import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';

import '../HomePage.dart';
import '../helper/helper_function.dart';
import 'Login.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController _controllerDisplayname = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();
  TextEditingController _controllerGender = TextEditingController();
  TextEditingController _controllerInformation = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('profile');
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Profile",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _controllerDisplayname,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Displayname'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Displayname';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _controllerAge,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter age'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _controllerGender,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter gender'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter gender';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _controllerInformation,
                    decoration:
                        const InputDecoration(hintText: 'Enter Information'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Information';
                      }

                      return null;
                    },
                  ),
                  IconButton(
                      onPressed: () async {
                        /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                        /*Step 1:Pick image*/
                        //Install image_picker
                        //Import the corresponding library

                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.camera);
                        print('${file?.path}');

                        if (file == null) return;
                        //Import dart:core
                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        /*Step 2: Upload to Firebase storage*/
                        //Install firebase_storage
                        //Import the library

                        //Get a reference to storage root
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('images');

                        //Create a reference for the image to be stored
                        Reference referenceImageToUpload =
                            referenceDirImages.child('name');

                        //Handle errors/success
                        try {
                          //Store the file
                          await referenceImageToUpload.putFile(File(file.path));
                          //Success: get the download URL
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (error) {
                          //Some error occurred
                        }
                      },
                      icon: const Icon(Icons.camera_alt)),
                  ElevatedButton(
                      onPressed: () async {
                        if (imageUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please upload an image')));
                          return;
                        }
                        if (key.currentState!.validate()) {
                          String Displayname = _controllerDisplayname.text;
                          String Age = _controllerAge.text;
                          String Gender = _controllerGender.text;
                          String Information = _controllerInformation.text;

                          //Create a Map of data
                          Map<String, String> dataToSend = {
                            'Displayname': Displayname,
                            'Age': Age,
                            'Gender': Gender,
                            'Information': Information,
                            'image': imageUrl,
                          };

                          //Add a new item
                          _reference.add(dataToSend);
                          nextScreenReplace(context, MyHomePage());
                        }
                      },
                      child: const Text('Submit')),
                  Text.rich(TextSpan(
                    text: "มีบัญชีแล้วหรอ? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: " เข้าสู่ระบบ",
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, Login());
                            }),
                    ],
                  )),
                ],
              )),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../helper/helper_function.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';
import 'idcard.dart';

class RegisnextPage extends StatefulWidget {
  final String uid;
  const RegisnextPage({Key? key, required this.uid}) : super(key: key);

  @override
  _RegisnextPageState createState() => _RegisnextPageState();
}

class _RegisnextPageState extends State<RegisnextPage> {
  DatabaseService databaseService = DatabaseService();
  String Displayname = "";
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  String bio = "";
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  final TextEditingController _DisplaynameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String _ImageProfileController = '';
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  File? media1;

  var userData = {};
  var postLen = 0;
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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      _DisplaynameController.text = userData['Displayname'].toString();
      _ageController.text = userData['age'].toString();
      _genderController.text = userData['gender'].toString();
      _bioController.text = userData['bio'].toString();
      _ImageProfileController = userData['profile'].toString();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            color: purple,
            shadows: [
              Shadow(
                blurRadius: 5,
                color: Colors.grey,
                offset: Offset(3, 3),
              ),
            ],
          ),
        ),
        // ignore: prefer_const_constructors
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-20),
          child: const Text("แก้ไขข้อมูลส่วนตัวของคุณ",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: unselected)),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        print('${file?.path}');

                        if (file == null) return;
                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('Profile');
                        Reference referenceImageToUpload =
                            referenceDirImages.child("${user?.uid}");
                        try {
                          //Store the file
                          await referenceImageToUpload.putFile(File(file.path));
                          //  Success: get the download URL
                          _ImageProfileController =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (error) {
                          //Some error occurred
                        }
                        setState(() {
                          media1 = File(file.path);
                        });
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: media1 != null
                                ? Image.file(media1!)
                                : Image.asset('assets/images/profile.png')),
                      ),
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: 360,
                        child: TextFormField(
                          controller: _DisplaynameController,
                          decoration: textInputDecorationp.copyWith(
                              hintText: "Display Name",
                              prefixIcon: Icon(
                                Icons.person_pin_circle_sharp,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "plase Enter Display Name";
                            }
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: textInputDecorationp.copyWith(
                                  hintText: "Age",
                                  prefixIcon: Icon(
                                    Icons.cake,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "plase Enter Your Age";
                                } else if (int.parse(val) < 15) {
                                  return 'Age must be 15 or older';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _genderController,
                              readOnly: true,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _genderController.text = 'Male';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('Male'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _genderController.text = 'Female';

                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('Female'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _genderController.text = 'Other';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('Other'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              enableInteractiveSelection: false,
                              decoration: textInputDecorationp.copyWith(
                                hintText: 'Select Gender',
                                prefixIcon: Icon(
                                  Icons.wc_sharp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 360,
                      child: TextFormField(
                        controller: _bioController,
                        maxLines: 5,
                        decoration: textInputDecorationp.copyWith(
                            hintText: 'bio',
                            prefixIcon: Icon(
                              Icons.pending,
                              color: Theme.of(context).primaryColor,
                            )),
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "plase Enter Your bio";
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        alignment: Alignment.center,
                        width: 360,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              minimumSize: const Size(307, 49),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            Updata();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Updata() async {
    final String Displayname = _DisplaynameController.text;
    final String age = _ageController.text;
    final String gender = _genderController.text;
    final String bio = _bioController.text;
    final String ImageProfile = _ImageProfileController.toString();

    if (_formKey.currentState!.validate()) {
      await _users.doc(widget.uid).update({
        "Displayname": Displayname,
        "age": age,
        "gender": gender,
        "bio": bio,
        "profile": ImageProfile,
      });
      _DisplaynameController.text = '';
      _bioController.text = '';
      _ageController.text = '';
      _genderController.text = '';
      _ImageProfileController = '';
      nextScreen(context, MyHomePage());
    }
  }
}

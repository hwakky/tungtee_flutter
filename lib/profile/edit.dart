import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/profile/Profile.dart';
import 'package:tangteevs/profile/profileback.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../helper/helper_function.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

import 'package:image_picker/image_picker.dart';

class EditPage extends StatefulWidget {
  final String uid;
  const EditPage({Key? key, required this.uid}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  ImagePicker imagePicker = ImagePicker();
  String _ImageProfileController = '';
  File? media1;

  final user = FirebaseAuth.instance.currentUser;
  DatabaseService databaseService = DatabaseService();
  String Displayname = "";
  bool _isLoading = false;
  String bio = "";
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  final TextEditingController _DisplaynameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  var userData = {};
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
      _bioController.text = userData['bio'].toString();
      _genderController.text = userData['gender'].toString();
      _instagramController.text = userData['instagram'].toString();
      _facebookController.text = userData['facebook'].toString();
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
    return isLoading
        ? const Center()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: mobileSearchColor),
                onPressed: () => {nextScreen(context, MyHomePage())},
              ),
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
                      color: unselected,
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
                        fontSize: 16,
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
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: purple,
                                        )),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.transparent,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: media1 != null
                                            ? Image.file(media1!)
                                            : Image.network(
                                                userData['profile'].toString(),
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: primaryColor,
                                        ),
                                        color: lightPurple,
                                      ),
                                      child: Ink(
                                        child: Icon(
                                          Icons.edit,
                                          color: primaryColor,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _DisplaynameController,
                                decoration: textInputDecorationp.copyWith(
                                    hintText: 'Display Name',
                                    prefixIcon: Icon(
                                      Icons.person_pin_circle_sharp,
                                      color: lightPurple,
                                      //color: Theme.of(context).primaryColor,
                                    )),
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "plase Enter Display Name";
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    Displayname = val;
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
                                  color: lightPurple,
                                ),
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
                              controller: _bioController,
                              maxLines: 3,
                              decoration: textInputDecorationp.copyWith(
                                  hintText: 'bio',
                                  prefixIcon: Icon(
                                    Icons.pending,
                                    color: lightPurple,
                                  )),
                              validator: (val) {
                                if (val!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "plase Enter Your bio";
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  bio = val;
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
                              controller: _instagramController,
                              decoration: textInputDecorationp.copyWith(
                                  hintText: "link(option)",
                                  prefixIcon: Image.asset(
                                      'assets/images/instagram.png')),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 360,
                            child: TextFormField(
                              controller: _facebookController,
                              decoration: textInputDecorationp.copyWith(
                                  hintText: "link(option)",
                                  prefixIcon: Image.asset(
                                      'assets/images/facebook.png')),
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
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 24),
                            ),
                            onPressed: () {
                              Updata();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          );
  }

  Widget bottomSheet() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.camera,
                    color: lightPurple,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.image,
                    color: lightPurple,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    XFile? file = await imagePicker.pickImage(
      source: source,
    );
    // print('${file?.path}');

    if (file == null) return;

    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('Profile');
      Reference referenceImageToUpload =
          referenceDirImages.child("${user?.uid}");
      //Store the file
      await referenceImageToUpload.putFile(File(file.path));
      //  Success: get the download URL
      _ImageProfileController = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
    setState(() {
      media1 = File(file.path);
    });
  }

  Updata() async {
    final String Displayname = _DisplaynameController.text;
    final String bio = _bioController.text;
    final String instagram = _instagramController.text;
    final String facebook = _facebookController.text;
    final String gender = _genderController.text;
    final String ImageProfile = _ImageProfileController.toString();
    if (_formKey.currentState!.validate()) {
      await _users.doc(widget.uid).update({
        "Displayname": Displayname,
        "bio": bio,
        "gender": gender,
        "instagram": instagram,
        "facebook": facebook,
        "profile": ImageProfile,
      });
      _DisplaynameController.text = '';
      _bioController.text = '';
      _instagramController.text = '';
      _facebookController.text = '';
      _genderController.text = '';
      _ImageProfileController = '';
      nextScreen(context, MyHomePage());
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/profile/Profile.dart';
import 'package:tangteevs/profile/profileback.dart';
import 'package:tangteevs/regis,login/firestore.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../helper/helper_function.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

class EditPage extends StatefulWidget {
  final String uid;
  const EditPage({Key? key, required this.uid}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
  final TextEditingController _twitterController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

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
      _bioController.text = userData['bio'].toString();
      _instagramController.text = userData['instagram'].toString();
      _facebookController.text = userData['facebook'].toString();
      _twitterController.text = userData['twitter'].toString();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                                color: Theme.of(context).primaryColor,
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
                            prefixIcon:
                                Image.asset('assets/images/instagram.png')),
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
                            prefixIcon:
                                Image.asset('assets/images/facebook.png')),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 360,
                      child: TextFormField(
                        controller: _twitterController,
                        decoration: textInputDecorationp.copyWith(
                            hintText: "link(option)",
                            prefixIcon:
                                Image.asset('assets/images/twitter.png')),
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
                        style: TextStyle(color: Colors.purple, fontSize: 24),
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

  Updata() async {
    final String Displayname = _DisplaynameController.text;
    final String bio = _bioController.text;
    final String instagram = _instagramController.text;
    final String facebook = _facebookController.text;
    final String twitter = _twitterController.text;
    if (_formKey.currentState!.validate()) {
      await _users.doc(widget.uid).update({
        "Displayname": Displayname,
        "bio": bio,
        "instagram": instagram,
        "facebook": facebook,
        "twitter": twitter
      });
      _DisplaynameController.text = '';
      _bioController.text = '';
      _instagramController.text = '';
      _facebookController.text = '';
      _twitterController.text = '';
      nextScreen(context, MyHomePage());
    }
  }
}

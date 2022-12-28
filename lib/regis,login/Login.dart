import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/regis,login/Register.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:tangteevs/helper/helper_function.dart';
import '../admin/home.dart';
import '../services/reset_password.dart';

class Login extends StatefulWidget {
  String? get uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  _LoginState createState() => _LoginState();
}

late Stream<QuerySnapshot> _stream;

class _LoginState extends State<Login> {
  var auth = FirebaseAuth.instance;
  bool isLogin = false;
  bool isChecked = false;
  var userData = {};
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  final _auth = FirebaseAuth.instance;
  final dbRef =
      FirebaseFirestore.instance.collection('users').doc('admin').get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 219,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200)),
              image: DecorationImage(
                  image: AssetImage("assets/images/login.png"),
                  fit: BoxFit.fill)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  children: [
                    // AppBar(
                    //  centerTitle: true,
                    //   flexibleSpace: Container(
                    //       decoration: const BoxDecoration(
                    //          image: DecorationImage(
                    //    image: AssetImage("assets/login.png"),
                    //   )))),
                    //Image.asset("assets/login.png"),
                    const SizedBox(
                      height: 245,
                    ),
                    const Text(
                      "WELCOME BACK",
                      style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MyCustomFont',
                          color: lightestGreen),
                    ),
                    const SizedBox(
                      height: 05,
                    ),
                    const Text(
                      "เข้าสู่ระบบด้วยบัญชีของคุณเลย",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'MyCustomFont',
                          color: primaryColor),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 360,
                      child: TextFormField(
                        controller: emailController,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Email  ',
                          prefixIcon: const Icon(
                            Icons.account_circle,
                            color: green,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),

                    Container(
                      alignment: Alignment.center,
                      width: 360,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: green,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              primary: primaryColor,
                            ),
                            onPressed: () {
                              nextScreen(context, ResetPasswordPage());
                            },
                            child: const Text("ลืมรหัสผ่าน?"))
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    //ElevatedButton.icon(
                    // onPressed: () {
                    //   login();
                    // },
                    // icon: const Icon(Icons.lock_open),
                    // label: const Text('Login'),
                    // ),
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
                        "Login",
                        style: TextStyle(color: Colors.purple, fontSize: 24),
                      ),
                      onPressed: () {
                        login();
                      },
                    ),

                    //TextButton(
                    // onPressed: () =>
                    //    Navigator.pushNamed(context, '/register'),
                    // child: const Text('ยังไม่มีบัญชีหรอ? สมัครใช้งาน'),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text.rich(TextSpan(
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'MyCustomFont'),
                      children: <TextSpan>[
                        TextSpan(
                            text: "ยังไม่มีบัญชีหรอ?",
                            style: const TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.none),
                            recognizer: TapGestureRecognizer()),
                        TextSpan(
                            text: "สมัครใช้งาน",
                            style: const TextStyle(
                                color: Colors.lightGreen,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreen(context, const RegisterPage());
                              }),
                      ],
                    )),
                  ],
                ),
              ),
            ),
    );
  }

  List<String> docIDs = [];
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          var snap = await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();
          userData = snap.data()!;
          var a = userData['admin'];
          if (a == true) {
            nextScreenReplace(context, AdminHomePage());
          } else {
            nextScreenReplace(context, MyHomePage());
          }
          //nextScreenReplace(context, MyHomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

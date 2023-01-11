import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tangteevs/regis,login/idcard.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:tangteevs/helper/helper_function.dart';
import '../utils/color.dart';
import 'Login.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegisterPage> {
  bool isChecked = false;
  File? media;
  File? media1;
  bool _isLoading = false;
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String password2 = "";
  String fullName = "";
  AuthService authService = AuthService();
  String Displayname = "";
  String age = "";
  String gender = "";
  String Imageidcard = "";
  String ImageProfile = "";
  String bio = "";
  String instagram = "";
  String facebook = "";
  String twitter = "";
  String day = "";
  String month = "";
  String year = "";
  bool verify = false;
  bool isadmin = false;
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = 'Select Gender';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 120,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "REGISTER",
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
          child: const Text("สร้างบัญชีของคุณเลยสิ",
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
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              ExactAssetImage("assets/images/background.png"),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 35,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360,
                          child: TextFormField(
                            decoration: textInputDecorationp.copyWith(
                                hintText: "Username",
                                prefixIcon: Icon(
                                  Icons.person_pin_circle_sharp,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "Name cannot be empty";
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360,
                          child: TextFormField(
                            decoration: textInputDecorationp.copyWith(
                                hintText: "Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },

                            // check tha validation
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          alignment: Alignment.center,
                          width: 360,
                          child: TextFormField(
                            obscureText: true,
                            decoration: textInputDecorationp.copyWith(
                                hintText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360,
                          child: TextFormField(
                            obscureText: true,
                            decoration: textInputDecorationp.copyWith(
                                hintText: "Confirm Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                            validator: (val) {
                              if (password == password2) {
                                return null;
                              } else {
                                return "Password does not match";
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                password2 = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 55,
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Text(
                                    'Next',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'MyCustomFont'),
                                  ), // <-- Text
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Icon(
                                    // <-- Icon
                                    Icons.navigate_next_sharp,
                                    size: 26.0,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                register();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "มีบัญชีแล้วหรอ? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
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
                    ),
                  )),
            ),
    );
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
              fullName,
              email,
              password,
              Imageidcard,
              age,
              ImageProfile,
              Displayname,
              gender,
              bio,
              isadmin,
              verify,
              facebook,
              twitter,
              instagram,
              day,
              month,
              year)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserImageidcardSF(Imageidcard);
          await HelperFunctions.saveUserAgeSF(age);
          await HelperFunctions.saveUserImageprofileSF(ImageProfile);
          await HelperFunctions.saveUserDisplaySF(Displayname);
          await HelperFunctions.saveUserGenderSF(gender);
          await HelperFunctions.saveUserBioSF(bio);

          nextScreen(
              this.context,
              IdcardPage(
                uid: FirebaseAuth.instance.currentUser!.uid,
              ));
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

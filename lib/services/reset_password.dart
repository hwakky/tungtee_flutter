import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tangteevs/utils/color.dart';

import '../regis,login/Login.dart';
import '../widgets/custom_textfield.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        toolbarHeight: 150,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/reset.png"),
                  fit: BoxFit.scaleDown)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //  Image.asset("assets/images/reset.png"),
              const Text("Reset password",
                  style: TextStyle(
                      fontSize: 51,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyCustomFont',
                      color: lightGreen)),
              const SizedBox(
                height: 15,
              ),
              const Text("Don’t worry! It happens.",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyCustomFont',
                      color: primaryColor)),
              const Text(
                  "Plase enter Your E-mail address to reset you password\n",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyCustomFont',
                      color: primaryColor)),
              const SizedBox(
                height: 35,
              ),
              Container(
                alignment: Alignment.center,
                width: 360,
                child: TextField(
                  controller: _emailController,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Your E-mail',
                    hintStyle: const TextStyle(),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: green,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: primaryColor,
                    side: const BorderSide(
                      width: 2.0,
                      color: Colors.purple,
                    ),
                    minimumSize: const Size(307, 49),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: const Text(
                  "Send",
                  style: TextStyle(color: Colors.purple, fontSize: 24),
                ),
                onPressed: () {
                  String email = _emailController.text;
                  _auth.sendPasswordResetEmail(email: email).then((value) {
                    print('Password reset email sent');
                    _showResetEmailSentDialog();
                  }).catchError((error) {
                    print('Error sending password reset email: $error');
                    _showErrorDialog();
                  });
                },
              ),
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
                      text: "กลับสู่หน้า",
                      style: const TextStyle(
                          color: primaryColor, decoration: TextDecoration.none),
                      recognizer: TapGestureRecognizer()),
                  TextSpan(
                      text: "เข้าสู่ระบบ",
                      style: const TextStyle(
                          color: lightGreen,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          nextScreen(context, Login());
                        }),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Email Sent'),
          content: Text(
              'Check your email for instructions on how to reset your password.'),
          actions: [
            TextButton(
              onPressed: () {
                nextScreen(context, Login());
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error Sending Email'),
          content: Text('No email match. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

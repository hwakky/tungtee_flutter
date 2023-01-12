import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/landing.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';

import 'admin/home.dart';

class Log extends StatefulWidget {
  const Log({super.key});

  String? get uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  var auth = FirebaseAuth.instance;
  bool isLogin = false;

  var admin = const AdminHomePage();
  var aser = MyHomePage();

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLogin ? aser : const LandingPage(),
    );
  }
}

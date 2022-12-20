import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/firebase_options.dart';
import 'Login.dart';
import 'Register.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => Login(),
      '/register': (context) => RegistrationScreen(),
      '/HomePage': (context) => MyHomePage(),
    },
  ));
}

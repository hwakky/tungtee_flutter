import 'package:firebase_auth/firebase_auth.dart';
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
      '/register': (context) => RegisterPage(),
      '/HomePage': (context) => MyHomePage(),
    },
  ));
}
class MainPage extends StatefulWidget {
  const MainPage({super.key});
@override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage>{
@override
Widget build(BuildContext context){
  return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges()
    ,builder: (context, snapshot) {
      if (snapshot.hasData){
        return MyHomePage();
      }else{
        return Login();
      }
    } );
}
}

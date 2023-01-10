import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/admin/user/data.dart';
import 'package:tangteevs/admin/user/verify.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: mobileBackgroundColor,
          elevation: 1,
          leadingWidth: 130,
          centerTitle: true,
          title: const Text('test'),
          leading: Container(
            padding: const EdgeInsets.all(0),
            child: Image.asset('assets/images/logo with name.png',
                fit: BoxFit.scaleDown),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: purple,
                size: 30,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                nextScreenReplaceOut(context, const LandingPage());
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: green,
            labelColor: green,
            labelPadding: EdgeInsets.symmetric(horizontal: 30),
            unselectedLabelColor: unselected,
            labelStyle: TextStyle(
                fontSize: 20.0, fontFamily: 'MyCustomFont'), //For Selected tab
            unselectedLabelStyle: TextStyle(
                fontSize: 20.0,
                fontFamily: 'MyCustomFont'), //For Un-selected Tabs
            tabs: [
              Tab(text: 'Verify'),
              Tab(text: 'Data'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            verify(),
            data(),
          ],
        ),
      ),
    );
  }
}

class verify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VerifyPage(),
    );
  }
}

class data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataPage(),
    );
  }
}

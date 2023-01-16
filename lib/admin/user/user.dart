import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/admin/user/data.dart';
import 'package:tangteevs/admin/user/verify.dart';
import 'package:tangteevs/profile/profileback.dart';
import '../../Profile/Profile.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                title: Center(
                  child: Text(
                    'Go to User page',
                    style: TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                  ),
                ),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MyHomePage();
                      },
                    ),
                    (_) => false,
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                title: const Center(
                    child: Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                      color: redColor),
                )),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  nextScreenReplaceOut(context, const LandingPage());
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                title: const Center(
                    child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: 'MyCustomFont',
                      fontSize: 20),
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                Icons.settings,
                color: purple,
                size: 30,
              ),
              onPressed: () {
                _showModalBottomSheet(context);
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
    return const MaterialApp(
      home: SearchUser(),
    );
  }
}

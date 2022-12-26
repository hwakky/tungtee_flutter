import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'services/auth_service.dart';
import 'landing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({Key? key, required, required this.uid}) : super(key: key) {
    _stream = _reference.snapshots();
  }
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('shopping_list');
  late Stream<QuerySnapshot> _stream;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  bool isSignedIn = false;

  final user = FirebaseAuth.instance.currentUser!;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> docIDs = [];
  AuthService authService = AuthService();

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

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            'username',
            style: TextStyle(color: mobileSearchColor),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: green,
                      backgroundImage:
                          const AssetImage('assets/images/profile.png'),
                      radius: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildStatColumn(20, 'age'),
                        buildStatColumn(20, 'gender'),
                        buildStatColumn(20, ''),
                      ],
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          // Sign out of Firebase
                          FirebaseAuth.instance.signOut();

                          // Push the landing page route and replace the current route
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LandingPage()),
                          );
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Logout")),
                  ],
                )
              ]),
            )
          ],
        ));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.green,
          ),
        ),
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class User {
  final String name;
  final String email;
  final String profileImageUrl;

  User(
      {required this.name, required this.email, required this.profileImageUrl});
}

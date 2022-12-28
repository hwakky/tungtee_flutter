import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/profile/edit.dart';
import 'package:tangteevs/profile/test.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../regis,login/Login.dart';
import '../widgets/custom_textfield.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

      // get post Length
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['Displayname'].toString(),
                style: const TextStyle(color: mobileSearchColor, fontSize: 24),
              ),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                  itemBuilder: (_) {
                    return const [
                      PopupMenuItem<String>(
                          value: "1", child: Text("Edit profile")),
                      PopupMenuItem<String>(value: "2", child: Text("Logout")),
                    ];
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: purple,
                  ),
                  onSelected: (i) {
                    if (i == "1") {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EditPage(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                            );
                          },
                        ),
                        (_) => false,
                      );
                    } else if (i == "2") {
                      FirebaseAuth.instance.signOut();
                      nextScreenReplaceOut(context, const LandingPage());
                    }
                  },
                ),
              ],
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: green,
                          backgroundImage: NetworkImage(
                            userData['profile'].toString(),
                          ),
                          radius: 60,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  top: 1,
                                  left: 30,
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'อายุ ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: unselected,
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    ),
                                    Text(
                                      userData['age'].toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: unselected,
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    ),
                                    const Text(
                                      ' ปี',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: unselected,
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 30,
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'เพศ ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: unselected,
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    ),
                                    Text(
                                      userData['gender'].toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: unselected,
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 30,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      userData['bio'].toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: unselected,
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     FirebaseAuth.instance.currentUser!.uid == widget.uid? EditProfile(
                              //       backgroundColor: mobileBackgroundColor,
                              //       borderColor: purple,
                              //       text: 'Edit Profile',
                              //       textColor: mobileSearchColor,
                              //       function: () {},
                              //     ):
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              SizedBox(
                width: 50,
                height: 50,
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: mobileBackgroundColor,
                      bottom: const TabBar(
                        indicatorColor: green,
                        labelColor: green,
                        unselectedLabelColor: unselected,
                        labelStyle: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'MyCustomFont'), //For Selected tab
                        unselectedLabelStyle: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'MyCustomFont'), //For Un-selected Tabs
                        tabs: [
                          Tab(text: 'Post'),
                          Tab(text: 'Review'),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('post')
                              .where('uid', isEqualTo: widget.uid)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];

                                return Container(
                                  child: Text(
                                    // (snap.data()! as dynamic)['activityName'],
                                    'love',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: unselected,
                                      fontFamily: 'MyCustomFont',
                                    ),
                                  ),
                                  // Image(
                                  //   image: NetworkImage((snap.data()!
                                  //       as dynamic)['activityName']),
                                  //   fit: BoxFit.cover,
                                  // ),
                                );
                              },
                            );
                          },
                        ),
                        ReviewPage(),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          );
  }
}

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // Add the content for the home tab here
        );
  }
}

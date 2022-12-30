import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/FeedPage.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/comment.dart';
import 'package:tangteevs/profile/Post.dart';
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
              SingleChildScrollView(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: const TabBar(
                            indicatorColor: green,
                            labelColor: green,
                            labelPadding: EdgeInsets.symmetric(horizontal: 30),
                            unselectedLabelColor: unselected,
                            labelStyle: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'MyCustomFont'), //For Selected tab
                            unselectedLabelStyle: TextStyle(
                                fontSize: 20.0,
                                fontFamily:
                                    'MyCustomFont'), //For Un-selected Tabs
                            tabs: [
                              Tab(text: 'Post'),
                              Tab(text: 'Review'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 338,
                          child: TabBarView(children: <Widget>[
                            Container(
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('post')
                                    .where('uid', isEqualTo: widget.uid)
                                    .get(),
                                builder: ((context, snapshot) {
                                  //onRefresh:_onRefresh;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const <Widget>[
                                            SizedBox(
                                              height: 30.0,
                                              width: 30.0,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount:
                                        (snapshot.data! as dynamic).docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot snap =
                                          (snapshot.data! as dynamic)
                                              .docs[index];

                                      var Mytext = new Map();
                                      Mytext['activityName'] = (snap.data()!
                                          as dynamic)['activityName'];
                                      Mytext['dateTime'] = (snap.data()!
                                              as dynamic)['date'] +
                                          '\t\t(' +
                                          (snap.data()! as dynamic)['time'] +
                                          ')';
                                      Mytext['place'] =
                                          (snap.data()! as dynamic)['place'];
                                      Mytext['location'] =
                                          (snap.data()! as dynamic)['location'];
                                      Mytext['peopleLimit'] = (snap.data()!
                                          as dynamic)['peopleLimit'];

                                      return SizedBox(
                                        height: 227,
                                        child: Card(
                                            clipBehavior: Clip.hardEdge,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 151, 150, 150),
                                                width: 2,
                                              ),
                                            ),
                                            margin: const EdgeInsets.all(10),
                                            child: SizedBox(
                                              width: 380,
                                              height: 190,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.00),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 290,
                                                            child: Text(
                                                                Mytext[
                                                                    'activityName'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'MyCustomFont',
                                                                  color:
                                                                      unselected,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2),
                                                            child: IconButton(
                                                              onPressed: (() {
                                                                //add action
                                                              }),
                                                              icon: const Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                color:
                                                                    unselected,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 7,
                                                            child: IconButton(
                                                              onPressed: (() {
                                                                //add action
                                                              }),
                                                              icon: const Icon(
                                                                Icons
                                                                    .more_horiz,
                                                                color:
                                                                    unselected,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text.rich(
                                                          TextSpan(children: <
                                                              InlineSpan>[
                                                        const TextSpan(
                                                          text: '',
                                                        ),
                                                        const WidgetSpan(
                                                          child: Icon(
                                                            Icons
                                                                .calendar_today,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                            text: '\t\t' +
                                                                Mytext[
                                                                    'dateTime'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'MyCustomFont',
                                                              color: unselected,
                                                            )),
                                                      ])),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text.rich(
                                                          TextSpan(children: <
                                                              InlineSpan>[
                                                        const TextSpan(
                                                          text: '',
                                                        ),
                                                        const WidgetSpan(
                                                          child: Icon(
                                                            Icons
                                                                .maps_home_work,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                            text: '\t\t' +
                                                                Mytext['place'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'MyCustomFont',
                                                              color: unselected,
                                                            )),
                                                      ])),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text.rich(
                                                          TextSpan(children: <
                                                              InlineSpan>[
                                                        const TextSpan(
                                                          text: '',
                                                        ),
                                                        const WidgetSpan(
                                                          child: Icon(
                                                            Icons.place,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                            text: '\t\t' +
                                                                Mytext[
                                                                    'location'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'MyCustomFont',
                                                              color: unselected,
                                                            )),
                                                      ])),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text.rich(
                                                          TextSpan(children: <
                                                              InlineSpan>[
                                                        const TextSpan(
                                                          text: '',
                                                        ),
                                                        const WidgetSpan(
                                                          child: Icon(
                                                            Icons
                                                                .person_outline,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                            text: '\t\t' +
                                                                '0 / ' +
                                                                Mytext[
                                                                    'peopleLimit'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'MyCustomFont',
                                                              color: unselected,
                                                            )),
                                                      ])),
                                                      Row(
                                                        children: [
                                                          const SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1),
                                                              child: SizedBox(
                                                                width: 265,
                                                                height: 25,
                                                                child: Text(
                                                                    'add tag+',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'MyCustomFont',
                                                                      color:
                                                                          unselected,
                                                                    )),
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Comment(),
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                                'See More >>',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'MyCustomFont',
                                                                  color: green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ),
                            Container(
                              child: const Center(
                                child: Text('Review',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ]),
                        )
                      ]),
                ),
              ),
            ]),
          );
  }
}

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          Center(
            child: Text('Review'),
          )
        ],
      ),
    );
  }
}

class _PostPageState extends State<PostPage> {
  var postLen = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('post')
              .where('uid', isEqualTo: widget.uid)
              .get(),
          builder: ((context, snapshot) {
            //onRefresh:_onRefresh;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                var Mytext = new Map();
                Mytext['activityName'] =
                    (snap.data()! as dynamic)['activityName'];
                Mytext['dateTime'] = (snap.data()! as dynamic)['data'] +
                    '\t\t(' +
                    (snap.data()! as dynamic)['time'] +
                    ')';
                Mytext['place'] = (snap.data()! as dynamic)['place'];
                Mytext['location'] = (snap.data()! as dynamic)['location'];
                Mytext['peopleLimit'] =
                    (snap.data()! as dynamic)['peopleLimit'];

                return SizedBox(
                  height: 230,
                  child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 151, 150, 150),
                          width: 2,
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 380,
                        height: 190,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.00),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 290,
                                      child: Text(
                                          (snap.data()!
                                              as dynamic)['activityName'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'MyCustomFont',
                                            color: unselected,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: IconButton(
                                        onPressed: (() {
                                          //add action
                                        }),
                                        icon: const Icon(
                                          Icons.favorite_border,
                                          color: unselected,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                      child: IconButton(
                                        onPressed: (() {
                                          //add action
                                        }),
                                        icon: const Icon(
                                          Icons.more_horiz,
                                          color: unselected,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text.rich(TextSpan(children: <InlineSpan>[
                                  const TextSpan(
                                    text: '',
                                  ),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  TextSpan(
                                      text: '\t\t' +
                                          (snap.data()! as dynamic)['data'] +
                                          '\t\t(' +
                                          (snap.data()! as dynamic)['time'] +
                                          ')',
                                      style: const TextStyle(
                                        fontFamily: 'MyCustomFont',
                                        color: unselected,
                                      )),
                                ])),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text.rich(TextSpan(children: <InlineSpan>[
                                  const TextSpan(
                                    text: '',
                                  ),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.maps_home_work,
                                    ),
                                  ),
                                  TextSpan(
                                      text: '\t\t' +
                                          (snap.data()! as dynamic)['place'],
                                      style: const TextStyle(
                                        fontFamily: 'MyCustomFont',
                                        color: unselected,
                                      )),
                                ])),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text.rich(TextSpan(children: <InlineSpan>[
                                  const TextSpan(
                                    text: '',
                                  ),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.place,
                                    ),
                                  ),
                                  TextSpan(
                                      text: '\t\t' +
                                          (snap.data()! as dynamic)['location'],
                                      style: const TextStyle(
                                        fontFamily: 'MyCustomFont',
                                        color: unselected,
                                      )),
                                ])),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text.rich(TextSpan(children: <InlineSpan>[
                                  const TextSpan(
                                    text: '',
                                  ),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.person_outline,
                                    ),
                                  ),
                                  TextSpan(
                                      text: '\t\t' +
                                          '0 / ' +
                                          (snap.data()!
                                              as dynamic)['peopleLimit'],
                                      style: const TextStyle(
                                        fontFamily: 'MyCustomFont',
                                        color: unselected,
                                      )),
                                ])),
                                Row(
                                  children: [
                                    const SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: 265,
                                          height: 25,
                                          child: Text('add tag+',
                                              style: TextStyle(
                                                fontFamily: 'MyCustomFont',
                                                color: unselected,
                                              )),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Comment(),
                                          ),
                                        );
                                      },
                                      child: const Text('See More >>',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'MyCustomFont',
                                            color: green,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

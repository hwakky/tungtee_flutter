import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/FeedPage.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/comment.dart';
import 'package:tangteevs/profile/Post.dart';
import 'package:tangteevs/profile/edit.dart';
import 'package:tangteevs/profile/test.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../regis,login/Login.dart';
import '../widgets/custom_textfield.dart';

class PostPage extends StatefulWidget {
  final String uid;
  const PostPage({Key? key, required this.uid}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
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

  final CollectionReference _post =
      FirebaseFirestore.instance.collection('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _post.orderBy('timeStamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          //onRefresh:_onRefresh;
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                var Mytext = new Map();
                Mytext['activityName'] = documentSnapshot['activityName'];
                Mytext['dateTime'] = documentSnapshot['date'] +
                    '\t\t(' +
                    documentSnapshot['time'] +
                    ')';
                Mytext['place'] = documentSnapshot['place'];
                Mytext['location'] = documentSnapshot['location'];
                Mytext['peopleLimit'] = documentSnapshot['peopleLimit'];

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
                                      child: Text(Mytext['activityName'],
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
                                      text: '\t\t' + Mytext['dateTime'],
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
                                      text: '\t\t' + Mytext['place'],
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
                                      text: '\t\t' + Mytext['location'],
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
                                          Mytext['peopleLimit'],
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
          }
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
        },
      ),
    );
  }
}

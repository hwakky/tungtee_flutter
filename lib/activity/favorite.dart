import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/comment.dart';
import 'package:tangteevs/profile/edit.dart';
import 'package:tangteevs/profile/test.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../regis,login/Login.dart';
import '../widgets/custom_textfield.dart';

class FavoritePage extends StatefulWidget {
  final String uid;
  const FavoritePage({Key? key, required this.uid}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  var favoritesLen = 0;
  bool isLoading = false;

  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  final CollectionReference _favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> _delete(String usersId) async {
    await _favorites
        .doc(uid)
        .collection('favorites list')
        .doc(usersId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('favorites')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('favorites list')
            .where('postId', isEqualTo: widget.uid)
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
              Mytext['dateTime'] = (snap.data()! as dynamic)['date'] +
                  '\t\t(' +
                  (snap.data()! as dynamic)['time'] +
                  ')';
              Mytext['place'] = (snap.data()! as dynamic)['place'];
              Mytext['location'] = (snap.data()! as dynamic)['location'];
              Mytext['peopleLimit'] = (snap.data()! as dynamic)['peopleLimit'];

              return SizedBox(
                height: 247,
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
                                    text:
                                        '\t\t' + '0 / ' + Mytext['peopleLimit'],
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
                                          builder: (context) => Comment(
                                              postid:
                                                  snapshot.data!.docs[index]),
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
    );
  }
}

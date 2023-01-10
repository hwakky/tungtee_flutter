import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';
import 'package:tangteevs/widgets/custom_textfield.dart';

import '../comment/comment.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mobileBackgroundColor,
      body: PostCard(),
    );
  }
}

class PostCard extends StatelessWidget {
  final CollectionReference _favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> _delete(String usersId) async {
    await _favorites
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites list')
        .doc(usersId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _favorites
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favorites list')
          .snapshots(),
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
                      height: 200,
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
                                    child: FavoriteButton(
                                        iconSize: 45,
                                        isFavorite: true,
                                        iconDisabledColor: unselected,
                                        valueChanged: (_isFavorite) {
                                          if (_isFavorite == true) {
                                            var uid = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            FirebaseFirestore.instance
                                                .collection("favorites")
                                                .doc(uid)
                                                .collection('favorites list')
                                                .doc(documentSnapshot.id)
                                                .set({
                                              "activityName":
                                                  Mytext['activityName'],
                                              "dateTime": Mytext['dateTime'],
                                              "place": Mytext['place'],
                                              "location": Mytext['location'],
                                              "peopleLimit":
                                                  Mytext['peopleLimit'],
                                              "detail":
                                                  documentSnapshot['detail'],
                                              "uid": documentSnapshot['uid'],
                                              "postid":
                                                  documentSnapshot['postid'],
                                            });
                                          }
                                          if (_isFavorite == false) {
                                            _delete(documentSnapshot.id);
                                          }
                                        }),
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
                                      nextScreenReplace(
                                          context,
                                          Comment(
                                              postid: streamSnapshot
                                                  .data!.docs[index]));
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
    );
  }
}

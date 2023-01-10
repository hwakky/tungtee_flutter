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

class FeedPage extends StatelessWidget {
  FeedPage({Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 1,
        centerTitle: false,
        title: Image.asset(
          "assets/images/logo with name.png",
          width: 130,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: purple,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const SearchForm(),
    );
  }
}

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            //preferredSize: const Size.fromHeight(80),
            //child: AppBar(
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            backgroundColor: mobileBackgroundColor,
            elevation: 0,
            centerTitle: false,
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: 350.0,
                height: 45.0,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(width: 2, color: lightOrange),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(width: 1, color: orange),
                    ),
                    hintText: 'ค้นหากิจกรรม หรือ Tag ที่คุณสนใจ',
                    hintStyle: TextStyle(
                      color: unselected,
                      fontFamily: 'MyCustomFont',
                    ),
                    suffixIcon: Icon(
                      Icons.search_outlined,
                      color: orange,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Make for you"),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("New to you"),
                      ),
                    ];
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    color: green,
                    size: 30,
                  ),
                  onSelected: (value) {
                    if (value == 0) {
                      final snackBar = SnackBar(
                        content: const Text("Display feed for you"),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (value == 1) {
                      final snackBar = SnackBar(
                        content: const Text("Display new for you"),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }),
            ],
          ),
          //),
        ];
      },
      body: PostCard(),
    );
  }
}

class PostCard extends StatelessWidget {
  final CollectionReference _post =
      FirebaseFirestore.instance.collection('post');
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
                                        isFavorite: false,
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
                                              "postId": documentSnapshot.id,
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
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => Comment(
                                              postid: streamSnapshot
                                                  .data!.docs[index]),
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
    );
  }
}

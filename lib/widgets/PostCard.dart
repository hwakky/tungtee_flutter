import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import '../HomePage.dart';
import '../comment/comment.dart';
import '../utils/color.dart';
import '../services/auth_service.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math';
import '../feed/FeedPage.dart';
import 'package:flutter/src/widgets/framework.dart';

class CardWidget extends StatefulWidget {
  final snap;
  const CardWidget({required this.snap});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<CardWidget> {
  var postData = {};
  var userData = {};
  var currentUser = {};
  var commentLen = 0;
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
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.snap['postid'])
          .get();

      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();

      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // get post Length
      var commentSnap = await FirebaseFirestore.instance
          .collection('comments')
          .where('postid', isEqualTo: widget.snap['postid'])
          .get();

      commentLen = commentSnap.docs.length;
      postData = postSnap.data()!;
      userData = userSnap.data()!;
      currentUser = currentSnap.data()!;
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
  final CollectionReference _favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> _delete(String usersId) async {
    await _favorites
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites list')
        .doc(usersId)
        .delete();
  }

  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(
            color: unselected,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.all(15),
        child: SizedBox(
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
                        child: Text(widget.snap['activityName'],
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
                            iconSize: 38,
                            isFavorite: false,
                            iconDisabledColor: unselected,
                            valueChanged: (_isFavorite) {
                              if (_isFavorite == true) {
                                var uid =
                                    FirebaseAuth.instance.currentUser!.uid;
                                FirebaseFirestore.instance
                                    .collection("favorites")
                                    .doc(uid)
                                    .collection('favorites list')
                                    .doc(widget.snap.id)
                                    .set({
                                  "activityName": widget.snap['activityName'],
                                  "date": widget.snap['date'],
                                  "time": widget.snap['time'],
                                  "place": widget.snap['place'],
                                  "location": widget.snap['location'],
                                  "peopleLimit": widget.snap['peopleLimit'],
                                  "detail": widget.snap['detail'],
                                  "uid": widget.snap['uid'],
                                  "timeStamp": widget.snap['timeStamp'],
                                  "postid": widget.snap['postid'],
                                });
                              }
                              if (_isFavorite == false) {
                                _delete(widget.snap.id);
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
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
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
                              widget.snap['date'] +
                              '\t(' +
                              widget.snap['time'] +
                              ')',
                          style: const TextStyle(
                            fontFamily: 'MyCustomFont',
                            color: unselected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        const TextSpan(
                          text: '',
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.maps_home_work,
                          ),
                        ),
                        TextSpan(
                          text: '\t\t' + widget.snap['place'],
                          style: const TextStyle(
                            fontFamily: 'MyCustomFont',
                            color: unselected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        const TextSpan(
                          text: '',
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.place,
                          ),
                        ),
                        TextSpan(
                          text: '\t\t' + widget.snap['location'],
                          style: const TextStyle(
                            fontFamily: 'MyCustomFont',
                            color: unselected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        const TextSpan(
                          text: '',
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.person_outline,
                          ),
                        ),
                        TextSpan(
                          text: '\t\t' + '0 / ' + widget.snap['peopleLimit'],
                          style: const TextStyle(
                            fontFamily: 'MyCustomFont',
                            color: unselected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: SizedBox(
                            width: 260,
                            height: 25,
                            child: Text(
                              'add tag+',
                              style: TextStyle(
                                fontFamily: 'MyCustomFont',
                                color: unselected,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  Comment(postid: widget.snap),
                            ),
                          );
                        },
                        child: const Text(
                          'See More >>',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'MyCustomFont',
                            color: green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

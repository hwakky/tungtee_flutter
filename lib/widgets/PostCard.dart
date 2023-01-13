import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tangteevs/feed/EditAct.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void _showModalBottomSheet(BuildContext context, uid) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (postData['uid'].toString() == uid)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: Center(
                    child: Text(
                      'Edit Activity',
                      style:
                          TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return EditAct(
                            postid: widget.snap['postid'],
                          );
                        },
                      ),
                      (_) => false,
                    );
                  },
                ),
              if (postData['uid'].toString() == uid)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontFamily: 'MyCustomFont',
                          fontSize: 20,
                          color: redColor),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Delete Activity'),
                              content: Text(
                                  'Are you sure you want to permanently\nremove this Activity from Tungtee?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancle')),
                                TextButton(
                                    onPressed: (() {
                                      FirebaseFirestore.instance
                                          .collection('post')
                                          .doc(widget.snap['postid'])
                                          .delete()
                                          .whenComplete(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyHomePage(),
                                          ),
                                        );
                                      });
                                    }),
                                    child: Text('Delete'))
                              ],
                            ));
                  },
                ),
              if (postData['uid'].toString() != uid)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                      child: Text(
                    'Report',
                    style: TextStyle(
                        color: redColor,
                        fontFamily: 'MyCustomFont',
                        fontSize: 20),
                  )),
                  onTap: () {
                    Navigator.pop(context);
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

  final CollectionReference _post =
      FirebaseFirestore.instance.collection('post');
  final CollectionReference _favorites =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> post_delete(String postid) async {
    await _post.doc(postid).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a post activity')));
  }

  Future<void> _delete(String usersId) async {
    await _favorites
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites list')
        .doc(usersId)
        .delete();
  }

  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
                        width: 280,
                        child: Text(widget.snap['activityName'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'MyCustomFont',
                              color: unselected,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: FavoriteButton(
                            iconSize: 35,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: SizedBox(
                          child: IconButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              color: unselected,
                              size: 30,
                            ),
                            onPressed: (() {
                              //add action
                              _showModalBottomSheet(
                                  context, currentUser['uid']);
                            }),
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
                            fontSize: 14,
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
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 35,
                    child: Row(
                      children: [
                        Icon(
                          Icons.place,
                        ),
                        TextButton(
                          onPressed: () {
                            Uri uri = Uri.parse(widget.snap['location']);
                            _launchUrl(uri);
                          },
                          child: Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 14,
                              color: purple,
                            ),
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
                            fontSize: 14,
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
                            width: 240,
                            height: 25,
                            child: Text(
                              'add tag+',
                              style: TextStyle(
                                fontFamily: 'MyCustomFont',
                                color: unselected,
                                fontSize: 14,
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

  Future<void> _launchUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (_) {}
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
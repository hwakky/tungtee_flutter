import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tangteevs/feed/EditAct.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import '../HomePage.dart';
import '../utils/color.dart';
import '../services/auth_service.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math';

class Comment extends StatefulWidget {
  DocumentSnapshot postid;
  Comment({Key? key, required this.postid}) : super(key: key);

  @override
  _MyCommentState createState() => _MyCommentState();
}

class _MyCommentState extends State<Comment> {
  var postData = {};
  var userData = {};
  var currentUser = {};
  var commentLen = 0;
  bool isLoading = false;
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _onPress() {
    setState(() {
      _waiting = !_waiting;
    });
    // Do content here
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postid['postid'])
          .get();

      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.postid['uid'])
          .get();

      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // get post Length
      var commentSnap = await FirebaseFirestore.instance
          .collection('comments')
          .where('postid', isEqualTo: widget.postid['postid'])
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _comment =
      FirebaseFirestore.instance.collection('comments');
  final TextEditingController _commentController = TextEditingController();
  final commentSet = FirebaseFirestore.instance.collection('comments');

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : DismissKeyboard(
            child: MaterialApp(
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: mobileBackgroundColor,
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: unselected),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  elevation: 1,
                  centerTitle: false,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.more_horiz,
                        color: unselected,
                        size: 30,
                      ),
                      onPressed: () {
                        _showModalBottomSheet1(context, currentUser['uid']);
                      },
                    ),
                  ],
                ),
                body: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('post')
                        .orderBy('timeStamp', descending: true)
                        .where('postid', isEqualTo: widget.postid['postid'])
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];
                              return Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: green,
                                              backgroundImage: NetworkImage(
                                                userData['profile'].toString(),
                                              ),
                                              radius: 25,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.67,
                                              child: Text(
                                                  '\t\t' +
                                                      userData['Displayname'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'MyCustomFont',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                            Container(
                                              child: IconButton(
                                                icon: documentSnapshot['likes']
                                                        .contains(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 30,
                                                      )
                                                    : const Icon(
                                                        Icons.favorite_border,
                                                        size: 30,
                                                      ),
                                                onPressed: () => likePost(
                                                  documentSnapshot['postid']
                                                      .toString(),
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  documentSnapshot['likes'],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Card(
                                          clipBehavior: Clip.hardEdge,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 151, 150, 150),
                                              width: 0.5,
                                            ),
                                          ),
                                          //margin: const EdgeInsets.only(top: 15),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, top: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7,
                                                            child: Text(
                                                                documentSnapshot[
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
                                                          SizedBox(
                                                              child: Icon(Icons
                                                                  .person)),
                                                          Text.rich(TextSpan(
                                                              children: <
                                                                  InlineSpan>[
                                                                TextSpan(
                                                                    text: '\t' +
                                                                        '0 / ' +
                                                                        documentSnapshot[
                                                                            'peopleLimit'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontFamily:
                                                                          'MyCustomFont',
                                                                      color:
                                                                          unselected,
                                                                    )),
                                                              ])),
                                                        ],
                                                      ),
                                                    ),
                                                    Text.rich(TextSpan(
                                                        children: <InlineSpan>[
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
                                                              text:
                                                                  '${'\t\t' + documentSnapshot['date'] + '\t\t(' + documentSnapshot['time']})',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'MyCustomFont',
                                                                color:
                                                                    unselected,
                                                              )),
                                                        ])),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    Text.rich(TextSpan(
                                                        children: <InlineSpan>[
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
                                                                  documentSnapshot[
                                                                      'place'],
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'MyCustomFont',
                                                                color:
                                                                    unselected,
                                                              )),
                                                        ])),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    Text.rich(TextSpan(
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
                                                              text: '\t\t' +
                                                                  documentSnapshot[
                                                                      'location'],
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'MyCustomFont',
                                                                color:
                                                                    unselected,
                                                              )),
                                                        ])),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        child: Text(
                                                            '\nDetail\n\t\t\t\t\t' +
                                                                documentSnapshot[
                                                                    'detail'],
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'MyCustomFont',
                                                                color:
                                                                    unselected))),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    1),
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.64,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                              child: const Text(
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
                                                        if (FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid ==
                                                            documentSnapshot[
                                                                'uid'])
                                                          ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  lightGreen,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'Accepting',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'MyCustomFont',
                                                                color:
                                                                    unselected,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        if (FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid !=
                                                            documentSnapshot[
                                                                'uid'])
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              _onPress();
                                                              print(_waiting);
                                                              if (_waiting ==
                                                                  true) {
                                                                var uid =
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid;
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "activity")
                                                                    .doc(uid)
                                                                    .collection(
                                                                        'waiting list')
                                                                    .doc(widget
                                                                        .postid
                                                                        .id)
                                                                    .set({
                                                                  "activityName":
                                                                      widget.postid[
                                                                          'activityName'],
                                                                  "date": widget
                                                                          .postid[
                                                                      'date'],
                                                                  "time": widget
                                                                          .postid[
                                                                      'time'],
                                                                  "place": widget
                                                                          .postid[
                                                                      'place'],
                                                                  "location": widget
                                                                          .postid[
                                                                      'location'],
                                                                  "peopleLimit":
                                                                      widget.postid[
                                                                          'peopleLimit'],
                                                                  "detail": widget
                                                                          .postid[
                                                                      'detail'],
                                                                  "uid": widget
                                                                          .postid[
                                                                      'uid'],
                                                                  "timeStamp": widget
                                                                          .postid[
                                                                      'timeStamp'],
                                                                  "postid": widget
                                                                          .postid[
                                                                      'postid'],
                                                                });
                                                              }
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  _waiting
                                                                      ? lightPurple
                                                                      : lightGreen,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              _waiting
                                                                  ? 'Waiting'
                                                                  : 'Request',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'MyCustomFont',
                                                                color: _waiting
                                                                    ? primaryColor
                                                                    : unselected,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                      Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Text('Comment',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'MyCustomFont',
                                                  color: unselected,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ],
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: commentSet
                                            .doc(documentSnapshot['postid'])
                                            .collection('comments')
                                            .orderBy('timeStamp',
                                                descending: true)
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.33,
                                                    child: ListView.builder(
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final DocumentSnapshot
                                                              documentSnapshot =
                                                              snapshot.data!
                                                                  .docs[index];

                                                          var postidD =
                                                              postData[
                                                                  'postid'];
                                                          var timeStamp =
                                                              postData[
                                                                  'timeStamp'];

                                                          var Mytext =
                                                              new Map();
                                                          Mytext['Displayname'] =
                                                              documentSnapshot[
                                                                  'Displayname'];
                                                          Mytext['cid'] =
                                                              documentSnapshot[
                                                                  'cid'];
                                                          Mytext['comment'] =
                                                              documentSnapshot[
                                                                  'comment'];
                                                          Mytext['postid'] =
                                                              documentSnapshot[
                                                                  'postid'];
                                                          Mytext['profile'] =
                                                              documentSnapshot[
                                                                  'profile'];
                                                          Mytext['time'] =
                                                              timeago.format(
                                                                  documentSnapshot[
                                                                          'timeStamp']
                                                                      .toDate(),
                                                                  locale:
                                                                      'en_short');
                                                          Mytext['uid'] =
                                                              documentSnapshot[
                                                                  'uid'];

                                                          return Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            45),
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          green,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                        Mytext['profile']
                                                                            .toString(),
                                                                      ),
                                                                      radius:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onLongPress: () => _showModalBottomSheet(
                                                                        context,
                                                                        postidD,
                                                                        Mytext,
                                                                        timeStamp),
                                                                    child: Card(
                                                                      clipBehavior:
                                                                          Clip.hardEdge,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                        side:
                                                                            const BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              151,
                                                                              150,
                                                                              150),
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(15.00),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 180,
                                                                                  child: Text(Mytext['Displayname'],
                                                                                      style: const TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontFamily: 'MyCustomFont',
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      )),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 1),
                                                                                  child: Text(Mytext['time'].toString(),
                                                                                      style: const TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontFamily: 'MyCustomFont',
                                                                                        color: unselected,
                                                                                      )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              width: 250,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  Mytext['comment'],
                                                                                  style: const TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontFamily: 'MyCustomFont',
                                                                                    color: unselected,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
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
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              );
                              //),
                            });
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
                    }),
                bottomNavigationBar: Container(
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file_outlined,
                            color: purple,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.76,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            controller: commentController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a comment';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide:
                                    BorderSide(width: 2, color: unselected),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70)),
                                borderSide:
                                    BorderSide(width: 2, color: unselected),
                              ),
                              hintText: 'Send a message',
                              hintStyle: TextStyle(
                                color: unselected,
                                fontFamily: 'MyCustomFont',
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() == true) {
                              setState(() {
                                _isLoading = true;
                              });
                              var commentSet2 = commentSet
                                  .doc(postData['postid'])
                                  .collection('comments')
                                  .doc();
                              await commentSet2.set({
                                'cid': commentSet2.id,
                                'comment': commentController.text,
                                'postid': postData['postid'],
                                'uid': FirebaseAuth.instance.currentUser!.uid,
                                'profile': currentUser['profile'],
                                'Displayname': currentUser['Displayname'],
                                'timeStamp': DateTime.now(),
                              }).whenComplete(() {
                                commentController.clear();
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.send_outlined,
                            size: 30,
                            color: purple,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void _showModalBottomSheet1(BuildContext context, uid) {
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
                            postid: postData['postid'],
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
                                          .doc(postData['postid'])
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

  void _showModalBottomSheet(
      BuildContext context, postidD, Map mytext, timeStamp) {
    _commentController.text = mytext['comment'].toString();
    String Comment = '';

    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (FirebaseAuth.instance.currentUser!.uid == mytext['uid'])
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: Center(
                    child: Text(
                      'Edit',
                      style:
                          TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Edit Comment'),
                              content: Form(
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  controller: _commentController,
                                  decoration: textInputDecorationp.copyWith(
                                    hintText: 'type something',
                                  ),
                                  validator: (val) {
                                    if (val!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "plase Enter comment";
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      Comment = val;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancle')),
                                TextButton(
                                    onPressed: (() {
                                      FirebaseFirestore.instance
                                          .collection('comments')
                                          .doc(postidD)
                                          .collection('comments')
                                          .doc(mytext['cid'])
                                          .update({
                                        'cid': mytext['cid'],
                                        'postid': mytext['postid'],
                                        'uid': mytext['uid'],
                                        'profile': mytext['profile'],
                                        'Displayname': mytext['Displayname'],
                                        'timeStamp': timeStamp,
                                        "comment": _commentController.text
                                      }).whenComplete(() {
                                        Navigator.pop(context);
                                      });
                                    }),
                                    child: Text('Save'))
                              ],
                            ));
                  },
                ),
              if (FirebaseAuth.instance.currentUser!.uid == mytext['uid'])
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                      child: Text(
                    'Delete',
                    style: TextStyle(
                        fontFamily: 'MyCustomFont',
                        fontSize: 20,
                        color: redColor),
                  )),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Delete Comment'),
                              content: Text(
                                  'Are you sure you want to permanently\nremove this comment from Tungtee?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancle')),
                                TextButton(
                                    onPressed: (() {
                                      FirebaseFirestore.instance
                                          .collection('comments')
                                          .doc(postidD)
                                          .collection('comments')
                                          .doc(mytext['cid'])
                                          .delete()
                                          .whenComplete(() {
                                        Navigator.pop(context);
                                      });
                                    }),
                                    child: Text('Delete'))
                              ],
                            ));
                  },
                ),
              if (FirebaseAuth.instance.currentUser!.uid != mytext['uid'])
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
                    //Navigator.pop(context);
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

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

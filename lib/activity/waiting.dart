import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import '../comment/comment.dart';

class WaitingCard extends StatefulWidget {
  @override
  State<WaitingCard> createState() => _WaitingCardState();
}

class _WaitingCardState extends State<WaitingCard> {
  bool _waitingbutton = true;
  void _onPress() {
    setState(() {
      _waitingbutton = !_waitingbutton;
    });
    // Do content here
  }

  final CollectionReference _activity =
      FirebaseFirestore.instance.collection('activity');

  Future<void> _delete(String usersId) async {
    await _activity
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('waiting list')
        .doc(usersId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _activity
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('waiting list')
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
                height: 240,
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
                      height: 250,
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
                                                .collection("activity")
                                                .doc(uid)
                                                .collection('favorites list')
                                                .doc(documentSnapshot.id)
                                                .set({
                                              "activityName": documentSnapshot[
                                                  'activityName'],
                                              "date": documentSnapshot['date'],
                                              "time": documentSnapshot['time'],
                                              "place":
                                                  documentSnapshot['place'],
                                              "location":
                                                  documentSnapshot['location'],
                                              "peopleLimit": documentSnapshot[
                                                  'peopleLimit'],
                                              "detail":
                                                  documentSnapshot['detail'],
                                              "uid": documentSnapshot['uid'],
                                              "timeStamp":
                                                  documentSnapshot['timeStamp'],
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
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.all(1),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.64,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                        child: const Text('add tag+',
                                            style: TextStyle(
                                              fontFamily: 'MyCustomFont',
                                              color: unselected,
                                            )),
                                      ),
                                    ),
                                  ),
                                  if (FirebaseAuth.instance.currentUser!.uid ==
                                      documentSnapshot['uid'])
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: lightGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Accepting',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'MyCustomFont',
                                          color: unselected,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (FirebaseAuth.instance.currentUser!.uid !=
                                      documentSnapshot['uid'])
                                    ElevatedButton(
                                      onPressed: () {
                                        _onPress();
                                        print(_waitingbutton);
                                        if (_waitingbutton == true) {
                                          var uid = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          FirebaseFirestore.instance
                                              .collection("activity")
                                              .doc(uid)
                                              .collection('waiting list')
                                              .doc(documentSnapshot.id)
                                              .set({
                                            "activityName": documentSnapshot[
                                                'activityName'],
                                            "date": documentSnapshot['date'],
                                            "time": documentSnapshot['time'],
                                            "place": documentSnapshot['place'],
                                            "location":
                                                documentSnapshot['location'],
                                            "peopleLimit":
                                                documentSnapshot['peopleLimit'],
                                            "detail":
                                                documentSnapshot['detail'],
                                            "uid": documentSnapshot['uid'],
                                            "timeStamp":
                                                documentSnapshot['timeStamp'],
                                            "postid":
                                                documentSnapshot['postid'],
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _waitingbutton
                                            ? lightPurple
                                            : lightGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        _waitingbutton ? 'Waiting' : 'Request',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'MyCustomFont',
                                          color: _waitingbutton
                                              ? primaryColor
                                              : unselected,
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
                    )),
              );
            },
          );
        }
        return Container(child: Text('no data yet'));
      },
    );
  }
}

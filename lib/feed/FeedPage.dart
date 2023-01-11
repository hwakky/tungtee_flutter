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

import '../widgets/PostCard.dart';

class FeedPage extends StatefulWidget {
  final String uid;
  FeedPage({Key? key, required this.uid}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              itemBuilder: (context, index) => Container(
                    child: CardWidget(
                        snap: (snapshot.data! as dynamic).docs[index]),
                  ));
        });
  }
}

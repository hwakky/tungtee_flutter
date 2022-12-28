import 'package:flutter/material.dart';
import 'package:tangteevs/landing.dart';
import 'utils/color.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPage extends StatelessWidget {
  FeedPage({Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: mobileBackgroundColor,
          elevation: 0,
          centerTitle: false,
          title: SizedBox(
            width: 350.0,
            height: 45.0,
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: const BorderSide(width: 2, color: lightOrange),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: const BorderSide(width: 1, color: orange),
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
          actions: [
            PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Make for you"),
                    ),
                    PopupMenuItem<int>(
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
      ),
      body: PostCard(),
    );
  }
}

class PostCard extends StatelessWidget {
  final CollectionReference _post =
      FirebaseFirestore.instance.collection('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: StreamBuilder(
        stream: _post.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  child: ListTile(
                    title: Text(documentSnapshot['activityName']),
                    subtitle: Text(documentSnapshot['date']),
                  ),
                );
              },
            );
          }
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    height: 30.0,
                    width: 30.0,
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

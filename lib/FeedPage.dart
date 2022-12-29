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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            itemCount: (snapshot.data! as dynamic).docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisExtent: 200),
            itemBuilder: (context, index) {
              DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

              return Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: unselected, width: 0),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(5, 5),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 176,
                      width: 342,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((snap.data()! as dynamic)['activityName'],
                              style: TextStyle(
                                fontSize: 16,
                                color: unselected,
                                fontFamily: 'MyCustomFont',
                              )),
                          Text((snap.data()! as dynamic)['date'],
                              style: TextStyle(
                                fontSize: 16,
                                color: unselected,
                                fontFamily: 'MyCustomFont',
                              )),
                        ],
                      ),
                    ),

                    //Image(
                    //  image: NetworkImage((snap.data()!
                    //     as dynamic)['activityName']),
                    //  fit: BoxFit.cover,
                    //  ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

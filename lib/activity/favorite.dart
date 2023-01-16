import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import '../comment/comment.dart';
import '../widgets/PostCard.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: PostCard(),
    );
  }
}

class PostCard extends StatelessWidget {
  final _post = FirebaseFirestore.instance.collection('post');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('post')
            .where('likes',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                      child: CardWidget(
                          snap: (streamSnapshot.data! as dynamic).docs[index]),
                    ));
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
      ),
    );
  }
}

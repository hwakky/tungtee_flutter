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
      body: PostCard(),
    );
  }
}

class PostCard extends StatelessWidget {
  final CollectionReference _activity =
      FirebaseFirestore.instance.collection('activity');

  Future<void> _delete(String usersId) async {
    await _activity
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites list')
        .doc(usersId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _activity
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favorites list')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //onRefresh:_onRefresh;

        if (streamSnapshot.hasData) {
          return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                    child: CardWidget(
                        snap: (streamSnapshot.data! as dynamic).docs[index]),
                  ));
        }
        return Container(
          child: const Text('no data yet'),
        );
      },
    );
  }
}

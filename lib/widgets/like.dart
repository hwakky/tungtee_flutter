import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tangteevs/feed/FeedPage.dart';
import '../HomePage.dart';
import '../Report.dart';
import '../utils/color.dart';
import '../utils/color.dart';
import '../widgets/custom_textfield.dart';

Future<String> likePost(String postId, String uid, List likes) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

import 'package:flutter/material.dart';
import 'utils/color.dart';
import 'services/auth_service.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  _MyCommentState createState() => _MyCommentState();
}

class _MyCommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

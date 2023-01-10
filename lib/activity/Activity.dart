import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/activity/favorite.dart';
import 'package:tangteevs/activity/history.dart';
import 'package:tangteevs/activity/waiting.dart';
import 'package:tangteevs/utils/color.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            elevation: 1,
            leadingWidth: 130,
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
            bottom: const TabBar(
              indicatorColor: green,
              labelColor: green,
              labelPadding: EdgeInsets.symmetric(horizontal: 30),
              unselectedLabelColor: unselected,
              labelStyle: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'MyCustomFont'), //For Selected tab
              unselectedLabelStyle: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'MyCustomFont'), //For Un-selected Tabs
              tabs: [
                Tab(text: 'Waiting'),
                Tab(text: 'History'),
                Tab(text: 'Favorite'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Waiting(),
              History(),
              Favorite(),
            ],
          ),
        ));
  }
}

class Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FavoritePage(),
    );
  }
}

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HistoryPage(),
    );
  }
}

class Waiting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WaitingPage(),
    );
  }
}

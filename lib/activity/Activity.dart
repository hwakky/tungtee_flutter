import 'package:tangteevs/activity/favorite.dart';
import 'package:tangteevs/activity/history.dart';
import 'package:tangteevs/activity/waiting.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              color: green,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: mobileBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const TabBar(
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
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(children: <Widget>[
                    Waiting(),
                    History(),
                    Favorite(),
                  ]),
                )
              ]),
        ),
      ),
    );
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

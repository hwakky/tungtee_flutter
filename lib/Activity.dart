import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mobileBackgroundColor,
          bottom: const TabBar(
            indicatorColor: lightGreen,
            labelColor: lightGreen,
            unselectedLabelColor: unselected,
            labelStyle: TextStyle(
                fontSize: 20.0, fontFamily: 'MyCustomFont'), //For Selected tab
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
            WaitingPage(),
            HistoryPage(),
            FavoritePage(),
          ],
        ),
        backgroundColor: mobileBackgroundColor,
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // Add the content for the home tab here
        );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // Add the content for the home tab here
        );
  }
}

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // Add the content for the home tab here
        );
  }
}

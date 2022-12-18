import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
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
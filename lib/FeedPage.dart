import 'package:flutter/material.dart';

import 'utils/color.dart';

class FeedPage extends StatelessWidget {
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
    );
  }
}

// class WaitingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         // Add the content for the home tab here
//         );
//   }
// }
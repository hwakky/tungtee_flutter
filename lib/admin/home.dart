import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/admin/tag.dart';
import 'package:tangteevs/utils/color.dart';

import '../Landing.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    complaint(),
    tagTab(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (_selectedIndex) {
      case 0:
        currentPage = _pages[0];
        break;
      case 1:
        currentPage = _pages[1];
        break;
      default:
        currentPage = _pages[0];
        break;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 1,
        leadingWidth: 130,
        centerTitle: true,
        title: const Text('test'),
        leading: Container(
          padding: const EdgeInsets.all(0),
          child: Image.asset('assets/images/logo with name.png',
              fit: BoxFit.scaleDown),
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
      body: currentPage,
      bottomNavigationBar: SizedBox(
        height: 65,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: purple,
          unselectedItemColor: primaryColor,
          selectedItemColor: lightGreen,
          onTap: _onItemTapped,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.compass_calibration),
              label: 'complant',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity),
              label: 'Tag',
            ),
          ],
        ),
      ),
    );
  }
}

class complaint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ElevatedButton.icon(
            onPressed: () {
              // Sign out of Firebase
              FirebaseAuth.instance.signOut();

              // Push the landing page route and replace the current route
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LandingPage()),
              );
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text("Logout")),
      ]),
    );
  }
}

class tagTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return MaterialApp(
      home: tag(),
    );
  }
}

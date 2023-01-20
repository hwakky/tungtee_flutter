import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/admin/report/report.dart';
import 'package:tangteevs/admin/tag/tag.dart';
import 'package:tangteevs/admin/user/user.dart';
import 'package:tangteevs/utils/color.dart';

import '../Landing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    UserTab(),
    ReportTab(),
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
      case 2:
        currentPage = _pages[2];
        break;
      default:
        currentPage = _pages[0];
        break;
    }
    return Scaffold(
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
              icon: Icon(Icons.person),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tag),
              label: 'Tag',
            ),
          ],
        ),
      ),
    );
  }
}

class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserPage(),
    );
  }
}

class ReportTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReportPage(),
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Activity.dart';
import 'Event.dart';
import 'Proflie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    ActivityTab(),
    Event(),
    ChatTab(),
    ProfileTab(),
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
      case 3:
        currentPage = _pages[3];
        break;
      case 4:
        currentPage = _pages[4];
        break;
      default:
        currentPage = _pages[0];
        break;
    }
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Proflie',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromARGB(147, 45, 166, 1),
        selectedItemColor: Color.fromARGB(178, 242, 97, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}

class Event extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateEventScreen(),
    );
  }
}

class ActivityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ActivityPage(),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Container(
        child: const Text('Add the content for the Home tab here'),
        
        );
  }
}

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Text('Add the content for the chat tab here'),
        );
  }
}

class ProfileTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}


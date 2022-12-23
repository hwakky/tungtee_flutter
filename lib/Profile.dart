import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'landing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  bool isSignedIn = false;
  final user = FirebaseAuth.instance.currentUser!;
 FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthService authService = AuthService();

  ProfilePage({Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                //leading: CircleAvatar(
                //backgroundImage: NetworkImage(user.photoURL),
                // ),
                title: Text(user.uid),
                subtitle: Text(user.email!),
               
              ),
              ButtonBar(
                children: [
                  TextButton(
                    child: const Text('Edit'),
                    onPressed: () {
                      // Navigate to edit profile page
                    },
                  ),
                  TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      // Logout user
                    },
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        // Sign out of Firebase
                        FirebaseAuth.instance.signOut();

                        // Push the landing page route and replace the current route
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LandingPage()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Logout"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String profileImageUrl;

  User(
      {required this.name, required this.email, required this.profileImageUrl});
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/regis,login/Login.dart';
import 'services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
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
                title: Text(user.displayName!),
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
                      onPressed: () async {
                        await authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false);
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

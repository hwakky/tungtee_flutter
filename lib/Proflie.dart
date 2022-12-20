import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final  user = FirebaseAuth.instance.currentUser!;


  ProfilePage({Key? key, required }) : super(key: key);

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
                    child: Text('Edit'),
                    onPressed: () {
                      // Navigate to edit profile page
                    },
                  ),
                  TextButton(
                    child: Text('Logout'),
                    onPressed: () {
                      // Logout user
                    },
                  ),
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

  User({required this.name, required this.email, required this.profileImageUrl});
}
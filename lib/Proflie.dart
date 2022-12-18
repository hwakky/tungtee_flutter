import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImageUrl),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
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
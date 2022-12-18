import 'package:flutter/material.dart';

 class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email Addess'),
            ),
              TextField(
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Create account'),
             onPressed: () => Navigator.pushNamed(context, '/HomePage'),
            ),
            TextButton(
              child: Text('Already have an account? Login'),
              onPressed: () {
                // Navigate back to the login screen  
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
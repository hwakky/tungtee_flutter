  import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: _formKey,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email Addess'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: password2Controller,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Create account'),
              onPressed: () {
                if (passwordController.text == password2Controller.text) {
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);
                } else {
                  return print("error");
                }
              },
            ),
            TextButton(
              child: const Text('Already have an account? Login'),
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

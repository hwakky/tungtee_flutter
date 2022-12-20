import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

void validateAndSave() {}

class _LoginState extends State<Login> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a Email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)
                    .then((result) {
                  if (result == 'null') {
                   Navigator.pushNamed(context, '/login');
                  } else {
                    MaterialPageRoute(builder: (context) => MyHomePage());
                  }
                });
              },
              child: const Text('Log in'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}

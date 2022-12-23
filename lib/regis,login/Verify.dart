import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangteevs/HomePage.dart';

import '../widgets/custom_textfield.dart';

void main() => runApp(Verify());

class Verify extends StatefulWidget {
  const Verify({super.key});
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final ImagePicker _picker = ImagePicker();
  File? id_card;

  void pickImagefromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;

    setState(() {
      id_card = File(photo.path);
    });
  }

  void pickImagefromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return;

    setState(() {
      id_card = File(photo.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Verification Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 350,
                  child: id_card != null
                      ? Image.file(id_card!)
                      : Image.asset("assets/login.png"),
                        ),
              ElevatedButton(
                onPressed: () {
                  pickImagefromCamera();
                },
                child: const Text('Take a photo the front side'),
              ),
              ElevatedButton(
                onPressed: () {
                  nextScreen(context, MyHomePage());
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

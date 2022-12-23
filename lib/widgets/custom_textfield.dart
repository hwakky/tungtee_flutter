import 'package:flutter/material.dart';

const primaryColor = Colors.white;
const redColor = Color.fromRGBO(225, 0, 0, 1);
const disable = Color.fromRGBO(216, 216, 216, 1);
const unselected = Color.fromRGBO(107, 106, 106, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const mobileBackgroundColor = Color.fromRGBO(255, 254, 246, 1);

//purple
const purple = Color.fromRGBO(147, 45, 166, 1);
const lightPurple = Color.fromRGBO(169, 82, 185, 1);
const lightestPurple = Color.fromRGBO(203, 108, 230, 1);

//green
const green = Color.fromRGBO(152, 232, 23, 1);
const lightGreen = Color.fromRGBO(178, 242, 97, 1);
const lightestGreen = Color.fromRGBO(116, 255, 94, 1);

//orange
const orange = Color.fromRGBO(255, 189, 89, 1);
const lightOrange = Color.fromRGBO(255, 204, 102, 1);
const lightestOrange = Color.fromRGBO(255, 221, 89, 1);

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(70.0)),
    borderSide: BorderSide(color: green, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(70.0)),
    borderSide: BorderSide(color: green, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(70.0)),
    borderSide: BorderSide(color: green, width: 2),
  ),
  fillColor: primaryColor,
  filled: true,
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace( context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}


void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}

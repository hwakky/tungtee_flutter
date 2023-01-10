import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class DataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('data',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
      ),
    );
  }
}

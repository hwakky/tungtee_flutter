import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Report',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
      ),
    );
  }
}

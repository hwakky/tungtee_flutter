import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Favorite',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
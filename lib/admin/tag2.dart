// import 'package:flutter/material.dart';

// import 'package:flutter_tags/flutter_tags.dart';
// import 'package:tangteevs/utils/color.dart';

// class tag extends StatefulWidget {
//   const tag({super.key});

//   @override
//   State<tag> createState() => _tagState();
// }

// class _tagState extends State<tag> {
//   List tags = new List();

//   final GlobalKey<TagsState> _globalkey = GlobalKey<TagsState>();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Tags(
//           key: _globalkey,
//           itemCount: tags.length,
//           columns: 6,
//           textField: TagsTextField(
//             textStyle: TextStyle(fontSize: 30),
//             onSubmitted: (string) {},
//           ),
//         ),
//       ),
//     ));
//   }
// }

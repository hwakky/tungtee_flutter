// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tangteevs/Landing.dart';
// import 'package:tangteevs/admin/user/data.dart';
// import 'package:tangteevs/admin/user/verify.dart';
// import '../../utils/color.dart';
// import '../../widgets/custom_textfield.dart';
// import 'category.dart';

// class TagPage extends StatefulWidget {
//   const TagPage({Key? key}) : super(key: key);

//   @override
//   _TagPageState createState() => _TagPageState();
// }

// class _TagPageState extends State<TagPage> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//           body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(32),
//             child: Container(
//               padding: EdgeInsets.only(top: 160),
//               alignment: Alignment.topCenter,
//               child: Text(
//                 'Sorry not have any category now',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 200,
//             child: Image.asset(
//               'assets/images/logo.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           ElevatedButton(
//             child: const Text('Create Category'),
//             style: ElevatedButton.styleFrom(backgroundColor: green),
//             onPressed: () => CategoryPage,
//           )
//         ],
//       )),
//     );
//   }
// }

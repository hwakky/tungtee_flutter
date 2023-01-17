// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tangteevs/Landing.dart';
// import 'package:tangteevs/admin/tag/case/noCat.dart';
// import 'package:tangteevs/admin/user/data.dart';
// import 'package:tangteevs/admin/user/verify.dart';
// import '../../utils/color.dart';
// import '../../widgets/custom_textfield.dart';

// class TagPage extends StatefulWidget {
//   const TagPage({Key? key}) : super(key: key);

//   @override
//   _TagPageState createState() => _TagPageState();
// }

// class _TagPageState extends State<TagPage> {
//   final TextEditingController _CategoryController = TextEditingController();
//   final TextEditingController _colorController = TextEditingController();

//   final CollectionReference _tags =
//       FirebaseFirestore.instance.collection('tags');

//   final CollectionReference _categorys =
//       FirebaseFirestore.instance.collection('categorys');

//   Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 top: 20,
//                 left: 20,
//                 right: 20,
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: _CategoryController,
//                   decoration: const InputDecoration(labelText: 'Category'),
//                 ),
//                 TextField(
//                   controller: _colorController,
//                   decoration: const InputDecoration(labelText: 'Color'),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   child: const Text('Create'),
//                   onPressed: () async {
//                     final String Category = _CategoryController.text;
//                     final String color = _colorController.text;
//                     if (color != null) {
//                       await _categorys
//                           .add({"CategoryName": Category, "color": color});

//                       _CategoryController.text = '';
//                       _colorController.text = '';
//                       Navigator.of(context).pop();
//                     }
//                   },
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Container(
//         child: Scaffold(
//             body: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(32),
//               child: Container(
//                 padding: EdgeInsets.only(top: 160),
//                 alignment: Alignment.topCenter,
//                 child: Text(
//                   'Sorry not have any category now',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 200,
//               child: Image.asset(
//                 'assets/images/logo.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             ElevatedButton(
//               child: const Text('Create Category'),
//               style: ElevatedButton.styleFrom(backgroundColor: green),
//               onPressed: () => _create(),
//             )
//           ],
//         )),
//       ),
//     );
//   }
// }

// class noCategoyPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: noCategoryPage(),
//     );
//   }
// }

// class data extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DataPage(),
//     );
//   }
// }

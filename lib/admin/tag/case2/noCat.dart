// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../utils/color.dart';

// class noCategoryPage extends StatefulWidget {
//   const noCategoryPage({Key? key}) : super(key: key);

//   @override
//   _noCategoryPageState createState() => _noCategoryPageState();
// }

// class _noCategoryPageState extends State<noCategoryPage> {
//   final TextEditingController _CategoryController = TextEditingController();
//   final TextEditingController _colorController = TextEditingController();

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
//                   decoration: const InputDecoration(labelText: 'Color code'),
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
//                           .add({"Category": Category, "color": color});

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

// // set2
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: StreamBuilder(
//           stream: _categorys.snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//             if (streamSnapshot.hasData) {
//               return ListView.builder(
//                 itemCount: streamSnapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   final DocumentSnapshot documentSnapshot =
//                       streamSnapshot.data!.docs[index];
//                   return Card(
//                     margin: const EdgeInsets.all(10),
//                     child: ListTile(
//                       title: Text(documentSnapshot['Category']),
//                       subtitle: Text(documentSnapshot['color']),
//                       trailing: SingleChildScrollView(
//                         child: SizedBox(
//                           width: 100,
//                           child: Row(),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return DefaultTabController(
//                 length: 2,
//                 child: Container(
//                   child: Scaffold(
//                       body: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(32),
//                         child: Container(
//                           padding: EdgeInsets.only(top: 140),
//                           alignment: Alignment.topCenter,
//                           child: Text(
//                             'Sorry not have any category now',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 150,
//                         child: Image.asset(
//                           'assets/images/logo.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       ElevatedButton(
//                         child: const Text('Create Category'),
//                         style: ElevatedButton.styleFrom(backgroundColor: green),
//                         onPressed: () => _create(),
//                       )
//                     ],
//                   )),
//                 ),
//               );
//             }
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => _create(),
//           child: const Icon(Icons.add),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
//   }
// }

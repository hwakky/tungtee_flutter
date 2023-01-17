// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../utils/color.dart';
// import '../../../widgets/custom_textfield.dart';

// class newTagPage extends StatefulWidget {
//   const newTagPage({Key? key}) : super(key: key);

//   @override
//   _newTagPageState createState() => _newTagPageState();
// }

// class _newTagPageState extends State<newTagPage> {
//   final TextEditingController _TagController = TextEditingController();
//   TextEditingController _TagCategoryController = TextEditingController();
//   final TextEditingController _CategoryController = TextEditingController();
//   final TextEditingController _colorController = TextEditingController();

//   final CollectionReference _tags =
//       FirebaseFirestore.instance.collection('tags');

//   final CollectionReference _categorys =
//       FirebaseFirestore.instance.collection('categorys');

//   Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
//     if (documentSnapshot != null) {
//       _CategoryController.text = documentSnapshot['Category'];
//       _colorController.text = documentSnapshot['color'];
//       _TagCategoryController.text = documentSnapshot['tagCategory'];
//     }
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
//                   controller: _TagController,
//                   decoration: const InputDecoration(labelText: 'Tag name'),
//                 ),
//                 DropdownButtonFormField(
//                     value: 'no have',
//                     hint: Text('Choose category type'),
//                     items: documentSnapshot!['Category'].map((String items) {
//                       return DropdownMenuItem(
//                         value: items,
//                         child: Text(items),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         // _TagCategoryController = newValue!;
//                         _TagCategoryController =
//                             newValue! as TextEditingController;
//                       });
//                     }),
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
//                     final String Tag = _TagController.text;
//                     final String category = _CategoryController.text;
//                     if (category != null) {
//                       await _tags.add({"Tagname": Tag, "category": category});

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

//   Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
//     if (documentSnapshot != null) {
//       _CategoryController.text = documentSnapshot['Tagname'];
//       _colorController.text = documentSnapshot['color'];
//     }

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
//               crossAxisAlignment: CrossAxisAlignment.center,
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
//                   height: 10,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       child: const Text('Yes'),
//                       onPressed: () async {
//                         final String Category = _CategoryController.text;
//                         final String color = _colorController.text;
//                         const bool verify = true;
//                         if (verify != null) {
//                           await _categorys.doc(documentSnapshot!.id).update({
//                             "verify": verify,
//                             'Category': Category,
//                             'color': color
//                           });
//                           _CategoryController.text = '';
//                           _colorController.text = '';
//                           nextScreen(context, newTagPage());
//                         }
//                       },
//                     ),
//                     ElevatedButton(
//                       child: const Text('No'),
//                       onPressed: () async {
//                         const bool verify = false;
//                         if (verify != null) {
//                           await _categorys
//                               .doc(documentSnapshot!.id)
//                               .update({"verify": verify});
//                           _CategoryController.text = '';
//                           _colorController.text = '';
//                           nextScreen(context, newTagPage());
//                         }
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   Future<void> _delete(String categoryId) async {
//     await _categorys.doc(categoryId).delete();

//     ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('You have successfully deleted a tag')));
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
//                           child: Row(
//                             children: [
//                               IconButton(
//                                   icon: const Icon(Icons.edit),
//                                   onPressed: () => _update(documentSnapshot)),
//                               IconButton(
//                                   icon: const Icon(Icons.delete),
//                                   onPressed: () => showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             title: Text('Are you sure?'),
//                                             content: Text(
//                                                 'This action cannot be undone.'),
//                                             actions: [
//                                               TextButton(
//                                                 child: Text('Cancel'),
//                                                 onPressed: () {
//                                                   Navigator.of(context)
//                                                       .pop(); // dismiss the dialog
//                                                 },
//                                               ),
//                                               TextButton(
//                                                 child: Text('OK'),
//                                                 onPressed: () {
//                                                   _delete(documentSnapshot.id);
//                                                   Navigator.of(context)
//                                                       .pop(); // dismiss the dialog
//                                                 },
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//             return Container(
//               child: Text('hi'),
//             );
//             // return DefaultTabController(
//             //   length: 2,
//             //   child: Container(
//             //     child: Scaffold(
//             //         body: Column(
//             //       children: <Widget>[
//             //         Padding(
//             //           padding: const EdgeInsets.all(32),
//             //           child: Container(
//             //             padding: EdgeInsets.only(top: 140),
//             //             alignment: Alignment.topCenter,
//             //             child: Text(
//             //               'Sorry not have any category now',
//             //               style: Theme.of(context).textTheme.titleLarge,
//             //             ),
//             //           ),
//             //         ),
//             //         SizedBox(
//             //           height: 150,
//             //           child: Image.asset(
//             //             'assets/images/logo.png',
//             //             fit: BoxFit.cover,
//             //           ),
//             //         ),
//             //         ElevatedButton(
//             //           child: const Text('Create Category'),
//             //           style: ElevatedButton.styleFrom(backgroundColor: green),
//             //           onPressed: () => _create(),
//             //         )
//             //       ],
//             //     )),
//             //   ),
//             // );
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => _create(),
//           child: const Icon(Icons.add),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
//   }
// }

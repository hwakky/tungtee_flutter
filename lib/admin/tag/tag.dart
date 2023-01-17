// // ignore_for_file: prefer_const_constructors, sort_child_properties_last

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:tangteevs/admin/tag/tagCategory.dart';

// import '../../../utils/color.dart';
// import '../../../widgets/custom_textfield.dart';

// class TagPage extends StatefulWidget {
//   final snap;
//   // const TagPage({Key? key}) : super(key: key);
//   const TagPage({required this.snap});

//   @override
//   _TagPageState createState() => _TagPageState();
// }

// class _TagPageState extends State<TagPage> {
//   final TextEditingController _CategoryController = TextEditingController();
//   final TextEditingController _colorController = TextEditingController();

//   final CollectionReference _categorys =
//       FirebaseFirestore.instance.collection('categorys');

//   final categorysSet = FirebaseFirestore.instance.collection('categorys').doc();

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
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: ElevatedButton(
//                     child: const Text('Create'),
//                     onPressed: () async {
//                       final String Category = _CategoryController.text;
//                       final String color = _colorController.text;
//                       if (color != null) {
//                         await categorysSet.set({
//                           "Category": Category,
//                           "color": color,
//                           "categortId": categorysSet.id
//                         });

//                         _CategoryController.text = '';
//                         _colorController.text = '';
//                         Navigator.of(context).pop();
//                       }
//                     },
//                   ),
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
//     if (documentSnapshot != null) {
//       _CategoryController.text = documentSnapshot['Category'];
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
//                           // nextScreen(context, CategoryPage(Widget.snap));
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
//                           // nextScreen(context, CategoryPage(widget.snap));
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

//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('You have successfully deleted a category')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 50,
//           backgroundColor: mobileBackgroundColor,
//           elevation: 1,
//           leadingWidth: 130,
//           centerTitle: true,
//           title: const Text('test'),
//           leading: Container(
//             padding: const EdgeInsets.all(0),
//             child: Image.asset('assets/images/logo with name.png',
//                 fit: BoxFit.scaleDown),
//           ),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
//               child: Container(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Category',
//                   textAlign: TextAlign.left,
//                   style: TextStyle(fontSize: 30),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: StreamBuilder(
//                 stream: _categorys.snapshots(),
//                 builder:
//                     (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//                   if (streamSnapshot.hasData) {
//                     return ListView.builder(
//                       itemCount: streamSnapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         final DocumentSnapshot documentSnapshot =
//                             streamSnapshot.data!.docs[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) =>
//                                   TagCategory(categoryId: widget.snap),
//                             ));
//                           },
//                           child: Card(
//                             borderOnForeground: true,
//                             elevation: 2,
//                             child: ClipPath(
//                               child: Container(
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                         left: BorderSide(
//                                             color: HexColor(
//                                                 documentSnapshot['color']),
//                                             width: 10))),
//                                 child: ListTile(
//                                   title: Text(documentSnapshot['Category']),
//                                   subtitle: Text(documentSnapshot['color']),
//                                   trailing: SingleChildScrollView(
//                                     child: SizedBox(
//                                       width: 100,
//                                       child: Row(
//                                         children: [
//                                           IconButton(
//                                               icon: const Icon(Icons.edit),
//                                               onPressed: () =>
//                                                   _update(documentSnapshot)),
//                                           IconButton(
//                                               icon: const Icon(Icons.delete),
//                                               onPressed: () => showDialog(
//                                                     context: context,
//                                                     builder: (context) {
//                                                       return AlertDialog(
//                                                         title: Text(
//                                                             'Are you sure?'),
//                                                         content: Text(
//                                                             'This action cannot be undone.'),
//                                                         actions: [
//                                                           TextButton(
//                                                             child:
//                                                                 Text('Cancel'),
//                                                             onPressed: () {
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop(); // dismiss the dialog
//                                                             },
//                                                           ),
//                                                           TextButton(
//                                                             child: Text('OK'),
//                                                             onPressed: () {
//                                                               _delete(
//                                                                   documentSnapshot
//                                                                       .id);
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop(); // dismiss the dialog
//                                                             },
//                                                           ),
//                                                         ],
//                                                       );
//                                                     },
//                                                   )),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               clipper: ShapeBorderClipper(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(3))),
//                             ),
//                             margin: const EdgeInsets.all(10),
//                           ),
//                         );
//                       },
//                     );
//                   }

//                   // no
//                   return DefaultTabController(
//                     length: 2,
//                     child: Container(
//                       child: Scaffold(
//                           body: Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(32),
//                             child: Container(
//                               padding: EdgeInsets.only(top: 140),
//                               alignment: Alignment.topCenter,
//                               child: Text(
//                                 'Sorry not have any category now',
//                                 style: Theme.of(context).textTheme.titleLarge,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 150,
//                             child: Image.asset(
//                               'assets/images/logo.png',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           ElevatedButton(
//                             child: const Text('Create Category'),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: green),
//                             onPressed: () => _create(),
//                           )
//                         ],
//                       )),
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () => _create(),
//           icon: const Icon(Icons.add),
//           label: const Text('Add New Category'),
//           backgroundColor: green,
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
//   }
// }

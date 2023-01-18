// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/color.dart';
import '../tag/tagCategory.dart';

class CategoryWidget extends StatefulWidget {
  final snap;
  const CategoryWidget({required this.snap});

  @override
  _tagCategoryState createState() => _tagCategoryState();
}

class _tagCategoryState extends State<CategoryWidget> {
  // create category
  final TextEditingController _CategoryController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  final CollectionReference _categorys =
      FirebaseFirestore.instance.collection('categorys');
  final categorysSet = FirebaseFirestore.instance.collection('categorys').doc();

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _CategoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(labelText: 'Color code'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () async {
                      final String Category = _CategoryController.text;
                      final String color = _colorController.text;
                      if (color != null) {
                        await categorysSet.set({
                          "Category": Category,
                          "color": color,
                          "categoryId": categorysSet.id
                        });

                        _CategoryController.text = '';
                        _colorController.text = '';
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _CategoryController.text = documentSnapshot['Category'];
      _colorController.text = documentSnapshot['color'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _CategoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(labelText: 'Color code'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Yes'),
                      onPressed: () async {
                        final String Category = _CategoryController.text;
                        final String color = _colorController.text;
                        const bool verify = true;

                        await _categorys.doc(documentSnapshot!.id).update({
                          "verify": verify,
                          'Category': Category,
                          'color': color
                        });
                        _CategoryController.text = '';
                        _colorController.text = '';
                        // nextScreen(context, CategoryWidget());
                      },
                    ),
                    ElevatedButton(
                      child: const Text('No'),
                      onPressed: () async {
                        const bool verify = false;
                        if (verify != null) {
                          await _categorys
                              .doc(documentSnapshot!.id)
                              .update({"verify": verify});
                          _CategoryController.text = '';
                          _colorController.text = '';
                          nextScreen(
                              context,
                              CategoryWidget(
                                snap: null,
                              ));
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String categoryId) async {
    await _categorys.doc(categoryId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a category')));
  }

  // call
  var categoryNameData = {};
  var categoryColorData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var categoryNameSnap = await FirebaseFirestore.instance
          .collection('categorys')
          .doc(widget.snap['Category'])
          .get();

      var categoryColorSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['color'])
          .get();

      categoryNameData = categoryNameSnap.data()!;
      categoryColorData = categoryColorSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  final CollectionReference _tags =
      FirebaseFirestore.instance.collection('tags');
  final TextEditingController _tagController = TextEditingController();
  final tagSet = FirebaseFirestore.instance.collection('tags');

  bool _isLoading = false;
  bool submit = false;
  final tagController = TextEditingController();
  var tagCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ClipPath(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: HexColor(widget.snap['color']), width: 10))),
          child: ListTile(
            title: Text(widget.snap['Category']),
            subtitle: Text(widget.snap['color']),
            trailing: SingleChildScrollView(
              child: SizedBox(
                width: 160,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                TagCategory(categoryId: widget.snap),
                          ),
                        );
                      },
                      child: const Text(
                        '+',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'MyCustomFont',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _update()),
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Are you sure?'),
                                  content:
                                      Text('This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        _delete(widget.snap.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            )),
                  ],
                ),
              ),
            ),
          ),
        ),
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      ),
      margin: const EdgeInsets.all(10),
    );
  }
}

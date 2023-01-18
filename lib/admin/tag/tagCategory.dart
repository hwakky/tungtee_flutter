// ignore_for_file: sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/color.dart';
import '../../utils/showSnackbar.dart';
import '../../widgets/custom_textfield.dart';

class TagCategory extends StatefulWidget {
  DocumentSnapshot categoryId;
  TagCategory({required this.categoryId});

  @override
  _TagCategoryState createState() => _TagCategoryState();
}

class _TagCategoryState extends State<TagCategory> {
  var categoryData = {};
  var categoryNameData = {};
  var categoryColorData = {};
  bool isLoading = false;

  // String color = categoryColorData['color'];
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
      var categorySnap = await FirebaseFirestore.instance
          .collection('categorys')
          .doc(widget.categoryId['categoryId'])
          .get();
      categoryData = categorySnap.data()!;
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

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                    child: Text(
                      widget.categoryId['Category'],
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: tagSet
                        .doc(categoryData['categoryId'])
                        .collection('tags')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.73,
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot documentSnapshot =
                                          snapshot.data!.docs[index];

                                      var categoryIdD =
                                          categoryData['categoryId'];

                                      var Mytext = new Map();
                                      Mytext['tag'] = documentSnapshot['tag'];

                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: HexColor(
                                                  categoryData['color']),
                                              width: 5),
                                        ),
                                        child: ClipPath(
                                          child: Container(
                                            height: 80,
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Text(Mytext['tag']),
                                                ],
                                              ),
                                              trailing: SingleChildScrollView(
                                                child: SizedBox(
                                                  width: 160,
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                          icon: const Icon(
                                                              Icons.edit),
                                                          onPressed: () {}),
                                                      IconButton(
                                                          icon: const Icon(
                                                              Icons.edit),
                                                          onPressed: () {}),
                                                      IconButton(
                                                          icon: const Icon(
                                                              Icons.edit),
                                                          onPressed: () {}),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          clipper: ShapeBorderClipper(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3))),
                                        ),
                                        margin: const EdgeInsets.all(10),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container(
                        child: Text('ho'),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Form(
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.76,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      controller: tagController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a tag';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(width: 2, color: unselected),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(70)),
                          borderSide: BorderSide(width: 2, color: unselected),
                        ),
                        hintText: 'Add Tag here',
                        hintStyle: TextStyle(
                          color: unselected,
                          fontFamily: 'MyCustomFont',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      var tagSet2 = tagSet
                          .doc(categoryData['categoryId'])
                          .collection('tags')
                          .doc();
                      await tagSet2.set({
                        'tagId': tagSet2.id,
                        'tag': tagController.text,
                        'tagColor': categoryData['color'].toString(),
                      }).whenComplete(() {
                        tagController.clear();
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                      color: purple,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class DataTagPage extends StatefulWidget {
  const DataTagPage({Key? key}) : super(key: key);

  @override
  _DataTagPageState createState() => _DataTagPageState();
}

class _DataTagPageState extends State<DataTagPage> {
// text fields' controllers
  final TextEditingController _tagnameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final CollectionReference _tags =
      FirebaseFirestore.instance.collection('tags');

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
                  controller: _tagnameController,
                  decoration: const InputDecoration(labelText: 'Tag'),
                ),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String Tagname = _tagnameController.text;
                    final String category = _categoryController.text;
                    if (category != null) {
                      await _tags
                          .add({"Tagname": Tagname, "category": category});

                      _tagnameController.text = '';
                      _categoryController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _tagnameController.text = documentSnapshot['Tagname'];
      _categoryController.text = documentSnapshot['category'];
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
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    height: 300,
                    width: 400,
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Container(
                            height: 40.0,
                            width: 40.0,
                            child: Image.network(_tagnameController.text,
                                fit: BoxFit.cover))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    text: 'verify this id card',
                    style: const TextStyle(
                      fontFamily: 'MyCustomFont',
                      color: unselected,
                    ),
                  ),
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
                        const bool verify = true;
                        if (verify != null) {
                          await _tags
                              .doc(documentSnapshot!.id)
                              .update({"verify": verify});
                          _tagnameController.text = '';
                          _categoryController.text = '';
                          nextScreen(context, DataTagPage());
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('No'),
                      onPressed: () async {
                        const bool verify = false;
                        if (verify != null) {
                          await _tags
                              .doc(documentSnapshot!.id)
                              .update({"verify": verify});
                          _tagnameController.text = '';
                          _categoryController.text = '';
                          nextScreen(context, DataTagPage());
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

  Future<void> _delete(String usersId) async {
    await _tags.doc(usersId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a users')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: _tags.where('verify', isEqualTo: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['Displayname']),
                      subtitle: Text(documentSnapshot['email']),
                      trailing: SingleChildScrollView(
                        child: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {}),
                              // onPressed: () => _update(documentSnapshot)),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Are you sure?'),
                                            content: Text(
                                                'This action cannot be undone.'),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // dismiss the dialog
                                                },
                                              ),
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  _delete(documentSnapshot.id);
                                                  Navigator.of(context)
                                                      .pop(); // dismiss the dialog
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
                  );
                },
              );
            }

            return const Center(
              child: Text('no data yet'),
            );
          },
        ),
// Add new users
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}

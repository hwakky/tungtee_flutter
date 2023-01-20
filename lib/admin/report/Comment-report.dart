import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class Commentpage extends StatefulWidget {
  const Commentpage({Key? key}) : super(key: key);

  @override
  State<Commentpage> createState() => _CommentpageState();
}

class _CommentpageState extends State<Commentpage> {
  String name = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center()
        : NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  //preferredSize: const Size.fromHeight(80),
                  //child: AppBar(
                  floating: true,
                  snap: true,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: mobileBackgroundColor,
                  elevation: 0,
                  centerTitle: false,
                  title: const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                      width: 400.0,
                      height: 45.0,
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 2, color: lightOrange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(width: 1, color: orange),
                          ),
                          hintText: 'ค้นหาuserด้วยdisplayname หรือ email',
                          hintStyle: TextStyle(
                            color: unselected,
                            fontFamily: 'MyCustomFont',
                          ),
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: orange,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //),
              ];
            },
            body: const DataPage(),
          );
  }
}

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
// text fields' controllers
  final TextEditingController _DisplaynameController = TextEditingController();
  final TextEditingController _idcardController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

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
                  controller: _DisplaynameController,
                  decoration: const InputDecoration(labelText: 'Displayname'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String Displayname = _DisplaynameController.text;
                    final String email = _emailController.text;
                    if (email != null) {
                      await _users
                          .add({"Displayname": Displayname, "email": email});

                      _DisplaynameController.text = '';
                      _emailController.text = '';
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
      _idcardController.text = documentSnapshot['idcard'];
      _verifyController.text = documentSnapshot['verify'].toString();
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
                            child: Image.network(_idcardController.text,
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
                          await _users
                              .doc(documentSnapshot!.id)
                              .update({"verify": verify});
                          _DisplaynameController.text = '';
                          _emailController.text = '';
                          nextScreen(context, DataPage());
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('No'),
                      onPressed: () async {
                        const bool verify = false;
                        if (verify != null) {
                          await _users
                              .doc(documentSnapshot!.id)
                              .update({"verify": verify});
                          _DisplaynameController.text = '';
                          _emailController.text = '';
                          nextScreen(context, DataPage());
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
    await _users.doc(usersId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a users')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: _users.where('verify', isEqualTo: true).snapshots(),
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
                                  onPressed: () => _update(documentSnapshot)),
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _create(),
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}

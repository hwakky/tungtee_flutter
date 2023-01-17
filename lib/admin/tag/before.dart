import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/custom_textfield.dart';
import 'Category.dart';

class BeforeTagPage extends StatefulWidget {
  final String uid;
  const BeforeTagPage({Key? key, required this.uid}) : super(key: key);

  @override
  _BeforeTagPageState createState() => _BeforeTagPageState();
}

class _BeforeTagPageState extends State<BeforeTagPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DismissKeyboard(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: mobileBackgroundColor,
          body: Categoryone(),
        ),
      ),
    );
  }
}

class Categoryone extends StatelessWidget {
  final CollectionReference _categorys =
      FirebaseFirestore.instance.collection('categorys');
  Future<void> _delete(String usersId) async {
    await _categorys
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites list')
        .doc(usersId)
        .delete();
  }

  final TextEditingController _CategoryController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final categorysSet = FirebaseFirestore.instance.collection('categorys').doc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: mobileBackgroundColor,
        leadingWidth: 130,
        centerTitle: true,
        leading: Container(
          padding: const EdgeInsets.all(0),
          child: Image.asset('assets/images/logo with name.png',
              fit: BoxFit.scaleDown),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: purple,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _categorys.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
            }
            // return Container(child: Text('hi'),);
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => Container(
                      child: CategoryWidget(
                          snap: (snapshot.data! as dynamic).docs[index]),
                    ));
          }),
    );
  }
}

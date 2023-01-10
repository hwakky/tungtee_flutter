import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangteevs/Homepage.dart';
import 'package:tangteevs/profile/Profile.dart';
import 'package:tangteevs/regis,login/Registernext.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../helper/helper_function.dart';
import '../team/privacy.dart';
import '../team/team.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

class IdcardPage extends StatefulWidget {
  final String uid;
  const IdcardPage({Key? key, required this.uid}) : super(key: key);

  @override
  _IdcardPageState createState() => _IdcardPageState();
}

class _IdcardPageState extends State<IdcardPage> {
  DatabaseService databaseService = DatabaseService();
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  bool isChecked = false;
  bool isadmin = false;
  String bio = "";
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String _ImageidcardController = '';
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  File? media;
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  var userData = {};
  var postLen = 0;
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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      _ImageidcardController = userData['idcard'].toString();
      _dayController.text = userData['day'].toString();
      _monthController.text = userData['month'].toString();
      _yearController.text = userData['year'].toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 120,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "VERIFICATION",
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            color: purple,
            shadows: [
              Shadow(
                blurRadius: 5,
                color: Colors.grey,
                offset: Offset(3, 3),
              ),
            ],
          ),
        ),
        // ignore: prefer_const_constructors
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-20),
          child: const Text("ยืนยันตัวตนของคุณ",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: unselected)),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("กรอกวันเดือนปีเกิดของคุณ",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'MyCustomFont',
                            color: unselected)),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      width: 360,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dayController,
                              keyboardType: TextInputType.number,
                              decoration: textInputDecorationp.copyWith(
                                  hintText: "Day",
                                  prefixIcon: Icon(
                                    Icons.view_day,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "plase Enter Your Day";
                                } else if (int.parse(val) >= 31) {
                                  return 'Day must less than 31';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _monthController,
                              readOnly: true,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '1';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('1'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '2';

                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('2'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '3';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('3'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '4';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('4'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '5';

                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('5'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '6';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('6'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '7';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('7'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '8';

                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('8'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '9';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('9'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '10';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('10'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '11';

                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('11'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            _monthController.text = '12';
                                            // Close the dialog
                                            Navigator.pop(context);
                                          },
                                          child: Text('12z'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              enableInteractiveSelection: false,
                              decoration: textInputDecorationp.copyWith(
                                hintText: 'month',
                                prefixIcon: Icon(
                                  Icons.calendar_month,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _yearController,
                              keyboardType: TextInputType.number,
                              decoration: textInputDecorationp.copyWith(
                                  hintText: "year",
                                  prefixIcon: Icon(
                                    Icons.view_day,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "plase Enter year";
                                } else if (int.parse(val) >= 2008) {
                                  return 'your age must be more than 15';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("โปรดถ่ายให้ตรงกรอบ เพื่อความชัดเจน",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'MyCustomFont',
                            color: unselected)),
                    SizedBox(
                        height: 120,
                        child: media != null
                            ? Image.file(media!)
                            : Image.asset('assets/images/id-card.png')),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: purple,
                          minimumSize: const Size(268, 36),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        print('${file?.path}');

                        if (file == null) return;
                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('idcard');
                        Reference referenceImageToUpload =
                            referenceDirImages.child("${user?.uid}");
                        try {
                          //Store the file
                          await referenceImageToUpload.putFile(File(file.path));
                          //Success: get the download URL
                          _ImageidcardController =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (error) {
                          //Some error occurred
                        }
                        setState(() {
                          media = File(file.path);
                        });
                        print(_ImageidcardController);
                      },
                      child: const Text("Take a photo of idcard"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                        "ข้อแนะนำ:\nหลีกเลี่ยงแสงสะท้อน และความมืดเกินไป \nรูปไม่เบลอ เห็นตัวอักษรชัดเจน ",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'MyCustomFont',
                            color: unselected)),
                    const SizedBox(
                      height: 120,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;

                              isadmin = false;
                            });
                          },
                        ),
                        Text.rich(TextSpan(
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'MyCustomFont'),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    "ฉันขอรับรองว่ามีอายุมากกว่า 15 ปี และยอมรับ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                                recognizer: TapGestureRecognizer()),
                            TextSpan(
                                text: "เงื่อนไขการใช้งาน\n",
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, TermsPage());
                                  }),
                            TextSpan(
                                text: "และ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                                recognizer: TapGestureRecognizer()),
                            TextSpan(
                                text: "นโยบายความเป็นส่วนตัว",
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, PrivacyPage());
                                  }),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(
                      width: 307,
                      height: 49,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isChecked ? purple : unselected,
                            minimumSize: const Size(268, 49),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              'Next',
                              style: TextStyle(
                                  fontSize: 22, fontFamily: 'MyCustomFont'),
                            ), // <-- Text
                            const SizedBox(
                              width: 3,
                            ),
                            const Icon(
                              // <-- Icon
                              Icons.navigate_next_sharp,
                              size: 26.0,
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (isChecked == true) {
                            Updata();
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Updata() async {
    final String Imageidcard = _ImageidcardController.toString();
    final String day = _dayController.text;
    final String month = _monthController.text;
    final String year = _yearController.text;

    if (_formKey.currentState!.validate()) {
      await _users.doc(widget.uid).update({
        "idcard": Imageidcard,
        "day": day,
        "month": month,
        "year": year,
      });
      _ImageidcardController = '';
      _dayController.text = '';
      _monthController.text = '';
      _yearController.text = '';
      nextScreen(
          context, RegisnextPage(uid: FirebaseAuth.instance.currentUser!.uid));
    }
  }
}

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tangteevs/regis,login/firestore.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:tangteevs/helper/helper_function.dart';
import 'package:tangteevs/Homepage.dart';
import '../team/privacy.dart';
import '../team/team.dart';
import 'Login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tangteevs/regis,login/Verify.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegisterPage> {
  bool isChecked = false;
  File? media;
  File? media1;
  bool _isLoading = false;
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String password2 = "";
  String fullName = "";
  AuthService authService = AuthService();
  String Displayname = "";
  String age = "";
  String gender = "";
  String Imageidcard = "";
  String ImageProfile = "";
  String bio = "";
  bool isadmin = false;
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = 'Select Gender';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "REGISTER",
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
                        const SizedBox(height: 10),
                        const Text("สร้างบัญชีของคุณเลยสิ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        // Image.asset("assets/register.png"),
                        const SizedBox(
                          height: 35,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Username",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Confirm Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (password == password2) {
                              return null;
                            } else {
                              return "Password does not match";
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password2 = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "PROFILE",
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
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("กรอกข้อมูลส่วนตัวของคุณ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 25,
                        ),

                        InkWell(
                          onTap: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            print('${file?.path}');

                            if (file == null) return;
                            String uniqueFileName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('Profile');
                            Reference referenceImageToUpload =
                                referenceDirImages.child("${user?.uid}");
                            try {
                              //Store the file
                              await referenceImageToUpload
                                  .putFile(File(file.path));
                              //  Success: get the download URL
                              ImageProfile =
                                  await referenceImageToUpload.getDownloadURL();
                            } catch (error) {
                              //Some error occurred
                            }
                            setState(() {
                              media1 = File(file.path);
                            });
                          },
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(500),
                                child: media1 != null
                                    ? Image.file(media1!)
                                    : Image.asset('assets/images/profile.png')),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Display Name",
                              prefixIcon: Icon(
                                Icons.person_pin_circle_sharp,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "plase Enter Display Name";
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              Displayname = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Age",
                                    prefixIcon: Icon(
                                      Icons.cake,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "plase Enter Your Age";
                                  } else if (int.parse(val) < 15) {
                                    return 'Age must be 15 or older';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    age = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: textEditingController,
                                readOnly: true,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            onPressed: () {
                                              textEditingController.text =
                                                  'Male';
                                              // Update the gender value using setState
                                              setState(() {
                                                gender = 'Male';
                                              });
                                              // Close the dialog
                                              Navigator.pop(context);
                                            },
                                            child: Text('Male'),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () {
                                              textEditingController.text =
                                                  'Female';
                                              // Update the gender value using setState
                                              setState(() {
                                                gender = 'Female';
                                              });
                                              // Close the dialog
                                              Navigator.pop(context);
                                            },
                                            child: Text('Female'),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () {
                                              textEditingController.text =
                                                  'Other';
                                              // Update the gender value using setState
                                              setState(() {
                                                gender = 'Other';
                                              });
                                              // Close the dialog
                                              Navigator.pop(context);
                                            },
                                            child: Text('Other'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                enableInteractiveSelection: false,
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Select Gender',
                                  prefixIcon: Icon(
                                    Icons.wc_sharp,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          maxLines: 5,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Introduce yourself",
                              prefixIcon: Icon(
                                Icons.pending,
                                color: Theme.of(context).primaryColor,
                              )),
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "plase Enter Your bio";
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              bio = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              minimumSize: const Size(200, 49),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.camera);
                            print('${file?.path}');

                            if (file == null) return;
                            String uniqueFileName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('idcard');
                            Reference referenceImageToUpload =
                                referenceDirImages.child("${user?.uid}");
                            try {
                              //Store the file
                              await referenceImageToUpload
                                  .putFile(File(file.path));
                              //Success: get the download URL
                              Imageidcard =
                                  await referenceImageToUpload.getDownloadURL();
                            } catch (error) {
                              //Some error occurred
                            }
                            setState(() {
                              media = File(file.path);
                            });
                            print(Imageidcard);
                          },
                          child: const Text("Take a photo of idcard"),
                        ),
                        SizedBox(
                            height: 120,
                            child: media != null
                                ? Image.file(media!)
                                : Image.asset('assets/images/id-card.png')),

                        const SizedBox(
                          height: 20,
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
                                    text: "การลงชื่อเข้าใช้แสดงว่าคุณยอมรับ",
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
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isChecked ? purple : unselected,
                                minimumSize: const Size(307, 49),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              if (isChecked == true) {
                                register();
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "มีบัญชีแล้วหรอ? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: " เข้าสู่ระบบ",
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, Login());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password,
              Imageidcard, age, ImageProfile, Displayname, gender, bio, isadmin)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserImageidcardSF(Imageidcard);
          await HelperFunctions.saveUserAgeSF(age);
          await HelperFunctions.saveUserImageprofileSF(ImageProfile);
          await HelperFunctions.saveUserDisplaySF(Displayname);
          await HelperFunctions.saveUserGenderSF(gender);
          await HelperFunctions.saveUserBioSF(bio);

          nextScreenReplace(this.context, MyHomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

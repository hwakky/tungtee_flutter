import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String email;
  final String age;
  final String Imageidcard;
  final String Imageprofile;
  final String Displayname;
  final String gender;
  final String bio;
  final String uid;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.age,
    required this.Imageidcard,
    required this.Imageprofile,
    required this.Displayname,
    required this.gender,
    required this.bio,
    required this.uid,
  });

  // from map
  factory UserModel.fromMap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      fullName: snapshot["fullName"],
      email: snapshot["email"],
      age: snapshot["age"],
      Imageidcard: snapshot["Imageidcard"].toString(),
      Imageprofile: snapshot["Imageprofile"].toString(),
      Displayname: snapshot["Displayname"],
      gender: snapshot["gender"],
      bio: snapshot["bio"],
      uid: snapshot["uid"],
    );
  }

  // to map
  Map<String, dynamic> toJson() => {
        "username": fullName,
        "age": age,
        "email": email,
        "Imageidcard": Imageidcard,
        "bio": bio,
        "Imageprofile": Imageprofile,
        "Displayname": Displayname,
        "gender": gender,
        "uid": uid,
      };
}

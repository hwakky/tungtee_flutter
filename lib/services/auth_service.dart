import 'package:tangteevs/helper/helper_function.dart';
import 'package:tangteevs/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
      String fullName,
      String email,
      String password,
      String Imageidcard,
      String age,
      String Imageprofile,
      String Displayname,
      String gender,
      String bio,
      bool isadmin) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(fullName, email,
            age, Imageidcard, Imageprofile, Displayname, gender, bio, isadmin);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future authsignOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserImageidcardSF("");
      await HelperFunctions.saveUserImageprofileSF("");
      await HelperFunctions.saveUserAgeSF("");
      await HelperFunctions.saveUserDisplaySF("");
      await HelperFunctions.saveUserGenderSF("");
      await HelperFunctions.saveUserBioSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}

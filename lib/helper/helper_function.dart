import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userAgeKey = "USERAGEKEY";
  static String userImageidcardKey = "USERIMAGEIDCARDKEY";
  static String userImageprofileKey = "USERIMAGEPROFILEKEY";
  static String userDisplayKey = "USERDISPLAYKEY";
  static String userGenderKey = "USERGENDERKEY";
  static String userBioKey = "USERBIOKEY";
  static String userIsadminKey = "USERISADMINKEY";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserAgeSF(String userAge) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userAgeKey, userAge);
  }

  static Future<bool> saveUserImageidcardSF(String userImageidcard) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userImageidcardKey, userImageidcard);
  }

  static Future<bool> saveUserImageprofileSF(String userImageprofile) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userImageprofileKey, userImageprofile);
  }

  static Future<bool> saveUserDisplaySF(String userDisplay) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userDisplayKey, userDisplay);
  }

  static Future<bool> saveUserGenderSF(String userGender) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userGenderKey, userGender);
  }

  static Future<bool> saveUserBioSF(String userBio) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userBioKey, userBio);
  }
   static Future<bool> saveUserIsadminSF(bool userIsadmin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userIsadminKey, userIsadmin);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserAgeFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userAgeKey);
  }

  static Future<String?> getUserImageidcardFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userImageidcardKey);
  }

  static Future<String?> getUserImageprofileFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userImageprofileKey);
  }

  static Future<String?> getUserDisplayFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userDisplayKey);
  }

  static Future<String?> getUserGenderFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userGenderKey);
  }

  static Future<String?> getUserBioFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userBioKey);
  }
  static Future<bool?> getUserIsadminFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userIsadminKey);
  }
}

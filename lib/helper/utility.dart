import 'package:shared_preferences/shared_preferences.dart';

class UtilityFunctions {
  static String userLoggedInKey = "UID";
  static String userNameKey = "Name";
  static String userEmailKey = "email";
  UtilityFunctions({String? uid, String? name, String? email}) {
    print(uid);
    uid != null ? userLoggedInKey = uid : null;
    name != null ? userNameKey = name : null;
    email != null ? userEmailKey = email : null;
    print(uid);
  }
//return the user logged in key to check if the user is logged in
  static Future<bool?> getLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getBool(userLoggedInKey);
  }

//GETTERS
  static Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  //Saving data to SF
  static Future<bool> saveUserLoggedInStatus(bool isUserLogin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLogin);
  }

  static Future<bool> saveUserEmailSf(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, email);
  }

  static Future<bool> saveUserNameSF(String name) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, name);
  }
}

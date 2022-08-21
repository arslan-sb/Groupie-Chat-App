import 'package:chat_app/helper/utility.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UtilityFunctions? _userFromFireBaseUser(User? user) {
    return user != null ? UtilityFunctions(uid: user.uid) : null;
  }

//Check the current login status
  Stream<UtilityFunctions?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFireBaseUser(user));
  }

  //sign in anonamously
  Future signInAnonamously() async {
    try {
      User user = (await _auth.signInAnonymously()).user!;

      if (user != null) {
        await DataBaseService(uid: user.uid)
            .savingUserData("anonamous", "NOEMAIL");
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  //sign in with email password
  Future userLoginEmailPassword(String email, String password) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  //Register with email password
  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //Call database to update user data
        await DataBaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await UtilityFunctions.saveUserEmailSf("");
      await UtilityFunctions.saveUserLoggedInStatus(false);
      await UtilityFunctions.saveUserNameSF('');
      await _auth.signOut();
      return true;
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

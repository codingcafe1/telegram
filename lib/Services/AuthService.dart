import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegramchatapp/Helpers/HelperFunctions.dart';
import 'package:telegramchatapp/Models/user.dart';
import 'package:telegramchatapp/Services/DatabaseService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User _userFromFirebaseUser (FirebaseUser user) {
    return (user != null) ? User(uid: user.uid) : null;
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword (String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerWithEmailAndPassword (String fullName, String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // Create a new document for user with uid
      await DatabaseService(uid: user.uid).updateUserData(fullName, email, password);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut () async {
    try {
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.saveUserEmailSharedPreference('');
      await HelperFunctions.saveUserNameSharedPreference('');

      return await _auth.signOut().whenComplete(() async {
        print("Logged out");
        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
          print("Logged in $value");
        });
        await HelperFunctions.getUserEmailSharedPreference().then((value) {
          print("Email $value");
        });
        await HelperFunctions.getUserNameSharedPreference().then((value) {
          print("Full name $value");
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

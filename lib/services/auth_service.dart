import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firepost/pages/signIn_page.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;



  //SIGN UP METHOD
  static Future signUp({required String email, required String password}) async {
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      print(user.toString());
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  //SIGN IN METHOD
  static Future signIn({required String email, required String password}) async {
    try {
      User? user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
      print(user.toString());
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  //SIGN OUT METHOD
  static Future signOut(BuildContext context) async {
    await _auth.signOut();
    // Write Prefs removeUserId
    Prefs.removeUserId().then((value) => {
      Navigator.pushReplacementNamed(context, SignInPage.id),
    });

    print('signout');
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/home_page.dart';
import 'package:firepost/pages/signUp_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/utils_service.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const String id = "signIn_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    AuthService.signIn(email: email, password: password).then((user) => {
          _getFirebaseUser(user),
        });
  }

  _getFirebaseUser(User? user) async {
    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils().showToast("Check your email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "Email"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _doSignIn,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Don't have an account?"),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, SignUpPage.id);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink()
        ],
      )),
    );
  }
}

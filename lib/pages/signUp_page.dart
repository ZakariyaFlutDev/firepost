import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/signIn_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/utils_service.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String id =  "signUp_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool _isLoading = false;

  var firstNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp(){
    String firstName = firstNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(firstName.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    AuthService.signUp(email: email, password: password).then((user) => {
      _getUser(user),
    });
  }
  
    _getUser(User? user) async{

    setState(() {
      _isLoading = false;
    });

    if(user!=null){
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
      Utils().showToast("Your infos are wrong");
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
                      controller: firstNameController,
                      decoration: InputDecoration(
                          hintText: "First Name"
                      ),
                    ),

                    SizedBox(height: 20,),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email"
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: "Password"
                      ),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: _doSignUp,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        color: Colors.blue,
                        child: Center(
                          child: Text("Sign Up", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Already have an account?"),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacementNamed(context, SignInPage.id);
                          },
                          child: Text("Sign in", style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                      ],
                    )
                  ],
                ),
              ),
              _isLoading ?
                  Center(
                    child: CircularProgressIndicator(),
                  ) :
                  SizedBox.shrink()
            ],
          )
      ),
    );
  }
}

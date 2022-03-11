import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firepost/pages/detail_page.dart';
import 'package:firepost/pages/home_page.dart';
import 'package:firepost/pages/signIn_page.dart';
import 'package:firepost/pages/signUp_page.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot){
          if(snapshot.hasData){
            Prefs.saveUserId(snapshot.data!.uid);
            return HomePage();
          }else{
            Prefs.removeUserId();
            return SignInPage();
          }
        }
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _startPage(),
      routes: {
        HomePage.id:(context) => HomePage(),
        SignInPage.id:(context) => SignInPage(),
        SignUpPage.id:(context) => SignUpPage(),
        DetailPage.id:(context) => DetailPage(),
      },
    );
  }
}

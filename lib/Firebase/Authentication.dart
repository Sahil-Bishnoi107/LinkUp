import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkup/screens/HomePage.dart';
import 'package:linkup/screens/LoginPage.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
     builder: (context,snapshot){
      if(snapshot.hasData){return Homepage();}
      else{return LoginPage();}
     }
     
     
     );
  }
}
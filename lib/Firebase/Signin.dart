import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkup/screens/HomePage.dart';
import 'package:linkup/screens/google.dart';
import 'package:linkup/theme/theme.dart';

Future<void> signin(BuildContext context,String email,String password) async{
  try{
  final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  //final user = cred.user!.uid;
  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
  }



  catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Row(
     children: [
     Text("Invalid User Data",
     style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont),),
     SizedBox(width: 70,),
     InkWell(onTap: (){

     },
      child: Material( elevation: 5,
      child:Container(
        height: 35,width: 180,
      color: MyTheme().logincolor,
      child:Center(
      child: Text("FORGOT PASSWORD", style: TextStyle(
      color: Colors.white,fontFamily:MyTheme().loginfont
     ),
     )
     )
     )
     )
     )
     ]),
     backgroundColor: Colors.white,duration: Duration(seconds: 3),),
    );
  }
}


Future<void> Register(String name,String userid,String email,String password,BuildContext context) async{
  try{
  final use = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  await Future.delayed(Duration(seconds: 1));
  final uid = use.user!.uid;
  createnewuser(uid, name, userid, email);
  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
  }

  catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(
     child:  Text("User could not be Registered",style: TextStyle(color: MyTheme().logincolor),),),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.white,
      )
    );
  }
}

 Future<void> GoogleSignin(BuildContext context) async{
  
     await GoogleSignIn().signOut(); 
    final GoogleSignInAccount? myaccount = await GoogleSignIn().signIn();
    if(myaccount == null) return;
    final GoogleSignInAuthentication myauth = await myaccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: myauth.accessToken,
      idToken: myauth.idToken,
    );
   final mydata =  await FirebaseAuth.instance.signInWithCredential(credential);
   final me = mydata.user;
   if (me == null) throw Exception("User not found");
   final saveddata = await FirebaseFirestore.instance.collection('users').doc(me.uid).get();
   if(!saveddata.exists  ){
        if(context.mounted){
        await Future.delayed(Duration(seconds: 1));
     Navigator.push(context, MaterialPageRoute(builder: (context) => Google(me: me)));}
   }
    else{
      if(context.mounted){
        await Future.delayed(Duration(seconds: 1));
    Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));}
    }
  }
  
 

 Future<void> createnewuser(String uid, String name,String userid,String email) async{
 await FirebaseFirestore.instance.collection('users').doc(uid).set(
    {
      "Name":name + " ", "UserId":userid, "Email":email, "Uid":uid
    }
  );
 }
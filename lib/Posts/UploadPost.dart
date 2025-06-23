import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UploadPost extends ChangeNotifier{
  final myself = FirebaseAuth.instance.currentUser;
  
  String posturl = "";
  void reseturl(){
    posturl = "";
    notifyListeners();
  }
  Future<void> Post(String des) async{
    String myuid = myself == null ? "" : myself!.uid;
    final me = await FirebaseFirestore.instance.collection('users').doc(myuid).get();
    String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('users').doc(myuid).collection('posts').doc(timestampId).set(
      {
    "pic":posturl,"des":des,"sender":myuid, "name": me['Name'],"mypic":me["profilepic"],"time":timestampId
      }
    ); 
  }

  void update(){
    notifyListeners();
  }


}
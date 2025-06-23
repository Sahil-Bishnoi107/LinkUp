import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewProfileProvider extends ChangeNotifier{
  DocumentSnapshot? viewprofileuid;
  String profilepic = "";
  String city = "";
  String bio = "";
  List<String> intrests = [];
  String username = "";
  String userid = "";
  int nooffriends = 0;
  

 
 Future<void> getProfileInfo(String frienduid) async {
  final temppic = await FirebaseFirestore.instance.collection('users').doc(frienduid).get();
  profilepic = temppic.data()?['profilepic'] ?? "";

  final tempcity = await FirebaseFirestore.instance.collection('users').doc(frienduid).collection('profile').doc('city').get();
  city = tempcity.exists ? (tempcity.data()?['city'] ?? "Mars,Milky Way") : "Mars,Milky Way";

  final tempbio = await FirebaseFirestore.instance.collection('users').doc(frienduid).collection('profile').doc('bio').get();
  bio = tempbio.exists ? (tempbio.data()?['bio'] ?? "") : "";

  final templist = await FirebaseFirestore.instance.collection('users').doc(frienduid).collection('profile').doc('intrests').collection('myintrest').get();
  List<String> temp = [];
  for (var doc in templist.docs) { temp.add(doc['intrest']); }
  intrests = temp;

  final tempname = await FirebaseFirestore.instance.collection('users').doc(frienduid).get();
  username = tempname['Name'];
  userid = tempname['UserId'];

  final tempcount = await FirebaseFirestore.instance.collection('users').doc(frienduid).collection('friends').get();
  nooffriends = tempcount.docs.length;

  notifyListeners();
}

 void cleardata(){
  username = "";userid = "";
  notifyListeners();
 }
}
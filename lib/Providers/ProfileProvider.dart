import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profileprovider extends ChangeNotifier {
  double buttonelevation = 5;
  bool intrestedit = false;
 List<DocumentSnapshot> myinterests = [];
 final myself = FirebaseAuth.instance.currentUser;

 

  String myname = "User";
  String myId = "UserId";




 Future<void> getmyowninfo() async{
  final myuid = myself?.uid; 
  final tempobj = await FirebaseFirestore.instance.collection('users').doc(myuid).get();
  final doc = tempobj.data();
  myname = doc!['Name'];
  myId = doc['UserId'];
  notifyListeners();
 }



 Future<void> checkIntrests() async{
  final myuid = myself?.uid; 
  List<DocumentSnapshot> templist = [];
  final temp = await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('intrests').collection('myintrest').get();
  for(var i in temp.docs){
    templist.add(i); // adding all documents in the list,so these are documents directly. so myintrests[index] is a doc
  }
 // myinterests.clear();
  myinterests = templist;
  notifyListeners();
 }

 Future<void> AddIntrests(String intrest) async{
  final myuid = myself?.uid;
  if(intrest.isEmpty){return;}
  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('intrests').collection('myintrest').doc(intrest).set({
  'intrest':intrest
  });
  checkIntrests();
  notifyListeners();
 }

 //buttonanimation
 void buttonanimation(){
  buttonelevation = 0;
  notifyListeners();
  Future.delayed(Duration(milliseconds: 200),(){
  buttonelevation = 5;
  notifyListeners();
  }
  );
 }

 void Toggleintrestedit(){
  intrestedit = !intrestedit;
  notifyListeners();
 }



 //bio manager
 String bio = "";
 bool edittext = false;

 Future<void>  checkBio() async {
  final myuid = myself?.uid;
  final temp =  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('bio').get();
  final obj = temp.data();
  if(obj == null) return;
  bio = obj['bio']; 
  notifyListeners();
 }
 Future<void> updateBio(String text) async{
  final myuid = myself?.uid;
  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('bio').set({
  "bio":text
  });
  checkBio();
 }
 void flipTextEditing(){
  edittext = !edittext;
  notifyListeners();
 }

 //City manager
 String city = "";
 bool editcity = false;
 Future<void> checkcity() async{
  final myuid = myself?.uid;
  final temp = await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('city').get();
  final tempcity = temp.data();
  if(tempcity == null) return;
  city = tempcity['city'];
  notifyListeners();
 }
 Future<void> updatecity(String text) async{
  final myuid = myself?.uid;
  final temp = await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('city').set(
    {"city" : text}
  );
  checkcity();
 }
 void togglecityedit(){
  editcity = !editcity;
  notifyListeners();
 }

 //ProfilePicture
 String url = "";
 Future<void> getProfileImage() async{
  final myuid = myself?.uid;
  final mf = await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('pic').get();
  final img = mf.data();
  if(img == null) return;
  url = img['picUrl'];
  notifyListeners(); 
 }
 void immediatelyupadte(urrl){
    url = urrl;
    notifyListeners();
  }

}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkup/Objects/FriendsObject.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Friendsprovider extends ChangeNotifier{
  List<String> suggestionList = [];
  List<DocumentSnapshot> friendrequestsuid = [];
  List<DocumentSnapshot> friendrequests = [];
  List<FriendObject> friends = [];
  //List<String> friendreuests = [];
  
  List<DocumentSnapshot> suggestions = [];
  final myself = FirebaseAuth.instance.currentUser;
  



  Future<DocumentSnapshot> getUserFromUid(String uid) async{
   return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }
  //TO Show Suggestions
  Future<void> showSuggestions(String text) async{
    
    if(text.isEmpty){
    suggestionList = [];
    suggestions = [];
    notifyListeners();
    return;
    }
    List<String> tempList = [];

  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  for (var doc in snapshot.docs) {
    final username = doc['Name'];
    if (username.toLowerCase().contains(text.toLowerCase())) {
      tempList.add(doc.id); 
    }
  }
  suggestionList = tempList;
  await fetchUserDocs(suggestionList,text);
  notifyListeners();
  }
Future<void> fetchUserDocs(List<String> uids,String text) async {
  List<DocumentSnapshot> tempList = [];
 
  
  for (String uid in uids) {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    tempList.add(doc);
  }
  suggestions = tempList;
  }

  // SEND FRIEND REQUEST COLLECTION
Future<bool> CheckRequest(String uid) async{
  final myuid = myself!.uid; 
  final user =  FirebaseFirestore.instance.collection('users').doc(uid).collection('friendrequests').doc(myuid);
  final userdoc = await user.get();
  return userdoc.exists;
}
Future<bool> CheckFriend(String uid) async{
  final myuid = myself?.uid;
  if(myuid == null){return false;}
  final user =  FirebaseFirestore.instance.collection('users').doc(myuid).collection('friends').doc(uid);
  final userdoc = await user.get();
  return userdoc.exists;
}
Future<void> SendRequest(String uid) async{
final myuid = myself?.uid;
await FirebaseFirestore.instance.collection('users').doc(uid).collection('friendrequests').doc(myuid).set(
  {
    'uid': myuid
  }
);
}

//To show recieved requests
void listenToFriendRequests() {
  final myUid = FirebaseAuth.instance.currentUser?.uid;
  if (myUid == null) return;

  FirebaseFirestore.instance
      .collection('users')
      .doc(myUid)
      .collection('friendrequests')
      .snapshots()
      .listen((snapshot) async{
    friendrequestsuid = snapshot.docs;
    friendrequests.clear();
    for(DocumentSnapshot snapshot in friendrequestsuid){
    friendrequests.add( await getUserFromUid(snapshot['uid']));
   }
    notifyListeners(); 
  });
}

//Add friend 
Future<void> Accept (String uid) async{
  final myUid = FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.uid : "User" ;
  String chatId = (uid.compareTo(myUid) <= 0) ? uid + myUid : myUid + uid;
  await FirebaseFirestore.instance.collection('Chats').doc(chatId).set({
  'uid1' : uid, 'uid2' : myUid, 'chatId' : chatId,'lastmessage':""
  }
  );
  await FirebaseFirestore.instance.collection('users').doc(myUid).collection('friends').doc(uid).set({
   'chatId' : chatId,'frienduid':uid
  }
  );
  await FirebaseFirestore.instance.collection('users').doc(uid).collection('friends').doc(myUid).set({
   'chatId' : chatId, 'frienduid':myUid
  }
  ); 
}
Future<void> Decline(String uid) async{
  await Future.delayed(Duration(milliseconds: 200));
  final myUid = FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.uid : "User" ;
  await FirebaseFirestore.instance.collection('users').doc(myUid).collection('friendrequests').doc(uid).delete();
}

//To show friends
void listenToFriends() {
  final myUid = FirebaseAuth.instance.currentUser?.uid;
  if (myUid == null) return;

  FirebaseFirestore.instance
      .collection('users')
      .doc(myUid)
      .collection('friends')
      .snapshots()
      .listen((snapshot) async{
      
    List<FriendObject> temp = [];
    for(DocumentSnapshot snapshot in snapshot.docs){
    
    temp.add( FriendObject(snapshot: await getUserFromUid(snapshot['frienduid']), chatid: snapshot['chatId']));
   }
   friends = temp;
    notifyListeners();
  });
}




List<String> groupsuggestionList = [];
 List<DocumentSnapshot> groupsuggestions = [];
 Future<void> groupshowSuggestions(String text) async{
    
    if(text.isEmpty){
    groupsuggestionList = [];
    groupsuggestions = [];
    notifyListeners();
    return;
    }
    List<String> tempList = [];

  final snapshot = await FirebaseFirestore.instance.collection('groups').get();
  for (var doc in snapshot.docs) {
    final username = doc['groupname'];
    if (username.toLowerCase().contains(text.toLowerCase())) {
      tempList.add(doc.id); 
    }
  }
  groupsuggestionList = tempList;
  await groupfetchUserDocs(groupsuggestionList,text);
  notifyListeners();
  }
Future<void> groupfetchUserDocs(List<String> uids,String text) async {
  List<DocumentSnapshot> tempList = [];
 
  
  for (String uid in uids) {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(uid)
        .get();
    tempList.add(doc);
  }
  groupsuggestions = tempList;
  }

}



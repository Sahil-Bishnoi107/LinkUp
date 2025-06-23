import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



class Teamsprovider extends ChangeNotifier{
 final myself = FirebaseAuth.instance.currentUser;
 List<DocumentSnapshot> teams = [];
 List<DocumentSnapshot> teammembers = [];
 List<DocumentSnapshot> chats = [];
 String AdminUid = "";


 DocumentSnapshot? currentteam;

 void cleardata(){
  currentteam = null;
 }


 void instantupdateteampic(String url){
 // profilepic = url;
  notifyListeners();
 }
 Future<void> LoadTeamPic(String teamuid) async{
  currentteam = null;
  final myuid = myself?.uid;
  final temp = await FirebaseFirestore.instance.collection('teams').doc(teamuid).get();
  currentteam = temp;
 }

 void showMembers(String teamuid){
  FirebaseFirestore.instance.collection('teams').doc(teamuid).collection('members').snapshots().listen(
    (snapshot) async{
      List<DocumentSnapshot> temp = [];
      for(var doc in snapshot.docs){
        final mydoc = await FirebaseFirestore.instance.collection('users').doc(doc['memberuid']).get();
        temp.add(mydoc);
        print("dcdck");
      }
      teammembers = temp;
      notifyListeners();
    }
  );
 }
 Future<String> generateTeamUid() async{
  final x = await FirebaseFirestore.instance.collection('teams').get();
  int no = x.docs.length;
  return "team" + (no+1).toString();
 }

 Future<String> getuser(String? uid) async{
   final o = await FirebaseFirestore.instance.collection('users').doc(uid).get();
   return o['Name'];
 }

  Future<void> createTeam(String teamname) async{
    final myuid = myself?.uid;
    String x = await generateTeamUid();
    await FirebaseFirestore.instance.collection('teams').doc(x).set({
    "adminUid": myuid ,"teamname":teamname,"teamuid":x , "profilepic":"","lastmessage":""
    });
    String h = await getuser(myuid);
    await FirebaseFirestore.instance.collection('teams').doc(x).collection('members').doc(myuid).set({
      "memberuid":myuid, "username": h,"isadmin" : true
    });
    await FirebaseFirestore.instance.collection('users').doc(myuid).collection('teams').doc(x).set({
      "teamuid": x, "teamname":teamname
    });
  }

void showTeams() {
  final myuid = myself?.uid;
  FirebaseFirestore.instance
      .collection('users')
      .doc(myuid)
      .collection('teams')
      .snapshots()
      .listen((snapshot) async {
    List<DocumentSnapshot> temp = [];
    for (var doc in snapshot.docs) {
      final teamuid = doc['teamuid'];
      final teamDoc = await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamuid)
          .get();
      temp.add(teamDoc);
    }
    teams = temp;
    notifyListeners();
  });
}


  Future<void> AddMemeber(String userId,String teamuid) async{
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('users').where('UserId',isEqualTo: userId).get();
    try{
    String uid = "";
    for(var doc in snap.docs){uid = doc['Uid'];}
    final temp = await FirebaseFirestore.instance.collection('teams').doc(teamuid).get();
    final teamname = temp['teamname'];
    final myuid = myself?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('teams').doc(teamuid).set({
     'teamuid':teamuid,"teamname":teamname
    });
    String h = await getuser(myuid);
    await FirebaseFirestore.instance.collection('teams').doc(teamuid).collection('members').doc(uid).set({
    "memberuid":uid, "username":h,"isadmin" :false
    });}
    catch(e){print("failed");}
  }

  Future<void> TeamInfo(String teamuid)async{
   final x1 = await FirebaseFirestore.instance.collection('teams').doc(teamuid).collection('members').get();
   teammembers = x1.docs;
  }
  Future<void> SendMessage(String text,String teamuid)async{
    if(text == ""){return;}
    final myuid = myself?.uid;
    DocumentSnapshot me = await FirebaseFirestore.instance.collection('users').doc(myuid).get();
    final Map<String, dynamic>? data = me.data() as Map<String, dynamic>?;
    String pic =   ( data != null && data.containsKey('profilepic')) ? data['profilepic'] : "";
    String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('teams').doc(teamuid).collection('messages').doc(timestampId).set({
     "text":text , "sender":myuid,"timestamp": FieldValue.serverTimestamp(), "pic": pic
    });

    final s = await FirebaseFirestore.instance.collection('teams').doc(teamuid).get();
    
    await FirebaseFirestore.instance.collection('teams').doc(teamuid).update({
     "lastmessage" : text,"lastmessageuid": myuid
    });

  }

  void displaymessages(teamId){
    print(teamId);
    FirebaseFirestore.instance.collection('teams').doc(teamId).collection('messages').orderBy('timestamp').snapshots().listen((snapshot){ 
    chats = snapshot.docs;
    notifyListeners();
    });
  }
   


}
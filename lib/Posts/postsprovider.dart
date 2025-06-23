import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier{
  final user = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> mygroups = [];
  List<DocumentSnapshot> chats = [];
  List<DocumentSnapshot> posts = [];
  List<DocumentSnapshot> likedposts = [];


  //get liked posts
  Future<void> getlikedposts() async{
    final myuid = user!.uid;
    final temp = await FirebaseFirestore.instance.collection('users').doc(myuid).collection('likedposts').get();
    likedposts = temp.docs;
    notifyListeners();
  }



  Future<void> createGroup(String groupid,String gruopname) async{
    final myuid = user!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(myuid).get();
    await FirebaseFirestore.instance.collection('groups').doc(groupid).set({
      "groupname":gruopname,"groupid":groupid,"lastmessage":"","admin": myuid,"profilepic" : ""
    });
    await FirebaseFirestore.instance.collection('users').doc(myuid).collection('groups').doc(groupid).set({
     "groupid":groupid
     });
     String myname = doc['Name'];
     await FirebaseFirestore.instance.collection('groups').doc(groupid).collection('members').doc(myuid).set({
     "uid":myuid, "Name":myname
     });
  }

  Future<void> joinGroups(String groupid) async{
     final myuid = user!.uid;
     DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(myuid).get();
     String myname = doc['Name'];
     await FirebaseFirestore.instance.collection('groups').doc(groupid).collection('members').doc(myuid).set({
     "uid":myuid, "Name":myname
     });
     await FirebaseFirestore.instance.collection('users').doc(myuid).collection('groups').doc(groupid).set({
     "groupid":groupid
     });
  }

void showGroups() {
  final myuid = user!.uid;
     FirebaseFirestore.instance.collection('users').doc(myuid).collection('groups').snapshots().listen(
      (snapshot) async
      {
        List<DocumentSnapshot> temp = [];
        for(var doc in snapshot.docs){
          final str = doc['groupid'];
          final x = await FirebaseFirestore.instance.collection('groups').doc(str).get();
          temp.add(x);
        }
        mygroups = temp;
        notifyListeners();
     });
  }

   Future<void> SendMessage(String text,String groupid)async{
    if(text == ""){return;}
    final myuid = user?.uid;
    DocumentSnapshot me = await FirebaseFirestore.instance.collection('users').doc(myuid).get();
    final Map<String, dynamic>? data = me.data() as Map<String, dynamic>?;
    String pic =   ( data != null && data.containsKey('profilepic')) ? data['profilepic'] : "";
    String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('groups').doc(groupid).collection('messages').doc(timestampId).set({
     "text":text , "sender":myuid,"timestamp": FieldValue.serverTimestamp(), "pic": pic
    });
    final s = await FirebaseFirestore.instance.collection('groups').doc(groupid).get(); 
    await FirebaseFirestore.instance.collection('groups').doc(groupid).update({
     "lastmessage" : text,"lastmessageuid": myuid
    });
  }

   void displaymessages(groupId){
    FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages').orderBy('timestamp').snapshots().listen((snapshot){ 
    chats = snapshot.docs;
    notifyListeners();
    });
  }
  

  Future<void> viewposts() async{
    final myuid = user?.uid;
    final allgroups = await FirebaseFirestore.instance.collection('users').doc(myuid).collection('friends').get();
    List<DocumentSnapshot> temp = [];
    for(var doc in allgroups.docs){
     final tempposts = await FirebaseFirestore.instance.collection('users').doc(doc['frienduid']).collection('posts').get();
     for(var post in tempposts.docs){
      temp.add(post);
     }
    }
    posts = temp;
    notifyListeners();
  }
   
  

  Future<void> postReply(String reply,String uid,String postid)async{
    if(reply == "") return;
    final myuid = user?.uid;
    String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    final f = await FirebaseFirestore.instance.collection('users').doc(myuid).get();
   await FirebaseFirestore.instance.collection('users').doc(uid).collection('posts').doc(postid).collection('comments').doc(timestampId).set({
    "reply":reply, "sender" : myuid, "name":f['Name'], "profilepic" : f['profilepic'], "commentid": timestampId
   });
  }


   
 DocumentSnapshot? currentgroup;

 void cleardata(){
  currentgroup = null;
 }
 void instantupdateteampic(String groupid){
 //LoadTeamPic(groupid);
  notifyListeners();
 }
 Future<void> LoadTeamPic(String groupid) async{
  currentgroup = null;
  final myuid = user?.uid;
  final temp = await FirebaseFirestore.instance.collection('groups').doc(groupid).get();
  currentgroup = temp;
 }
  

  List<DocumentSnapshot> groupmembers = [];
  void showMembers(String groupid){
  FirebaseFirestore.instance.collection('groups').doc(groupid).collection('members').snapshots().listen(
    (snapshot) async{
      List<DocumentSnapshot> temp = [];
      for(var doc in snapshot.docs){
        final mydoc = await FirebaseFirestore.instance.collection('users').doc(doc['uid']).get();
        temp.add(mydoc);
      }
      groupmembers = temp;
      notifyListeners();
    }
  );
 }

 Future<void> likepost(String postid, String friendid) async{
  final myuid = user?.uid;
  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('likedposts').doc(postid).set(
    {
     "postid":postid, "friendid":friendid
    }
  );
  final f =    await FirebaseFirestore.instance.collection('users').doc(myuid).get();
  await FirebaseFirestore.instance.collection('users').doc(friendid).collection('posts').doc(postid).collection('likes').doc(myuid).set({
      "likedby": myuid, "name": f['Name']
  });
 }

 Future<void> unlikepost(String postid, String friendid) async{
  final myuid = user?.uid;
  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('likedposts').doc(postid).delete();
  await FirebaseFirestore.instance.collection('users').doc(friendid).collection('posts').doc(postid).collection('likes').doc(myuid).delete();
 }

 Future<void> addComment(String postid,String frienduid,String comment) async{
  final myuid = user?.uid;
   final f =    await FirebaseFirestore.instance.collection('users').doc(myuid).get();
  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('posts').doc(postid).collection('comments').doc(myuid).set({
      "comment":comment, "name": f['Name']
  });
 }
 
 Future<void> savePost(String postid, String friendid) async{
  final myuid = user?.uid;
  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('savedposts').doc(postid).set(
    {
     "postid":postid, "friendid":friendid
    }
  );
 }


 List<DocumentSnapshot> joinedgroups = [];
 Future<void> getGroups() async{
    final myuid = user?.uid;
   final o =  await FirebaseFirestore.instance.collection('users').doc(myuid).collection('groups').get();
    joinedgroups = o.docs;
    notifyListeners();
 }

 
}